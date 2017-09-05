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

    static func _transform(from object: NSObject) -> Self?
    func _plainValue() -> Any?
}

// Suppport integer type

protocol IntegerPropertyProtocol: Integer, _BuiltInBasicType {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension IntegerPropertyProtocol {

    static func _transform(from object: NSObject) -> Self? {
        switch object {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
    
    func _plainValue() -> Any? {
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

    static func _transform(from object: NSObject) -> Bool? {
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

    func _plainValue() -> Any? {
        return self
    }
}

// Support float type

protocol FloatPropertyProtocol: _BuiltInBasicType, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension FloatPropertyProtocol {

    static func _transform(from object: NSObject) -> Self? {
        switch object {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }

    func _plainValue() -> Any? {
        return self
    }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

extension String: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> String? {
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

    func _plainValue() -> Any? {
        return self
    }
}

// MARK: Optional Support

extension Optional: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> Optional? {
        if let value = (Wrapped.self as? _Transformable.Type)?.transform(from: object) as? Wrapped {
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

    func _plainValue() -> Any? {
        if let value = _getWrappedValue() {
            if let transformable = value as? _Transformable {
                return transformable.plainValue()
            } else {
                return value
            }
        }
        return nil
    }
}

extension ImplicitlyUnwrappedOptional: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> ImplicitlyUnwrappedOptional? {
        if let value = (Wrapped.self as? _Transformable.Type)?.transform(from: object) as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        } else if let value = object as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        }
        return nil
    }

    func _getWrappedValue() -> Any? {
        return self == nil ? nil : self!
    }

    func _plainValue() -> Any? {
        if let value = _getWrappedValue() {
            if let transformable = value as? _Transformable {
                return transformable.plainValue()
            } else {
                return value
            }
        }
        return nil
    }
}

// MARK: Collection Support : Array & Set

extension Collection {

    static func _collectionTransform(from object: NSObject) -> [Iterator.Element]? {
        guard let nsArray = object as? NSArray else {
            InternalLogger.logDebug("Expect object to be an NSArray but it's not")
            return nil
        }
        typealias Element = Iterator.Element
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? _Transformable.Type)?.transform(from: nsObject) as? Element {
                    result.append(element)
                } else if let element = nsObject as? Element {
                    result.append(element)
                }
            }
        }
        return result
    }

    func _collectionPlainValue() -> Any? {
        return self.map { (each) -> (Any?) in
            if let tranformable = each as? _Transformable {
                return tranformable.plainValue()
            } else {
                return each
            }
        }
    }
}

extension Array: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> [Element]? {
        return self._collectionTransform(from: object)
    }

    func _plainValue() -> Any? {
        return self._collectionPlainValue()
    }
}

extension Set: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> Set<Element>? {
        if let arr = self._collectionTransform(from: object) {
            return Set(arr)
        }
        return nil
    }

    func _plainValue() -> Any? {
        return self._collectionPlainValue()
    }
}

// MARK: Dictionary Support

extension Dictionary: _BuiltInBasicType {

    static func _transform(from object: NSObject) -> Dictionary? {
        guard let nsDict = object as? NSDictionary else {
            InternalLogger.logDebug("Expect object to be an NSDictionary but it's not")
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        for (key, value) in nsDict {
            if let sKey = key as? Key, let nsValue = value as? NSObject {
                if let nValue = (Value.self as? _Transformable.Type)?.transform(from: nsValue) as? Value {
                    result[sKey] = nValue
                } else if let nValue = nsValue as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }

    func _plainValue() -> Any? {
        var result = [String: Any]()
        for (key, value) in self {
            if let key = key as? String {
                if let transformable = value as? _Transformable {
                    if let transValue = transformable.plainValue() {
                        result[key] = transValue
                    }
                }
            }
        }
        return result
    }
}

