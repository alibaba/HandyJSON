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

typealias Byte = Int8

public protocol Property {
}

extension Property {

    // locate the head of a struct type object in memory
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Byte> {

        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        }
    }

    // locating the head of a class type object in memory
    mutating func headPointerOfClass() -> UnsafeMutablePointer<Byte> {

        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        return UnsafeMutablePointer<Byte>(mutableTypedPointer)
    }

    // memory size occupy by self object
    static func size() -> Int {
        return MemoryLayout<Self>.size
    }

    // align
    static func align() -> Int {
        return MemoryLayout<Self>.alignment
    }

    // Returns the offset to the next integer that is greater than
    // or equal to Value and is a multiple of Align. Align must be
    // non-zero.
    static func offsetToAlignment(value: Int, align: Int) -> Int {
        let m = value % align
        return m == 0 ? 0 : (align - m)
    }
}

public protocol TransformableProperty: Property {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

extension TransformableProperty {
    public mutating func mapping(mapper: HelpingMapper) {}
}

public protocol InitWrapperProtocol {
    func convertToEnum(object: NSObject) -> Any?
}

public struct InitWrapper<T: Property>: InitWrapperProtocol {

    var _init: ((T) -> Any?)?

    public init(rawInit: @escaping ((T) -> Any?)) {
        self._init = rawInit
    }

    public func convertToEnum(object: NSObject) -> Any? {
        if let typedValue = T.valueFrom(object: object) {
            return _init?(typedValue)
        }
        return nil
    }
}

public protocol HandyJSONEnum: Property {
    static func makeInitWrapper() -> InitWrapperProtocol?
}

protocol BasePropertyProtocol: TransformableProperty {
}

protocol OptionalTypeProtocol: TransformableProperty {
    static func optionalFromNSObject(object: NSObject) -> Any?
}

extension Optional: OptionalTypeProtocol {
    public init() {
        self = nil
    }

    static func optionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? Property.Type)?.valueFrom(object: object) as? Wrapped {
            return Optional(value)
        }
        return nil
    }
}

protocol ImplicitlyUnwrappedTypeProtocol: TransformableProperty {
    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any?
}

extension ImplicitlyUnwrappedOptional: ImplicitlyUnwrappedTypeProtocol {

    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? Property.Type)?.valueFrom(object: object) as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        }
        return nil
    }
}

protocol ArrayTypeProtocol: TransformableProperty {
    static func arrayFromNSObject(object: NSObject) -> Any?
}

extension Array: ArrayTypeProtocol {

    static func arrayFromNSObject(object: NSObject) -> Any? {
        guard let nsArray = object as? NSArray else {
            return nil
        }
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject, let element = (Element.self as? Property.Type)?.valueFrom(object: nsObject) as? Element {
                result.append(element)
            }
        }
        return result
    }
}

protocol DictionaryTypeProtocol: TransformableProperty {
    static func dictionaryFromNSObject(object: NSObject) -> Any?
}

extension Dictionary: DictionaryTypeProtocol {

    static func dictionaryFromNSObject(object: NSObject) -> Any? {
        guard let nsDict = object as? NSDictionary else {
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        nsDict.forEach { (key, value) in
            if let sKey = key as? Key, let nsValue = value as? NSObject, let nValue = (Value.self as? Property.Type)?.valueFrom(object: nsValue) as? Value {
                result[sKey] = nValue
            }
        }
        return result
    }
}

extension NSArray: Property {}
extension NSDictionary: Property {}

extension Property {

