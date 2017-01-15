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

public protocol PropertiesMetrizable {}

extension PropertiesMetrizable {

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

fileprivate func calculateMemoryDistanceShouldMove(currentOffset: Int, layoutInfo: (Int, Int)) -> Int {
    let m = currentOffset % layoutInfo.1
    let offset =  (m == 0 ? 0 : (layoutInfo.1 - m))
    let size = layoutInfo.0
    return size + offset
}

public protocol RawEnumProtocol: PropertiesTransformable {
    func takeRawValue() -> Any?
    static func from(rawObject: NSObject) -> Self?
}

public extension RawRepresentable where Self: RawEnumProtocol {

    func takeRawValue() -> Any? {
        return self.rawValue
    }

    static func from(rawObject: NSObject) -> Self? {
        if let transformableType = RawValue.self as? PropertiesTransformable.Type {
            if let typedValue = transformableType.valueFrom(object: rawObject) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }
}

protocol BasePropertyProtocol: PropertiesTransformable {
}

protocol OptionalTypeProtocol: PropertiesTransformable {
    static func optionalFromNSObject(object: NSObject) -> Any?
    func getWrappedValue() -> Any?
}

extension Optional: OptionalTypeProtocol {
    public init() {
        self = nil
    }

    static func optionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? PropertiesTransformable.Type)?.valueFrom(object: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        return self.map({ (wrapped) -> Any in
            return wrapped as Any
        })
    }
}

protocol ImplicitlyUnwrappedTypeProtocol: PropertiesTransformable {
    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any?
    func getWrappedValue() -> Any?
}

extension ImplicitlyUnwrappedOptional: ImplicitlyUnwrappedTypeProtocol {

    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? PropertiesTransformable.Type)?.valueFrom(object: object) as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        } else if let value = object as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        if case let .some(x) = self {
            return x
        }
        return nil
    }
}

protocol ArrayTypeProtocol: PropertiesTransformable {
    static func arrayFromNSObject(object: NSObject) -> Any?
    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]?
}

extension Array: ArrayTypeProtocol {

    static func arrayFromNSObject(object: NSObject) -> Any? {
        guard let nsArray = object as? NSArray else {
            ClosureExecutor.executeWhenDebug {
                print("Expect object to be an NSArray but it's not")
            }
            return nil
        }
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? PropertiesTransformable.Type)?.valueFrom(object: nsObject) as? Element {
                    result.append(element)
                } else if let element = nsObject as? Element {
                    result.append(element)
                }
            }
        }
        return result
    }

    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]? {
        return self.map({ (each) -> Any? in
            return transform(each)
        })
    }
}

protocol SetTypeProtocol: PropertiesTransformable {
    static func setFromNSObject(object: NSObject) -> Any?
    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]?
}

extension Set: SetTypeProtocol {

    static func setFromNSObject(object: NSObject) -> Any? {
        guard let nsArray = object as? NSArray else {
            ClosureExecutor.executeWhenDebug {
                print("Expect object to be an NSArray but it's not")
            }
            return nil
        }
        var result: Set<Element> = Set<Element>()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? PropertiesTransformable.Type)?.valueFrom(object: nsObject) as? Element {
                    result.insert(element)
                } else if let element = nsObject as? Element {
                    result.insert(element)
                }
            }
        }
        return result
    }

    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]? {
        return self.map({ (each) -> Any? in
            return transform(each)
        })
    }
}

protocol DictionaryTypeProtocol: PropertiesTransformable {
    static func dictionaryFromNSObject(object: NSObject) -> Any?
    func customMap(_ transformValue: ((Any) -> Any?)) -> [String: Any?]?
}

extension Dictionary: DictionaryTypeProtocol {

    static func dictionaryFromNSObject(object: NSObject) -> Any? {
        guard let nsDict = object as? NSDictionary else {
            ClosureExecutor.executeWhenDebug {
                print("Expect object to be an NSDictionary but it's not")
            }
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        nsDict.forEach { (key, value) in
            if let sKey = key as? Key, let nsValue = value as? NSObject {
                if let nValue = (Value.self as? PropertiesTransformable.Type)?.valueFrom(object: nsValue) as? Value {
                    result[sKey] = nValue
                } else if let nValue = nsValue as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }

    func customMap(_ transformValue: ((Any) -> Any?)) -> [String: Any?]? {
        var result = [String: Any?]()
        self.forEach({ (key, value) in
            if let sKey = key as? String, let _value = transformValue(value) {
                result[sKey] = _value
            }
        })
        return result
    }
}

public protocol PropertiesTransformable: PropertiesMetrizable {}

public protocol PropertiesMappable: PropertiesTransformable {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

extension PropertiesMappable {
    public mutating func mapping(mapper: HelpingMapper) {}
}

extension PropertiesTransformable {

    internal static func valueFrom(object: NSObject) -> Self? {
        if self is RawEnumProtocol.Type {

            if let rawEnumType = self as? RawEnumProtocol.Type {
                if let resultValue = rawEnumType.from(rawObject: object) {
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
        } else if self is SetTypeProtocol.Type {

            // we can't retrieve the generic type wrapped by array here, so we go into array extension to do the casting
            return (self as! SetTypeProtocol.Type).setFromNSObject(object: object) as? Self
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
        } else if let mappableType = self as? PropertiesMappable.Type {

            if let dict = object as? NSDictionary {
                // nested object, transform recursively
                return mappableType._transform(dict: dict, toType: mappableType) as? Self
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
}

// expose HandyJSON protocol
public protocol HandyJSON: PropertiesMappable {}

public protocol HandyJSONEnum: RawEnumProtocol {}

