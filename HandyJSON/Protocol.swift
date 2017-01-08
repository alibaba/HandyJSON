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

public protocol Metrizable {}

extension Metrizable {

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

public protocol TransformableProperty: Metrizable {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

extension TransformableProperty {
    public mutating func mapping(mapper: HelpingMapper) {}
}

public protocol InitWrapperProtocol {
    func convertToEnum(object: NSObject) -> Any?
}

public struct InitWrapper<T: Metrizable>: InitWrapperProtocol {

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

public protocol TakeValueProtocol {
    func rawValue(fromEnum: Any) -> Any?
}

public struct TakeValueWrapper<U>: TakeValueProtocol {

    var _take: ((U) -> Any?)?

    public init(takeValue: @escaping ((U) -> Any?)) {
        self._take = takeValue
    }

    public func rawValue(fromEnum: Any) -> Any? {
        if let take = self._take, let _enum = fromEnum as? U {
            return take(_enum)
        }
        return nil
    }
}

protocol BasePropertyProtocol: TransformableProperty {
}

protocol OptionalTypeProtocol: TransformableProperty {
    static func optionalFromNSObject(object: NSObject) -> Any?
    func getWrappedValue() -> Any?
}

extension Optional: OptionalTypeProtocol {
    public init() {
        self = nil
    }

    static func optionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? Metrizable.Type)?.valueFrom(object: object) as? Wrapped {
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

protocol ImplicitlyUnwrappedTypeProtocol: TransformableProperty {
    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any?
    func getWrappedValue() -> Any?
}

extension ImplicitlyUnwrappedOptional: ImplicitlyUnwrappedTypeProtocol {

    static func implicitlyUnwrappedOptionalFromNSObject(object: NSObject) -> Any? {
        if let value = (Wrapped.self as? Metrizable.Type)?.valueFrom(object: object) as? Wrapped {
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

protocol ArrayTypeProtocol: TransformableProperty {
    static func arrayFromNSObject(object: NSObject) -> Any?
    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]?
}

extension Array: ArrayTypeProtocol {

    static func arrayFromNSObject(object: NSObject) -> Any? {
        guard let nsArray = object as? NSArray else {
            return nil
        }
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? Metrizable.Type)?.valueFrom(object: nsObject) as? Element {
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

protocol SetTypeProtocol: TransformableProperty {
    static func setFromNSObject(object: NSObject) -> Any?
    func customMap(_ transform: ((Any) -> (Any?))) -> [Any?]?
}

extension Set: SetTypeProtocol {

    static func setFromNSObject(object: NSObject) -> Any? {
        guard let nsArray = object as? NSArray else {
            return nil
        }
        var result: Set<Element> = Set<Element>()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? Metrizable.Type)?.valueFrom(object: nsObject) as? Element {
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

protocol DictionaryTypeProtocol: TransformableProperty {
    static func dictionaryFromNSObject(object: NSObject) -> Any?
    func customMap(_ transformValue: ((Any) -> Any?)) -> [String: Any?]?
}

extension Dictionary: DictionaryTypeProtocol {

    static func dictionaryFromNSObject(object: NSObject) -> Any? {
        guard let nsDict = object as? NSDictionary else {
            return nil
        }
        var result: [Key: Value] = [Key: Value]()
        nsDict.forEach { (key, value) in
            if let sKey = key as? Key, let nsValue = value as? NSObject {
                if let nValue = (Value.self as? Metrizable.Type)?.valueFrom(object: nsValue) as? Value {
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

extension NSArray: Metrizable {}
extension NSDictionary: Metrizable {}

// expose HandyJSON protocol
public protocol HandyJSON: TransformableProperty {}

public protocol HandyJSONEnum: Metrizable {
    static func makeInitWrapper() -> InitWrapperProtocol
    static func takeValueWrapper() -> TakeValueProtocol
}