    internal static func _transform(rawData dict: NSDictionary, toPointer pointer: UnsafeMutablePointer<Byte>, toOffset currentOffset: Int, byMirror mirror: Mirror, withMapper mapper: HelpingMapper) -> Int {

        var currentOffset = currentOffset
        if let superMirror = mirror.superclassMirror {
            currentOffset = _transform(rawData: dict, toPointer: pointer, toOffset: currentOffset, byMirror: superMirror, withMapper: mapper)
        }

        var mutablePointer = pointer.advanced(by: currentOffset)
        mirror.children.forEach({ (child) in

            var offset = 0, size = 0

            if let excludedPropertyLayout = mapper.exclude(key: mutablePointer.hashValue) {
                let m = currentOffset % excludedPropertyLayout.1
                offset =  (m == 0 ? 0 : (excludedPropertyLayout.1 - m))
                mutablePointer = mutablePointer.advanced(by: offset)

                size = excludedPropertyLayout.0
                mutablePointer = mutablePointer.advanced(by: size)
                currentOffset += size
                return
            }

            guard let propertyType = type(of: child.value) as? Property.Type else {
                print("label: ", child.label ?? "", "type: ", "\(type(of: child.value))")
                fatalError("Each property should be handyjson-property type")
            }

            size = propertyType.size()
            offset = propertyType.offsetToAlignment(value: currentOffset, align: propertyType.align())

            mutablePointer = mutablePointer.advanced(by: offset)
            currentOffset += offset

            guard let label = child.label else {
                mutablePointer = mutablePointer.advanced(by: size)
                currentOffset += size
                return
            }

            var key = label

            if let customTransform = mapper.getNameAndTransformer(key: mutablePointer.hashValue) {
                // if specific key is set, replace the label
                if let specifyKey = customTransform.0 {
                    key = specifyKey
                }

                if let transformer = customTransform.1 {
                    // execute the transform closure
                    transformer(dict[key])

                    mutablePointer = mutablePointer.advanced(by: size)
                    currentOffset += size
                    return
                }
            }

            guard let value = dict[key] as? NSObject else {
                mutablePointer = mutablePointer.advanced(by: size)
                currentOffset += size
                return
            }

            if let sv = propertyType.valueFrom(object: value) {
                propertyType.codeIntoMemory(pointer: mutablePointer, value: sv)
            }

            mutablePointer = mutablePointer.advanced(by: size)
            currentOffset += size
        })
        return currentOffset
    }

    internal static func _transform(dict: NSDictionary, toType type: TransformableProperty.Type) -> TransformableProperty {
        var instance = type.init()
        let mirror = Mirror(reflecting: instance)

        guard let dStyle = mirror.displayStyle else {
            fatalError("Target type must has a display type")
        }

        var pointer: UnsafeMutablePointer<Byte>!
        let mapper = HelpingMapper()
        var currentOffset = 0

        // do user-specified mapping first
        instance.mapping(mapper: mapper)

        if dStyle == .class {
            pointer = instance.headPointerOfClass()
            // for 64bit architecture, it's 16
            // for 32bit architecture, it's 12
            currentOffset = 8 + MemoryLayout<Int>.size
        } else if dStyle == .struct {
            pointer = instance.headPointerOfStruct()
        } else {
            fatalError("Target object must be class or struct")
        }

        _ = _transform(rawData: dict, toPointer: pointer, toOffset: currentOffset, byMirror: mirror, withMapper: mapper)

        return instance
    }

    internal static func valueFrom(object: NSObject) -> Self? {
        if self is HandyJSONEnum.Type {

            if let initWrapper = (self as? HandyJSONEnum.Type)?.makeInitWrapper() {
                if let resultValue = initWrapper.convertToEnum(object: object) {
                    return resultValue as? Self
                }
            }
            return nil
        } else if self is BasePropertyProtocol.Type {

            // base type can be transformed directly
            return baseValueFrom(object: object)
        } else if self is OptionalTypeProtocol.Type {

            // optional type, we parse the wrapped generic type to construct the value, then wrap it to optional
            return (self as! OptionalTypeProtocol.Type).optionalFromNSObject(object: object) as? Self
        } else if self is ImplicitlyUnwrappedTypeProtocol.Type {

            // similar to optional
            return (self as! ImplicitlyUnwrappedTypeProtocol.Type).implicitlyUnwrappedOptionalFromNSObject(object: object) as? Self
        } else if self is ArrayTypeProtocol.Type {

            // we can't retrieve the generic type wrapped by array here, so we go into array extension to do the casting
            return (self as! ArrayTypeProtocol.Type).arrayFromNSObject(object: object) as? Self
        } else if self is DictionaryTypeProtocol.Type {

            // similar to array
            return (self as! DictionaryTypeProtocol.Type).dictionaryFromNSObject(object: object) as? Self
        } else if self is NSArray.Type {

            if let arr = object as? NSArray {
                return arr as? Self
            }
        } else if self is NSDictionary.Type {

            if let dict = object as? NSDictionary {
                return dict as? Self
            }
        } else if self is TransformableProperty.Type {

            if let dict = object as? NSDictionary {
                // nested object, transform recursively
                return _transform(dict: dict, toType: self as! TransformableProperty.Type) as? Self
            }
        }
        return nil
    }

    // base type supported parsing directly
    internal static func baseValueFrom(object: NSObject) -> Self? {
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

    // keep in mind, self type is the same with type of value
    internal static func codeIntoMemory(pointer: UnsafeMutablePointer<Byte>, value: Property) {
        pointer.withMemoryRebound(to: Self.self, capacity: 1, { return $0 }).pointee = value as! Self
    }
}

extension Property {

