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

protocol _BuiltInBasicType: _Transformable {

    static func _transform(from object: Any, transformer: _Transformer?) -> Self?
    func _plainValue(transformer: _Transformer?) -> Any?
}

// Suppport integer type

protocol IntegerPropertyProtocol: FixedWidthInteger, _BuiltInBasicType {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension IntegerPropertyProtocol {

    static func _transform(from object: Any, transformer: _Transformer?) -> Self? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        switch object {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
    
    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        return self
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

extension Bool: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> Bool? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
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

    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        return self
    }
}

// Support float type

protocol FloatPropertyProtocol: _BuiltInBasicType, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension FloatPropertyProtocol {

    static func _transform(from object: Any, transformer: _Transformer?) -> Self? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        switch object {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        return self
    }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

fileprivate let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 16
    return formatter
}()

extension String: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> String? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
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
            return formatter.string(from: num)
        case _ as NSNull:
            return nil
        default:
            return "\(object)"
        }
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        return self
    }
}

// MARK: Optional Support

extension Optional: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> Optional? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        if let value = (Wrapped.self as? _Transformable.Type)?.transform(from: object, transformer: transformer) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }

    func _getWrappedValue() -> Any? {
        return self.map( { (wrapped) -> Any in
            return wrapped as Any
        })
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        if let value = _getWrappedValue() {
            if let transformable = value as? _Transformable {
                return transformable.plainValue(transformer: transformer)
            } else {
                return value
            }
        }
        return nil
    }
}

// MARK: Collection Support : Array & Set

extension Collection {

    static func _collectionTransform(from object: Any, transformer: _Transformer?) -> [Iterator.Element]? {
        guard let arr = object as? [Any] else {
            InternalLogger.logDebug("Expect object to be an array but it's not")
            return nil
        }
        typealias Element = Iterator.Element
        var result: [Element] = [Element]()
        arr.forEach { (each) in
            if let element = (Element.self as? _Transformable.Type)?.transform(from: each, transformer: transformer) as? Element {
                result.append(element)
            } else if let element = each as? Element {
                result.append(element)
            }
        }
        return result
    }

    func _collectionPlainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        typealias Element = Iterator.Element
        var result: [Any] = [Any]()
        self.forEach { (each) in
            if let transformable = each as? _Transformable, let transValue = transformable.plainValue(transformer: transformer) {
                result.append(transValue)
            } else {
                InternalLogger.logError("value: \(each) isn't transformable type!")
            }
        }
        return result
    }
}

extension Array: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> [Element]? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        return self._collectionTransform(from: object, transformer: transformer)
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        return self._collectionPlainValue(transformer: transformer)
    }
}

extension Set: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> Set<Element>? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        if let arr = self._collectionTransform(from: object, transformer: transformer) {
            return Set(arr)
        }
        return nil
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        return self._collectionPlainValue(transformer: transformer)
    }
}

// MARK: Dictionary Support

extension Dictionary: _BuiltInBasicType {

    static func _transform(from object: Any, transformer: _Transformer?) -> [Key: Value]? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        guard let dict = object as? [String: Any] else {
            InternalLogger.logDebug("Expect object to be an NSDictionary but it's not")
            return nil
        }
        var result = [Key: Value]()
        for (key, value) in dict {
            if let sKey = key as? Key {
                if let nValue = (Value.self as? _Transformable.Type)?.transform(from: value, transformer: transformer) as? Value {
                    result[sKey] = nValue
                } else if let nValue = value as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }

    func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        var result = [String: Any]()
        for (key, value) in self {
            if let key = key as? String {
                if let transformable = value as? _Transformable {
                    if let transValue = transformable.plainValue(transformer: transformer) {
                        result[key] = transValue
                    }
                }
            }
        }
        return result
    }
}

