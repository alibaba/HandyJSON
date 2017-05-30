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

/// 协议说明
/// 以 `JSONSerialization` 为导向的可序列化协议.
/// 序列化能力 : 1) 可转换 JSON 到 Foundation objects. 2) 将 Foundation objects 到 JSON
/// JSON 格式支持以下数据结构
/// `string`, `number`, `object`, `array`, `true`, `false`, `null`
///
/// 由于是基于 `JSONSerialization` 所以这里的序列化能力不再是 JSON 字符串到 Model 或 Model 到 JSON 字符串.
/// 1) 将 `JSONSerialization` 反序列化的 Array 或 Dictionary 解析到 Model 对应的具体类型的字段.
/// 2) 将 Model 中的字段解析成可被 `JSONSerialization` 支持的几种基本的数据类型.
/// 基本数据类型即, Number, String, Bool, nil 及只包含两本种数据结构的 Array 和 Dictionary
/// 本模块中, `_JSONTransformable` 表示实现者拥有序列化能力.
/// 按道理, 本应该在 `_JSONTranformable` 中声明其基于 `JSONSerialization`序列化能力的两个方法.
/// 但是 本库使用反射的方法来为用户的 Model 实现序列化能力. 所以不需要用户实现对应的方法. 因而不在 `_JSONTransformable`
/// 中声明所需要有的能力.
///
/// `_JSONTransformable`, 被设计为只供内部使用, 由于 Swift 语言的限制, 必须声明为公开类型, 所以添加一个下划线为前缀.
/// 有两个基本子协议. 主要是为了区分 Model-Field 的不同功能.
/// 1. `_PropertiesMappable` 协议, 表示可以自定义一些转换. 用于自定义 Model 类型.
/// 如自定义Model 字段名与 JSON 中 Key 的对应关系. 甚至可以自定义整个字段的序列化过程.
///
/// 2. `_BasicTypeTransformable` 协议, 用于 Foundation 中的标准的数据类型, 及自定义的数据类型. 用户自定义字段类型可实现此协议以此来实现序列化能力.
/// 本库为Foundation & Swift 的主要基本类型实现了 `_BasicTypeTransformable` 协议.

import Foundation

typealias Byte = Int8

// MARK: 基本协议 声明

/// 提供默认的反射能力
public protocol _PropertiesMetrizable {}

extension _PropertiesMetrizable {

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

public protocol _JSONTransformable: _PropertiesMetrizable {}

public protocol _PropertiesMappable: _JSONTransformable {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

/// 用于自定义 Model 类型.
extension _PropertiesMappable {

    /// 表示可以自定义一些转换如自定义Model 字段名与 JSON 中 Key 的对应关系. 甚至可以自定义整个字段的序列化过程.
    public mutating func mapping(mapper: HelpingMapper) {}
}

extension _PropertiesMappable {

    public static func transform(from object: NSObject) -> Self? {
        if let dict = object as? NSDictionary {
            // nested object, transform recursively
            return self._transform(dict: dict, toType: self) as? Self
        }
        return nil
    }
}

/// 用于 Foundation 中的标准的数据类型, 及自定义的数据类型. 用户自定义字段类型可实现此协议以此来实现序列化能力.
/// 本库为Foundation & Swift 的主要基本类型实现了 `_BasicTypeTransformable` 协议.
public protocol _BasicTypeTransformable: _JSONTransformable {

    /// 将 `JSONSerialization` 反序列化生成的 `NSObject` 转换到对应 Model 对象.
    static func transform(from object: NSObject) -> Self?

    /// 返回可供 `JSONSerialization` 序列化的对象
    func toJSONValue() -> Any?
}

/// _JSONTransformable 的默认实现. 通过类型转换的动态调用, 为协议提供其名字对应的类型转换能力
extension _JSONTransformable {

