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
        return T.transform(dict, toType: T.self) as? T
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


public class JSONSerializer {
    
    public static func serializeToJSON(object: Any?, prettify: Bool = false) -> String? {
        if let _object = object {
            var json = _serializeToJSON(_object)
            
            if prettify {
                let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)!
                let jsonObject:AnyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                let prettyJsonData = try! NSJSONSerialization.dataWithJSONObject(jsonObject, options: .PrettyPrinted)
                json = NSString(data: prettyJsonData, encoding: NSUTF8StringEncoding)! as String
            }
            return json
        } else {
            return nil
        }
    }
    
    static func _serializeToJSON(object: Any) -> String {
        
        if (object.dynamicType is String.Type || object.dynamicType is NSString.Type ) {
            let json = "\"" + String(object)  + "\""
            return json
        } else if (object.dynamicType is BasePropertyProtocol.Type) {
            let json = String(object) ?? "null"
            return json
        }
        
        var json = String()
        let mirror = Mirror(reflecting: object)
        
        if mirror.displayStyle == .Class || mirror.displayStyle == .Struct {
            var handledValue = String()
            var children = [(label: String?, value: Any)]()
            let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
            children += mirrorChildrenCollection
            
            var currentMirror = mirror
            while let superclassChildren = currentMirror.superclassMirror()?.children {
                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
                children += randomCollection
                currentMirror = currentMirror.superclassMirror()!
            }
            
            children.enumerate().forEach({ (index, element) in
                handledValue = _serializeToJSON(element.value)
                json += "\"\(element.label ?? "")\":\(handledValue)" + (index < children.count-1 ? "," : "")
            })
            
            return "{" + json + "}"
        } else if mirror.displayStyle == .Enum {
            return  "\"" + String(object) + "\""
        } else if  mirror.displayStyle == .Optional {
            if mirror.children.count != 0 {
                let (_, some) = mirror.children.first!
                return _serializeToJSON(some)
            } else {
                return "null"
            }
        } else if mirror.displayStyle == .Collection || mirror.displayStyle == .Set {
            json = "["
            
            let count = mirror.children.count
            mirror.children.enumerate().forEach({ (index, element) in
                let transformValue = _serializeToJSON(element.value)
                json += transformValue
                json += (index < count-1 ? "," : "")
            })
            
            json += "]"
            return json
        } else if mirror.displayStyle == .Dictionary {
            json += "{"
            mirror.children.enumerate().forEach({ (index, element) in
                let _mirror = Mirror(reflecting: element.value)
                _mirror.children.enumerate().forEach({ (_index, _element) in
                    if _index == 0 {
                        json += _serializeToJSON(_element.value) + ":"
                    } else {
                        json += _serializeToJSON(_element.value)
                        json += (index < mirror.children.count-1 ? "," : "")
                    }
                })
            })
            json += "}"
            return json
        } else {
            return String(object) != "nil" ? "\"\(object)\"" : "null"
        }
    }
}

extension Property {
    
    internal static func transform(dict: NSDictionary, withMapper: Mapper, withPointer: UnsafePointer<Byte>, withCurrentOffset: Int, byMirror: Mirror) -> Int {
        
        var currentOffset = withCurrentOffset
        if let superMirror = byMirror.superclassMirror() {
            currentOffset = transform(dict, withMapper: withMapper, withPointer: withPointer, withCurrentOffset: currentOffset, byMirror: superMirror)
        }

        var pointer = withPointer.advancedBy(currentOffset)
        byMirror.children.forEach({ (child) in

            var offset = 0, size = 0

            guard let p = child.value.dynamicType as? Property.Type else {
                fatalError("Each property should be handyjson-property type")
            }

            size = p.size()
            offset = p.offsetToAlignment(currentOffset, align: p.align())

            pointer = pointer.advancedBy(offset)
            currentOffset += offset

            guard let label = child.label else {
                pointer = pointer.advancedBy(size)
                currentOffset += size
                return
            }

            var key = label

            if let converter = withMapper.getConverter(pointer.hashValue) {
                // if specific key is set, replace the label
                if let specifyKey = converter.0 {
                    key = specifyKey
                }

                // if specific converter is set, use it the assign value to the property
                if let specifyConverter = converter.1 {
                    if let ocValue = (dict[key] as? NSObject)?.toStringForcedly() {
                        specifyConverter(ocValue)
                    }

                    pointer = pointer.advancedBy(size)
                    currentOffset += size
                    return
                }
            }

            guard let value = dict[key] as? NSObject else {
                pointer = pointer.advancedBy(size)
                currentOffset += size
                return
            }

            if let sv = p.valueFrom(value) {
                p.codeIntoMemory(pointer, value: sv)
            }

            pointer = pointer.advancedBy(size)
            currentOffset += size
        })
        return currentOffset
    }

    public static func transform(dict: NSDictionary, toType: HandyJSON.Type) -> HandyJSON {
        var any = toType.init()
        let mirror = Mirror(reflecting: any)

        guard let dStyle = mirror.displayStyle else {
            fatalError("Target type must has a display type")
        }

        var pointer: UnsafePointer<Byte>!
        let mapper = Mapper()
        var currentOffset = 0

        // do user-specified mapping first
        any.mapping(mapper)

        if dStyle == .Class {
            pointer = any.headPointerOfClass()
            // for 64bit architecture, it's 16
            // for 32bit architecture, it's 12
            currentOffset = 8 + sizeof(Int)
        } else if dStyle == .Struct {
            pointer = any.headPointerOfStruct()
        } else {
            fatalError("Target object must be class or struct")
        }

        transform(dict, withMapper: mapper, withPointer: pointer, withCurrentOffset: currentOffset, byMirror: mirror)

        return any
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
                return transform(dict, toType: self as! HandyJSON.Type) as? Self
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
