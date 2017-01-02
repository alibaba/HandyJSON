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

public typealias CustomMappingValueTuple = (String?, ((Any?) -> ())?, ((Any?) -> (Any?))?)
public typealias CustomMappingKeyValueTuple = (Int, String?, ((Any?) -> ())?, ((Any?) -> (Any?))?)

public class HelpingMapper {

    private var mappers = [Int: CustomMappingValueTuple]()
    private var exclude = [Int: (Int, Int)]()

    public func exclude<T>(property: inout T) {
        let pointer = withUnsafePointer(to: &property, { return $0 })
        self.exclude[pointer.hashValue] = (MemoryLayout<T>.size, MemoryLayout<T>.alignment)
    }

    internal func getNameAndTransformer(key: Int) -> CustomMappingValueTuple? {
        return self.mappers[key]
    }

    internal func exclude(key: Int) -> (Int, Int)? {
        return self.exclude[key]
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

        if let _converter = converter {
            let assignmentClosure = { (jsonValue: Any?) in
                if let _value = jsonValue, let _valueStr = (_value as? NSObject)?.toString() {
                    UnsafeMutablePointer<T>(mutating: pointer).pointee = _converter(_valueStr)
                }
            }
            self.mappers[key] = (name, assignmentClosure, nil)
        } else {
            self.mappers[key] = (name, nil, nil)
        }
    }

    fileprivate func addCustomMapping(key: Int, name: String?, assignmentClosure: ((Any?) -> ())?, takeValueClosure: ((Any?) -> (Any?))?) {
        self.mappers[key] = (name, assignmentClosure, takeValueClosure)
    }
}

infix operator <- : LogicalConjunctionPrecedence

public func <- <T>(property: inout T, name: String) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    return (key, name, nil, nil)
}

public func <- <Transform: TransformType>(property: inout Transform.Object, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
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
    return (key, transformer.0, assignmentClosure, takeValueClosure)
}

public func <- <Transform: TransformType>(property: inout Transform.Object?, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object?, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
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
    return (key, transformer.0, assignmentClosure, takeValueClosure)
}

public func <- <Transform: TransformType>(property: inout Transform.Object!, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <- (nil, transformer)
}

public func <- <Transform: TransformType>(property: inout Transform.Object!, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
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
    return (key, transformer.0, assignmentClosure, takeValueClosure)
}

infix operator <<< : AssignmentPrecedence

public func <<< (mapper: HelpingMapper, mapping: CustomMappingKeyValueTuple) {
    mapper.addCustomMapping(key: mapping.0, name: mapping.1, assignmentClosure: mapping.2, takeValueClosure: mapping.3)
}