    /// 为可转换类提供一个默认实现.
    ///
    /// - Parameter object: JSONSerialization 反序列化出来的 NSObject 对象.
    /// - Returns: 转换到对应声明的模型.
    public static func transform(from object: NSObject) -> Self? {
        switch self {
        case is NSString.Type:
            return NSString._transform(from: object) as? Self
        case is NSNumber.Type:
            return NSNumber._transform(from: object) as? Self
        case is NSArray.Type, is NSDictionary.Type:
            return object as? Self
        case let type as _BasicTypeTransformable.Type:
            return type.transform(from: object) as? Self
        case let type as _PropertiesMappable.Type:
            return type.transform(from: object) as? Self
        default:
            return nil
        }
    }

    public func toJSONValue() -> Any? {
        if self is NSNumber || self is NSString {
            return self
        } else if type(of: self) is NSArray.Type {
            return (self as? Array<Any>)?.toJSONValue()
        } else if type(of: self) is NSDictionary.Type {
            return (self as? Dictionary<String, Any>)?.toJSONValue()
        } else if let _self = self as? _BasicTypeTransformable {
            return _self.toJSONValue()
        } else if let type = type(of: self) as? _PropertiesMappable.Type, let _self = self as? _PropertiesMappable {
            return type._serializeAny(object: _self)
        } else {
            fatalError("Should not call this on HandyJSON model")
        }
    }
}

// MARK: Foundation & Swift 基本数据类型实现 _BasicTypeTransformable

/// 简单的 JSON 值类型 不包含 Array 和 Dictionary, 可直接用作 `JSONSerialization` 序列化.
protocol PlainJSONValue: _BasicTypeTransformable {}

extension PlainJSONValue {

    public func toJSONValue() -> Any? {
        return self
    }
}

// MARK: 基本类型 - 整型
protocol IntegerPropertyProtocol: Integer, PlainJSONValue {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension IntegerPropertyProtocol {

