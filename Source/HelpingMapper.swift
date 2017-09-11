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

struct MappingPath {
    var segments: [String]

    static func buildFrom(rawPath: String) -> MappingPath {
        let regex = try! NSRegularExpression(pattern: "(?<![\\\\])\\.")
        let nsString = rawPath as NSString
        let results = regex.matches(in: rawPath, range: NSRange(location: 0, length: nsString.length))
        var splitPoints = results.map { $0.range.location }

        var curPos = 0
        var pathArr = [String]()
        splitPoints.append(nsString.length)
        splitPoints.forEach({ (point) in
            let start = rawPath.index(rawPath.startIndex, offsetBy: curPos)
            let end = rawPath.index(rawPath.startIndex, offsetBy: point)
            let subPath = rawPath.substring(with: start ..< end).replacingOccurrences(of: "\\.", with: ".")
            if !subPath.isEmpty {
                pathArr.append(subPath)
            }
            curPos = point + 1
        })
        return MappingPath(segments: pathArr)
    }
}

extension Dictionary where Value: Any {

    func findValueBy(path: MappingPath) -> Any? {
        var currentDict: [Key: Any]? = self
        var lastValue: Any?
        path.segments.forEach { (segment) in
            lastValue = currentDict?[segment as! Key]
            currentDict = currentDict?[segment as! Key] as? [Key: Any]
        }
        return lastValue
    }
}

public class MappingPropertyHandler {
    var mappingPaths: [MappingPath]?
    var assignmentClosure: ((Any?) -> (Any?))?
    var takeValueClosure: ((Any?) -> (Any?))?
    
    public init(rawPaths: [String]?, assignmentClosure: ((Any?) -> (Any?))?, takeValueClosure: ((Any?) -> (Any?))?) {
        let mappingPaths = rawPaths?.map({ (rawPath) -> MappingPath in
            if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
                return MappingPath.buildFrom(rawPath: rawPath.lowercased())
            }
            return MappingPath.buildFrom(rawPath: rawPath)
        }).filter({ (mappingPath) -> Bool in
            return mappingPath.segments.count > 0
        })
        if let count = mappingPaths?.count, count > 0 {
            self.mappingPaths = mappingPaths
        }
        self.assignmentClosure = assignmentClosure
        self.takeValueClosure = takeValueClosure
    }
}

public class HelpingMapper {
    
    private var mappingHandlers = [Int: MappingPropertyHandler]()
    private var excludeProperties = [Int]()
    
    internal func getMappingHandler(key: Int) -> MappingPropertyHandler? {
        return self.mappingHandlers[key]
    }
    
    internal func propertyExcluded(key: Int) -> Bool {
        return self.excludeProperties.contains(key)
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
        let names = (name == nil ? nil : [name!])
        
        if let _converter = converter {
            let assignmentClosure = { (jsonValue: Any?) -> Any? in
                if let _value = jsonValue{
                    if let object = _value as? NSObject{
                        if let str = String.transform(from: object){
                            return _converter(str)
                        }
                    }
                }
                return nil
            }
            self.mappingHandlers[key] = MappingPropertyHandler(rawPaths: names, assignmentClosure: assignmentClosure, takeValueClosure: nil)
        } else {
            self.mappingHandlers[key] = MappingPropertyHandler(rawPaths: names, assignmentClosure: nil, takeValueClosure: nil)
        }
    }
    
    public func exclude<T>(property: inout T) {
        self._exclude(property: &property)
    }
    
    fileprivate func addCustomMapping(key: Int, mappingInfo: MappingPropertyHandler) {
        self.mappingHandlers[key] = mappingInfo
    }
    
    fileprivate func _exclude<T>(property: inout T) {
        let pointer = withUnsafePointer(to: &property, { return $0 })
        self.excludeProperties.append(pointer.hashValue)
    }
}

infix operator <-- : LogicalConjunctionPrecedence

public func <-- <T>(property: inout T, name: String) -> CustomMappingKeyValueTuple {
    return property <-- [name]
}

public func <-- <T>(property: inout T, names: [String]) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    return (key, MappingPropertyHandler(rawPaths: names, assignmentClosure: nil, takeValueClosure: nil))
}

// MARK: non-optional properties
public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <-- (nil, transformer)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let names = (transformer.0 == nil ? [] : [transformer.0!])
    return property <-- (names, transformer.1)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object, transformer: ([String], Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let assignmentClosure = { (jsonValue: Any?) -> Transform.Object? in
        return transformer.1?.transformFromJSON(jsonValue)
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(rawPaths: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure))
}

// MARK: optional properties
public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <-- (nil, transformer)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let names = (transformer.0 == nil ? [] : [transformer.0!])
    return property <-- (names, transformer.1)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object?, transformer: ([String], Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let assignmentClosure = { (jsonValue: Any?) -> Any? in
        return transformer.1?.transformFromJSON(jsonValue)
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(rawPaths: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure))
}

// MARK: implicitly unwrap optional properties
public func <-- <Transform: TransformType>(property: inout Transform.Object!, transformer: Transform) -> CustomMappingKeyValueTuple {
    return property <-- (nil, transformer)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object!, transformer: (String?, Transform?)) -> CustomMappingKeyValueTuple {
    let names = (transformer.0 == nil ? [] : [transformer.0!])
    return property <-- (names, transformer.1)
}

public func <-- <Transform: TransformType>(property: inout Transform.Object!, transformer: ([String], Transform?)) -> CustomMappingKeyValueTuple {
    let pointer = withUnsafePointer(to: &property, { return $0 })
    let key = pointer.hashValue
    let assignmentClosure = { (jsonValue: Any?) in
        return transformer.1?.transformFromJSON(jsonValue)
    }
    let takeValueClosure = { (objectValue: Any?) -> Any? in
        if let _value = objectValue as? Transform.Object {
            return transformer.1?.transformToJSON(_value) as Any
        }
        return nil
    }
    return (key, MappingPropertyHandler(rawPaths: transformer.0, assignmentClosure: assignmentClosure, takeValueClosure: takeValueClosure))
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
