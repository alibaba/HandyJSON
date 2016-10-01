/*
 * Copyright 1999-2101 Alibaba Group.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  Created by zhouzhuo on 7/7/16.
//

import Foundation

public class JSONDeserializer<T: HandyJSON> {
    public static func deserializeFrom(dict: NSDictionary) -> T? {
        return T._transform(dict, toType: T.self) as? T
    }

    public static func deserializeFrom(dict: NSDictionary, designatedPath: String?) -> T? {
        var tmpDict: AnyObject? = dict
        if let paths = designatedPath?.componentsSeparatedByString(".") where paths.count > 0 {
            paths.forEach({ (seg) in
                tmpDict = (tmpDict as? NSDictionary)?.objectForKey(seg)
            })
        }
        if let innerDict = tmpDict as? NSDictionary {
            return deserializeFrom(innerDict)
        }
        return nil
    }

    public static func deserializeFrom(json: String) -> T? {
        return deserializeFrom(json, designatedPath: nil)
    }
    
    public static func deserializeFrom(json: String?) -> T? {
        if let _json = json {
            return self.deserializeFrom(_json)
        } else {
            return nil
        }
    }

    public static func deserializeFrom(json: String, designatedPath: String?) -> T? {
        if let dict = try? NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) {
            if let jsonDict = dict as? NSDictionary {
                return deserializeFrom(jsonDict, designatedPath: designatedPath)
            }
        }
        return nil
    }
}

extension Property {
    
    internal static func _transform(rawData dict: NSDictionary, toPointer pointer: UnsafePointer<Byte>, toOffset currentOffset: Int, byMirror mirror: Mirror, withMapper mapper: HelpingMapper) -> Int {
        
        var currentOffset = currentOffset
        if let superMirror = mirror.superclassMirror() {
            currentOffset = _transform(rawData: dict, toPointer: pointer, toOffset: currentOffset, byMirror: superMirror, withMapper: mapper)
        }

        var mutablePointer = pointer.advancedBy(currentOffset)
        mirror.children.forEach({ (child) in

            var offset = 0, size = 0

            guard let propertyType = child.value.dynamicType as? Property.Type else {
                fatalError("Each property should be handyjson-property type")
            }

            size = propertyType.size()
            offset = propertyType.offsetToAlignment(currentOffset, align: propertyType.align())

            mutablePointer = mutablePointer.advancedBy(offset)
            currentOffset += offset

            guard let label = child.label else {
                mutablePointer = mutablePointer.advancedBy(size)
                currentOffset += size
                return
            }

            var key = label

            if let converter = mapper.getNameAndConverter(mutablePointer.hashValue) {
                // if specific key is set, replace the label
                if let specifyKey = converter.0 {
                    key = specifyKey
                }

                // if specific converter is set, use it the assign value to the property
                if let specifyConverter = converter.1 {
                    if let ocValue = (dict[key] as? NSObject)?.toStringForcedly() {
                        specifyConverter(ocValue)
                    }

                    mutablePointer = mutablePointer.advancedBy(size)
                    currentOffset += size
                    return
                }
            }

            guard let value = dict[key] as? NSObject else {
                mutablePointer = mutablePointer.advancedBy(size)
                currentOffset += size
                return
            }

            if let sv = propertyType.valueFrom(value) {
                propertyType.codeIntoMemory(mutablePointer, value: sv)
            }

            mutablePointer = mutablePointer.advancedBy(size)
            currentOffset += size
        })
        return currentOffset
    }

    public static func _transform(dict: NSDictionary, toType type: HandyJSON.Type) -> HandyJSON {
        var instance = type.init()
        let mirror = Mirror(reflecting: instance)

        guard let dStyle = mirror.displayStyle else {
            fatalError("Target type must has a display type")
        }

        var pointer: UnsafePointer<Byte>!
        let mapper = HelpingMapper()
        var currentOffset = 0

        // do user-specified mapping first
        instance.mapping(mapper)

        if dStyle == .Class {
            pointer = instance.headPointerOfClass()
            // for 64bit architecture, it's 16
            // for 32bit architecture, it's 12
            currentOffset = 8 + sizeof(Int)
        } else if dStyle == .Struct {
            pointer = instance.headPointerOfStruct()
        } else {
            fatalError("Target object must be class or struct")
        }

        _transform(rawData: dict, toPointer: pointer, toOffset: currentOffset, byMirror: mirror, withMapper: mapper)

        return instance
    }

    static func valueFrom(object: NSObject) -> Self? {
        if self is BasePropertyProtocol.Type {

            // base type can be transformed directly
            return baseValueFrom(object)
        } else if self is OptionalTypeProtocol.Type {

            // optional type, we parse the wrapped generic type to construct the value, then wrap it to optional
            return optionalValueFrom(object)
        } else if self is ImplicitlyUnwrappedTypeProtocol.Type {

            // similar to optional
            return implicitUnwrappedValueFrom(object)
        } else if self is ArrayTypeProtocol.Type {
            if let va = arrayValueFrom(object) {

                // we can't retrieve the generic type wrapped by array here, so we go into array extension to do the casting
                return (self as! ArrayTypeProtocol.Type).castArrayType(va) as? Self
            }
        } else if self is DictionaryTypeProtocol.Type {
            if let dict = dictValueFrom(object) {

                // similar to array
                return (self as! DictionaryTypeProtocol.Type).castDictionaryType(dict) as? Self
            }
        } else if self is NSArray.Type {

            if let arr = object as? NSArray {
                return arr as? Self
            }
        } else if self is NSDictionary.Type {

            if let dict = object as? NSDictionary {
                return dict as? Self
            }
        } else if self is HandyJSON.Type {

            if let dict = object as? NSDictionary {
                // nested object, transform recursively
                return _transform(dict, toType: self as! HandyJSON.Type) as? Self
            }
        }
        return nil
    }

    // base type supported parsing directly
    static func baseValueFrom(object: NSObject) -> Self? {
        switch self {
        case is Int8.Type:
            return object.toInt8() as? Self
        case is UInt8.Type:
            return object.toUInt8() as? Self
        case is Int16.Type:
            return object.toInt16() as? Self
        case is UInt16.Type:
            return object.toUInt16() as? Self
        case is Int32.Type:
            return object.toInt32() as? Self
        case is UInt32.Type:
            return object.toUInt32() as? Self
        case is Int64.Type:
            return object.toInt64() as? Self
        case is UInt64.Type:
            return object.toUInt64() as? Self
        case is Bool.Type:
            return object.toBool() as? Self
        case is Int.Type:
            return object.toInt() as? Self
        case is UInt.Type:
            return object.toUInt() as? Self
        case is Float.Type:
            return object.toFloat() as? Self
        case is Double.Type:
            return object.toDouble() as? Self
        case is String.Type:
            return object.toString() as? Self
        case is NSString.Type:
            return object.toNSString() as? Self
        case is NSNumber.Type:
            return object.toNSNumber() as? Self
        default:
            break
        }
        return nil
    }

    static func optionalValueFrom(object: NSObject) -> Self? {
        if let wrappedType = (self as! OptionalTypeProtocol.Type).getWrappedType() as? Property.Type {
            // only can infer v is property.type
            if let v = wrappedType.valueFrom(object) {

                // so the argument must be property.type of function "wrapByOptional"
                return wrappedType.wrapByOptional(v) as? Self
            }
        }
        return nil
    }

    static func implicitUnwrappedValueFrom(object: NSObject) -> Self? {
        if let wrappedType = (self as! ImplicitlyUnwrappedTypeProtocol.Type).getWrappedType() as? Property.Type {

            // similar to optional value processing
            if let v = wrappedType.valueFrom(object) {
                return wrappedType.wrapByImplicitUnwrapped(v) as? Self
            }
        }
        return nil
    }

    static func wrapByOptional(value: Property) -> Optional<Self> {
        return Optional(value as! Self)
    }

    static func wrapByImplicitUnwrapped(value: Property) -> ImplicitlyUnwrappedOptional<Self> {
        return ImplicitlyUnwrappedOptional(value as! Self)
    }

    static func arrayValueFrom(object: NSObject) -> [Any]? {
        if let wrappedType = (self as! ArrayTypeProtocol.Type).getWrappedType() as? Property.Type {
            if let arr = object as? NSArray {
                return wrappedType.composeToArray(arr)
            }
        }
        return nil
    }

    static func composeToArray(nsArray: NSArray) -> [Any] {
        var arr = [Any]()
        nsArray.forEach { (anyObject) in
            if let nsObject = anyObject as? NSObject {
                let v = valueFrom(nsObject)
                arr.append(v)
            }
        }
        return arr
    }

    static func dictValueFrom(object: NSObject) -> [String: Any]? {
        if let wrappedValueType = (self as! DictionaryTypeProtocol.Type).getWrappedValueType() as? Property.Type {
            if let dict = object as? NSDictionary {
                return wrappedValueType.composeToDictionary(dict)
            }
        }
        return nil
    }

    static func composeToDictionary(nsDict: NSDictionary) -> [String: Any] {
        var dict = [String: Any]()
        nsDict.forEach { (key, value) in
            if let sKey = key as? String, nsObject = value as? NSObject, value = valueFrom(nsObject) {
                dict[sKey] = value
            }
        }
        return dict
    }

    // keep in mind, self type is the same with type of value
    static func codeIntoMemory(pointer: UnsafePointer<Byte>, value: Property) {
        (UnsafeMutablePointer(pointer) as UnsafeMutablePointer<Self>).memory = value as! Self
    }
}
