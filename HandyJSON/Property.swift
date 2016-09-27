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
    mutating func headPointerOfStruct() -> UnsafePointer<Byte> {
        return withUnsafePointer(&self) { UnsafePointer($0) }
    }

    // locating the head of a class type object in memory
    mutating func headPointerOfClass() -> UnsafePointer<Byte> {
        return UnsafePointer(bitPattern: unsafeAddressOf(self as! AnyObject).hashValue)
    }

    // memory size occupy by self object
    static func size() -> Int {
        return sizeof(self)
    }

    // align
    static func align() -> Int {
        return alignof(self)
    }

    // Returns the offset to the next integer that is greater than
    // or equal to Value and is a multiple of Align. Align must be
    // non-zero.
    static func offsetToAlignment(value: Int, align: Int) -> Int {
        let m = value % align
        return m == 0 ? 0 : (align - m)
    }
}

public protocol HandyJSON: Property {
    init()
    mutating func mapping(mapper: Mapper)
}

public extension HandyJSON {
    public mutating func mapping(mapper: Mapper) {}
}

protocol BasePropertyProtocol: HandyJSON {
}

protocol OptionalTypeProtocol: HandyJSON {
    static func getWrappedType() -> Any.Type
}

extension Optional: OptionalTypeProtocol {
    static func getWrappedType() -> Any.Type {
        return Wrapped.self
    }
}

protocol ImplicitlyUnwrappedTypeProtocol: HandyJSON {
    static func getWrappedType() -> Any.Type
}

extension ImplicitlyUnwrappedOptional: ImplicitlyUnwrappedTypeProtocol {
    static func getWrappedType() -> Any.Type {
        return Wrapped.self
    }
}

protocol ArrayTypeProtocol: HandyJSON {
    static func getWrappedType() -> Any.Type

    static func castArrayType(arr: [Any]) -> Self
}

extension Array: ArrayTypeProtocol {
    static func getWrappedType() -> Any.Type {
        return Element.self
    }

    static func castArrayType(arr: [Any]) -> Array<Element> {
        return arr.map({ (p) -> Element in
            return p as! Element
        })
    }
}

protocol DictionaryTypeProtocol: HandyJSON {
    static func getWrappedIndexType() -> Any.Type
    static func getWrappedValueType() -> Any.Type

    static func castDictionaryType(dict: [String: Any]) -> Self
}

extension Dictionary: DictionaryTypeProtocol {
    static func getWrappedIndexType() -> Any.Type {
        return Key.self
    }

    static func getWrappedValueType() -> Any.Type {
        return Value.self
    }

    static func castDictionaryType(dict: [String: Any]) -> Dictionary<Key, Value> {
        var result = Dictionary<Key, Value>()
        dict.forEach { (key, value) in
            if let sKey = key as? Key, let sValue = value as? Value {
                result[sKey] = sValue
            }
        }
        return result
    }
}

extension NSArray: Property {}
extension NSDictionary: Property {}
