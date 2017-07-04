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

fileprivate func getSubObject(inside jsonObject: NSObject?, by designatedPath: String?) -> NSObject? {
    var nodeValue: NSObject? = jsonObject
    var abort = false
    if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
        paths.forEach({ (seg) in
            if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
                return
            }
            if let next = (nodeValue as? NSDictionary)?.object(forKey: seg) as? NSObject {
                nodeValue = next
            } else {
                abort = true
            }
        })
    }
    return abort ? nil : nodeValue
}

extension _PropertiesMappable {

    static func _transform(rawPointer: UnsafeMutableRawPointer, property: Property.Description, dict: NSDictionary, mapper: HelpingMapper) {
        var key = property.key

        if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
            key = key.lowercased()
        }

        let mutablePointer = rawPointer.advanced(by: property.offset)

        InternalLogger.logVerbose(key, "address at: ", mutablePointer.hashValue)
        if mapper.propertyExcluded(key: mutablePointer.hashValue) {
            InternalLogger.logDebug("Exclude property: \(key)")
            return
        }

        var maybeValue: Any? = nil

        if let mappingHandler = mapper.getMappingHandler(key: mutablePointer.hashValue) {
            if let mappingNames = mappingHandler.mappingNames, mappingNames.count > 0 {
                for mappingName in mappingNames {
                    if let _value = dict[mappingName] {
                        maybeValue = _value
                        break
                    }
                }
            } else {
                maybeValue = dict[key]
            }

            if let transformer = mappingHandler.assignmentClosure {
                // execute the transform closure
                transformer(maybeValue)
                return
            }
        } else {
            maybeValue = dict[key]
        }

        guard let rawValue = maybeValue as? NSObject else {
            InternalLogger.logDebug("Can not find a value from dictionary for property: \(key)")
            return
        }

        if let transformableType = property.type as? _JSONTransformable.Type {
            if let sv = transformableType.transform(from: rawValue) {
                extensions(of: transformableType).write(sv, to: mutablePointer)
                return
            }
        } else {
            if let sv = extensions(of: property.type).takeValue(from: rawValue) {
                extensions(of: property.type).write(sv, to: mutablePointer)
                return
            }
        }
        InternalLogger.logDebug("Property: \(property.key) hasn't been written in")
    }

    static func _transform(dict: NSDictionary, toType: _PropertiesMappable.Type) -> _PropertiesMappable? {
        var instance = toType.init()

        guard let properties = getProperties(forType: toType) else {
            InternalLogger.logDebug("Failed when try to get properties from type: \(type(of: toType))")
            return nil
        }

        let mapper = HelpingMapper()
        // do user-specified mapping first
        instance.mapping(mapper: mapper)

        let rawPointer: UnsafeMutableRawPointer
        if toType is AnyClass {
            rawPointer = UnsafeMutableRawPointer(instance.headPointerOfClass())
        } else {
            rawPointer = UnsafeMutableRawPointer(instance.headPointerOfStruct())
        }

        InternalLogger.logVerbose("instance start at: ", rawPointer.hashValue)

        var _dict = dict
        if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
            let newDict = NSMutableDictionary()
            dict.allKeys.forEach({ (key) in
                if let sKey = key as? String {
                    newDict[sKey.lowercased()] = dict[key]
                } else {
                    newDict[key] = dict[key]
                }
            })
            _dict = newDict
        }

        properties.forEach { (property) in
            _transform(rawPointer: rawPointer, property: property, dict: _dict, mapper: mapper)
            InternalLogger.logVerbose("field: ", property.key, "  offset: ", property.offset)
        }

        return instance
    }
}

public extension HandyJSON {

    /// Finds the internal NSDictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    public static func deserialize(from dict: NSDictionary?, designatedPath: String? = nil) -> Self? {
        return JSONDeserializer<Self>.deserializeFrom(dict: dict, designatedPath: designatedPath)
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    public static func deserialize(from json: String?, designatedPath: String? = nil) -> Self? {
        return JSONDeserializer<Self>.deserializeFrom(json: json, designatedPath: designatedPath)
    }
}

public extension Array where Element: HandyJSON {

    /// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserialize(from json: String?, designatedPath: String? = nil) -> [Element?]? {
        return JSONDeserializer<Element>.deserializeModelArrayFrom(json: json, designatedPath: designatedPath)
    }

    /// deserialize model array from NSArray
    public static func deserialize(from array: NSArray?) -> [Element?]? {
        return JSONDeserializer<Element>.deserializeModelArrayFrom(array: array)
    }
}

public class JSONDeserializer<T: HandyJSON> {

    /// Finds the internal NSDictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func deserializeFrom(dict: NSDictionary?, designatedPath: String? = nil) -> T? {
        var targetDict = dict
        if let path = designatedPath {
            targetDict = getSubObject(inside: targetDict, by: path) as? NSDictionary
        }
        if let _dict = targetDict {
            return T._transform(dict: _dict, toType: T.self) as? T
        }
        return nil
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func deserializeFrom(json: String?, designatedPath: String? = nil) -> T? {
        guard let _json = json else {
            return nil
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonDict = jsonObject as? NSDictionary {
                return self.deserializeFrom(dict: jsonDict, designatedPath: designatedPath)
            }
        } catch let error {
            InternalLogger.logError(error)
        }
        return nil
    }

    /// if the JSON field found by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserializeModelArrayFrom(json: String?, designatedPath: String? = nil) -> [T?]? {
        guard let _json = json else {
            return nil
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonArray = getSubObject(inside: jsonObject as? NSObject, by: designatedPath) as? NSArray {
                return jsonArray.map({ (item) -> T? in
                    return self.deserializeFrom(dict: item as? NSDictionary)
                })
            }
        } catch let error {
            InternalLogger.logError(error)
        }
        return nil
    }

    /// if the object found by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserializeModelArrayFrom(array: NSArray?) -> [T?]? {
        guard let _arr = array else {
            return nil
        }
        return _arr.map({ (item) -> T? in
            return self.deserializeFrom(dict: item as? NSDictionary)
        })
    }
}
