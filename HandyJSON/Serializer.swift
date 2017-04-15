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

//
//  JSONSerializer.swift
//  HandyJSON
//
//  Created by zhouzhuo on 9/30/16.
//

import Foundation

extension _PropertiesMappable {

    static func _serializeModelObject(propertys: [(String?, Any)], headPointer: UnsafeMutableRawPointer, offsetInfo: [String: Int] , mapper: HelpingMapper) -> [String: Any] {

        var dict = [String: Any]()
        for (label, value) in propertys {

            var key = label ?? ""

            guard let offset = offsetInfo[key] else {
                InternalLogger.logDebug("Can not find offset info for property: \(key)")
                continue
            }

            let mutablePointer = headPointer.advanced(by: offset)

            if mapper.propertyExcluded(key: mutablePointer.hashValue) {
                continue
            }

            if let mappingHandler = mapper.getMappingHandler(key: mutablePointer.hashValue) {
                // if specific key is set, replace the label
                if let mappingNames = mappingHandler.mappingNames, mappingNames.count > 0 {
                    // take the first if more than one
                    key = mappingNames[0]
                }

                if let transformer = mappingHandler.takeValueClosure {
                    if let _transformedValue = transformer(value) {
                        dict[key] = _transformedValue
                    }
                    continue
                }
            }

            if let typedValue = value as? _JSONTransformable {
                if let result = self._serializeAny(object: typedValue) {
                    dict[key] = result
                    continue
                }
            }

            InternalLogger.logDebug("The value for key: \(key) is not transformable type")
        }
        return dict
    }

    static func _serializeAny(object: _JSONTransformable) -> Any? {

        let mirror = Mirror(reflecting: object)

        guard let displayStyle = mirror.displayStyle else {
            return object.toJSONValue()
        }

        // after filtered by protocols above, now we expect the type is pure struct/class
        switch displayStyle {
        case .class, .struct:
            let mapper = HelpingMapper()
            // do user-specified mapping first
            if !(object is _PropertiesMappable) {
                InternalLogger.logDebug("This model of type: \(type(of: object)) is not mappable but is class/struct type")
                return object
            }
            var mutableObject = object as! _PropertiesMappable
            mutableObject.mapping(mapper: mapper)

            let rawPointer: UnsafeMutableRawPointer
            if type(of: object) is AnyClass {
                rawPointer = UnsafeMutableRawPointer(mutableObject.headPointerOfClass())
            } else {
                rawPointer = UnsafeMutableRawPointer(mutableObject.headPointerOfStruct())
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

            var offsetInfo = [String: Int]()
            guard let properties = getProperties(forType: type(of: object)) else {
                InternalLogger.logError("Can not get properties info for type: \(type(of: object))")
                return nil
            }

            properties.forEach({ (desc) in
                offsetInfo[desc.key] = desc.offset
            })

            return _serializeModelObject(propertys: children, headPointer: rawPointer, offsetInfo: offsetInfo, mapper: mapper) as Any
        default:
            return object.toJSONValue()
        }
    }
}

public extension HandyJSON {

    public func toJSON() -> [String: Any]? {
        if let dict = Self._serializeAny(object: self) as? [String: Any] {
            return dict
        }
        return nil
    }

    public func toJSONString(prettyPrint: Bool = false) -> String? {

        if let anyObject = self.toJSON() {
            if JSONSerialization.isValidJSONObject(anyObject) {
                do {
                    let jsonData: Data
                    if prettyPrint {
                        jsonData = try JSONSerialization.data(withJSONObject: anyObject, options: [.prettyPrinted])
                    } else {
                        jsonData = try JSONSerialization.data(withJSONObject: anyObject, options: [])
                    }
                    return String(data: jsonData, encoding: .utf8)
                } catch let error {
                    InternalLogger.logError(error)
                }
            } else {
                InternalLogger.logDebug("\(anyObject)) is not a valid JSON Object")
            }
        }
        return nil
    }
}

public extension Collection where Iterator.Element: HandyJSON {

    public func toJSON() -> [[String: Any]?] {
        return self.map{ $0.toJSON() }
    }

    public func toJSONString(prettyPrint: Bool = false) -> String? {

        let anyArray = self.toJSON()
        if JSONSerialization.isValidJSONObject(anyArray) {
            do {
                let jsonData: Data
                if prettyPrint {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [.prettyPrinted])
                } else {
                    jsonData = try JSONSerialization.data(withJSONObject: anyArray, options: [])
                }
                return String(data: jsonData, encoding: .utf8)
            } catch let error {
                InternalLogger.logError(error)
            }
        } else {
            InternalLogger.logDebug("\(self.toJSON()) is not a valid JSON Object")
        }
        return nil
    }
}
