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

//  Created by zhouzhuo on 9/20/16.
//

import Foundation

public typealias CustomMappingKeyValueTuple = (Int, MappingPropertyHandler)

public class BasicPropertyHandler {
    var propertySize: Int

    public init(propertySize: Int) {
        self.propertySize = propertySize
    }
}

public class ExcludePropertyHandler: BasicPropertyHandler {
}

public class MappingPropertyHandler: BasicPropertyHandler {
    var mappingName: String?
    var assignmentClosure: ((Any?) -> ())?
    var takeValueClosure: ((Any?) -> (Any?))?

    public init(mappingName: String?, assignmentClosure: ((Any?) -> ())?, takeValueClosure: ((Any?) -> (Any?))?, propertySize: Int) {

        super.init(propertySize: propertySize)
        self.mappingName = mappingName
        self.assignmentClosure = assignmentClosure
        self.takeValueClosure = takeValueClosure
    }
}

public class HelpingMapper {

    private var handlers = [Int: BasicPropertyHandler]()

    internal func nextGreaterThanOrEqualKey(toKey: Int) -> Int? {
        for each in handlers.keys.sorted(by: <) {
            if each == toKey || each > toKey {
                return each
            }
        }
        return nil
    }

    internal func getPropertyHandler(key: Int) -> BasicPropertyHandler? {
        return self.handlers[key]
    }

    public func specify<T>(property: inout T, name: String) {
        self.specify(property: &property, name: name, converter: nil)
    }

    public func specify<T>(property: inout T, converter: @escaping (String) -> T) {
        self.specify(property: &property, name: nil, converter: converter)
    }

    public func specify<T>(property: inout T, name: String?, converter: ((String) -> T)?) {
        let pointer = withUnsafePointer(to: &property, { return $0 })
        let key = pointer.hashValue
        let size = MemoryLayout<T>.size

        if let _converter = converter {
            let assignmentClosure = { (jsonValue: Any?) in
                if let _value = jsonValue, let _valueStr = (_value as? NSObject)?.toString() {
                    UnsafeMutablePointer<T>(mutating: pointer).pointee = _converter(_valueStr)
                }
            }
            self.handlers[key] = MappingPropertyHandler(mappingName: name, assignmentClosure: assignmentClosure, takeValueClosure: nil, propertySize: size)
        } else {
            self.handlers[key] = MappingPropertyHandler(mappingName: name, assignmentClosure: nil, takeValueClosure: nil, propertySize: size)
        }
    }

    public func exclude<T>(property: inout T) {
        self._exclude(property: &property)
    }

    fileprivate func addCustomMapping(key: Int, mappingInfo: MappingPropertyHandler) {
        self.handlers[key] = mappingInfo
    }

    fileprivate func _exclude<T>(property: inout T) {
        let pointer = withUnsafePointer(to: &property, { return $0 })
        self.handlers[pointer.hashValue] = ExcludePropertyHandler(propertySize: MemoryLayout<T>.size)
    }
}

infix operator <- : LogicalConjunctionPrecedence

public func <- <T>(property: inout T, name: String) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let size = MemoryLayout<T>.size
    return (key, MappingPropertyHandler(mappingName: name, assignmentClosure: nil, takeValueClosure: nil, propertySize: size))
}

public func <- <Transform: TransformType>(property: inout Transform.Object, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let size = MemoryLayout<Transform.Object>.size
    let assignmentClosure = { (jsonValue: Any?) in
        if let value = transformer.1?.transformFromJSON(jsonValue) {
            UnsafeMutablePointer<Transform.Object>(mutating: pointer).pointee = value
        }
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(mappingName: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure, propertySize: size))
}

public func <- <Transform: TransformType>(property: inout Transform.Object?, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object?, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let size = MemoryLayout<Transform.Object?>.size
    let assignmentClosure = { (jsonValue: Any?) in
        if let value = transformer.1?.transformFromJSON(jsonValue) {
            UnsafeMutablePointer<Transform.Object?>(mutating: pointer).pointee = value
        }
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(mappingName: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure, propertySize: size))
}

public func <- <Transform: TransformType>(property: inout Transform.Object!, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object!, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let size = MemoryLayout<Transform.Object!>.size
    let assignmentClosure = { (jsonValue: Any?) in
        if let value = transformer.1?.transformFromJSON(jsonValue) {
            UnsafeMutablePointer<Transform.Object!>(mutating: pointer).pointee = value
        }
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(mappingName: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure, propertySize: size))
}

infix operator <<< : AssignmentPrecedence

public func <<< (mapper: HelpingMapper, mapping: CustomMappingKeyValueTuple) {
    mapper.addCustomMapping(key: mapping.0, mappingInfo: mapping.1)
}

public func <<< (mapper: HelpingMapper, mappings: [CustomMappingKeyValueTuple]) {
    mappings.forEach { (mapping) in
        mapper.addCustomMapping(key: mapping.0, mappingInfo: mapping.1)
    }
}

infix operator >>> : AssignmentPrecedence

public func >>> <T> (mapper: HelpingMapper, property: inout T) {
    mapper._exclude(property: &property)
}