    public static func transform(from object: NSObject) -> Self? {
        switch object {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Int: IntegerPropertyProtocol {}
extension UInt: IntegerPropertyProtocol {}
extension Int8: IntegerPropertyProtocol {}
extension Int16: IntegerPropertyProtocol {}
extension Int32: IntegerPropertyProtocol {}
extension Int64: IntegerPropertyProtocol {}
extension UInt8: IntegerPropertyProtocol {}
extension UInt16: IntegerPropertyProtocol {}
extension UInt32: IntegerPropertyProtocol {}
extension UInt64: IntegerPropertyProtocol {}

// MARK: 基本类型 - 浮点型

extension Bool: PlainJSONValue {

    public static func transform(from object: NSObject) -> Bool? {
        switch object {
        case let str as NSString:
            let lowerCase = str.lowercased
            if ["0", "false"].contains(lowerCase) {
                return false
            }
            if ["1", "true"].contains(lowerCase) {
                return true
            }
            return nil
        case let num as NSNumber:
            return num.boolValue
        default:
            return nil
        }
    }
}

protocol FloatPropertyProtocol: _JSONTransformable, PlainJSONValue, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension FloatPropertyProtocol {

    public static func transform(from object: NSObject) -> Self? {
        switch object {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

// MARK: 基本类型 - String & NSString
extension String: PlainJSONValue {

    public static func transform(from object: NSObject) -> String? {
        switch object {
        case let str as String:
            return str
        case let num as NSNumber:
            // Boolean Type Inside
            if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
                if num.boolValue {
                    return "true"
                } else {
                    return "false"
                }
            }
            return num.stringValue
        case _ as NSNull:
            return nil
        default:
            return "\(object)"
        }
    }
}

extension NSString: _JSONTransformable {

    static func _transform(from object: NSObject) -> NSString? {
        if let str = String.transform(from: object) {
            return NSString(string: str)
        }
        return nil
    }
}

extension NSNumber: _JSONTransformable {

    static func _transform(from object: NSObject) -> NSNumber? {
        switch object {
        case let num as NSNumber:
            return num
        case let str as NSString:
            let lowercase = str.lowercased
            if lowercase == "true" {
                return NSNumber(booleanLiteral: true)
            } else if lowercase == "false" {
                return NSNumber(booleanLiteral: false)
            } else {
                // normal number
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                return formatter.number(from: str as String)
            }
        default:
            return nil
        }
    }
}

extension NSArray: _JSONTransformable {}
extension NSDictionary: _JSONTransformable {}

/// MARK: RawEnum Support
public protocol _RawEnumProtocol: _BasicTypeTransformable {
    func takeRawValue() -> Any?
}

extension _RawEnumProtocol {

    public func toJSONValue() -> Any? {
        return takeRawValue()
    }
}

public extension RawRepresentable where Self: _RawEnumProtocol {

    func takeRawValue() -> Any? {
        return self.rawValue
    }

    static func transform(from object: NSObject) -> Self? {
        if let transformableType = RawValue.self as? _JSONTransformable.Type {
            if let typedValue = transformableType.transform(from: object) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }
}

// MARK: Optional Support

extension Optional: _BasicTypeTransformable {

    public static func transform(from object: NSObject) -> Optional? {
        if let value = (Wrapped.self as? _JSONTransformable.Type)?.transform(from: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        return self.map( { (wrapped) -> Any in
            return wrapped as Any
        })
    }

    public func toJSONValue() -> Any? {
        if let value = getWrappedValue() {
            if let transformable = value as? _JSONTransformable {
                return transformable.toJSONValue()
            } else {
                return value
            }
        }
        return nil
    }
}

extension ImplicitlyUnwrappedOptional: _BasicTypeTransformable {

    public static func transform(from object: NSObject) -> ImplicitlyUnwrappedOptional? {
        if let value = (Wrapped.self as? _JSONTransformable.Type)?.transform(from: object) as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        } else if let value = object as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        return self == nil ? nil : self!
    }

    public func toJSONValue() -> Any? {
        if let value = getWrappedValue() {
            if let transformable = value as? _JSONTransformable {
                return transformable.toJSONValue()
            } else {
                return value
            }
        }
        return nil
    }
}

// MARK: Collection Support : Array & Set

extension Collection {

    static func _transform(from object: NSObject) -> [Iterator.Element]? {
        guard let nsArray = object as? NSArray else {
            InternalLogger.logDebug("Expect object to be an NSArray but it's not")
            return nil
        }
        typealias Element = Iterator.Element
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? _JSONTransformable.Type)?.transform(from: nsObject) as? Element {
                    result.append(element)
                } else if let element = nsObject as? Element {
                    result.append(element)
                }
            }
        }
        return result
    }

    func _toJSONValue() -> Any? {
        return self.map { (each) -> (Any?) in
            if let tranformable = each as? _JSONTransformable {
                return tranformable.toJSONValue()
            } else {
                return each
            }
        }
    }
}

extension Array: _BasicTypeTransformable {

    public static func transform(from object: NSObject) -> [Element]? {
        return self._transform(from: object)
    }

    public func toJSONValue() -> Any? {
        return self._toJSONValue()
    }
}

extension Set: _BasicTypeTransformable {

    public static func transform(from object: NSObject) -> [Element]? {
        return self._transform(from: object)
    }

    public func toJSONValue() -> Any? {
        return self._toJSONValue()
    }
}

// MARK: Dictionary Support

extension Dictionary: _BasicTypeTransformable {

    public static func transform(from object: NSObject) -> Dictionary? {
        guard let nsDict = object as? NSDictionary else {
            InternalLogger.logDebug("Expect object to be an NSDictionary but it's not")
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        for (key, value) in nsDict {
            if let sKey = key as? Key, let nsValue = value as? NSObject {
                if let nValue = (Value.self as? _JSONTransformable.Type)?.transform(from: nsValue) as? Value {
                    result[sKey] = nValue
                } else if let nValue = nsValue as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }

    public func toJSONValue() -> Any? {
        var result = [String: Any]()
        for (key, value) in self {
            if let key = key as? String {
                if let transformable = value as? _JSONTransformable {
                    if let transValue = transformable.toJSONValue() {
                        result[key] = transValue
                    }
                }
            }
        }
        return result
    }
}

// expose HandyJSON protocol
public protocol HandyJSONCustomTransformable: _BasicTypeTransformable {}

public protocol HandyJSON: _PropertiesMappable {}

public protocol HandyJSONEnum: _RawEnumProtocol {}