    internal static func _serializeToDictionary(propertys: [(String?, Any)], headPointer: UnsafeMutablePointer<Byte>, currentOffset: Int, mapper: HelpingMapper) -> [String: Any] {

        var dict = [String: Any]()
        var currentOffset = currentOffset
        var mutablePointer = headPointer.advanced(by: currentOffset)

        propertys.forEach { (label, value) in
            guard let _label = label else {
                return
            }
            var key = _label

            var offset = 0, size = 0

            if let excludedPropertyLayout = mapper.exclude(key: mutablePointer.hashValue) {
                let m = currentOffset % excludedPropertyLayout.1
                offset =  (m == 0 ? 0 : (excludedPropertyLayout.1 - m))
                mutablePointer = mutablePointer.advanced(by: offset)

                size = excludedPropertyLayout.0
                mutablePointer = mutablePointer.advanced(by: size)
                currentOffset += size
                return
            }

            guard let typedProperty = type(of: value) as? Property.Type else {
                print("label: ", key, "type: ", "\(type(of: value))")
                fatalError("Each property should be handyjson-property type")
            }

            size = typedProperty.size()
            offset = typedProperty.offsetToAlignment(value: currentOffset, align: typedProperty.align())

            mutablePointer = mutablePointer.advanced(by: offset)
            currentOffset += offset

            if let customTransform = mapper.getNameAndTransformer(key: mutablePointer.hashValue) {
                // if specific key is set, replace the label
                if let specifyKey = customTransform.0 {
                    key = specifyKey
                }

                if let transformer = customTransform.2 {
                    // execute the transform closure
                    if let value = transformer(value) {
                        dict[key] = value
                    }

                    mutablePointer = mutablePointer.advanced(by: size)
                    currentOffset += size
                    return
                }
            }

            if let typedValue = value as? TransformableProperty {
                if let result = self._serialize(from: typedValue) {
                    dict[key] = result
                }
            }
            mutablePointer = mutablePointer.advanced(by: size)
            currentOffset += size
        }
        return dict
    }

    internal static func _serialize(from object: TransformableProperty) -> Any? {
        if type(of: object) is BasePropertyProtocol.Type {
            return object
        }

        var mutableObject = object
        let mirror = Mirror(reflecting: mutableObject)

        guard let displayStyle = mirror.displayStyle else {
            return self
        }

        switch displayStyle {
        case .class, .struct:

            var headPointer: UnsafeMutablePointer<Byte>!
            let mapper = HelpingMapper()
            var currentOffset = 0

            // do user-specified mapping first
            mutableObject.mapping(mapper: mapper)

            if displayStyle == .class {
                headPointer = mutableObject.headPointerOfClass()
                // for 64bit architecture, it's 16
                // for 32bit architecture, it's 12
                currentOffset = 8 + MemoryLayout<Int>.size
            } else if displayStyle == .struct {
                headPointer = mutableObject.headPointerOfStruct()
            }

            var children = [(label: String?, value: Any)]()
            let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
            children += mirrorChildrenCollection

            var currentMirror = mirror
            while let superclassChildren = currentMirror.superclassMirror?.children {
                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
                children += randomCollection
                currentMirror = currentMirror.superclassMirror!
            }

            return Self._serializeToDictionary(propertys: children, headPointer: headPointer, currentOffset: currentOffset, mapper: mapper) as Any
        case .enum:
            return self as Any
        case .optional:
            if mirror.children.count != 0 {
                let (_, some) = mirror.children.first!
                if let _value = some as? TransformableProperty {
                    return Self._serialize(from: _value)
                }
            }
            return nil
        case .collection, .set:
            var array = [Any]()
            mirror.children.enumerated().forEach({ (index, element) in
                if let _value = element.value as? TransformableProperty, let transformedValue = Self._serialize(from: _value) {
                    array.append(transformedValue)
                }
            })
            return array as Any
        case .dictionary:
            var dict = [String: Any]()
            mirror.children.enumerated().forEach({ (index, element) in
                let _mirror = Mirror(reflecting: element.value)
                var key: String?
                var value: Any?
                _mirror.children.enumerated().forEach({ (_index, _element) in
                    if _index == 0 {
                        key = "\(_element.value)"
                    } else {
                        if let _value = _element.value as? TransformableProperty {
                            value = Self._serialize(from: _value)
                        }
                    }
                })
                if (key ?? "") != "" && value != nil {
                    dict[key!] = value!
                }
            })
            return dict as Any
        default:
            return self as Any
        }
    }
}

// expose HandyJSON protocol
public protocol HandyJSON: TransformableProperty {}
