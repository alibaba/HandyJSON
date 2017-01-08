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

extension PropertiesMappable {

    internal static func _transform(rawPointer: UnsafeMutableRawPointer, property: Property.Description, dict: NSDictionary, mapper: HelpingMapper) {
        var key = property.key
        let mutablePointer = rawPointer.advanced(by: property.offset)

        if mapper.propertyExcluded(key: mutablePointer.hashValue) {
            return
        }

        if let mappingHandler = mapper.getMappingHandler(key: mutablePointer.hashValue) {
            // if specific key is set, replace the label
            if let specifyKey = mappingHandler.mappingName {
                key = specifyKey
            }

            if let transformer = mappingHandler.assignmentClosure {
                // execute the transform closure
                transformer(dict[key])
                return
            }
        }

        guard let rawValue = dict[key] as? NSObject else {
            return
        }

        if let transformableType = property.type as? PropertiesTransformable.Type {
            if let sv = transformableType.valueFrom(object: rawValue) {
                extensions(of: transformableType).write(sv, to: mutablePointer)
                return
            }
        } else {
            if let sv = extensions(of: property.type).takeValue(from: rawValue) {
                extensions(of: property.type).write(sv, to: mutablePointer)
                return
            }
        }
        print("property: \(property.key) hasn't been written in")
    }

    internal static func _transform(dict: NSDictionary, toType: PropertiesMappable.Type) -> PropertiesMappable? {
        var instance = toType.init()

        guard let properties = getProperties(forType: toType) else {
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

        properties.forEach { (property) in
            _transform(rawPointer: rawPointer, property: property, dict: dict, mapper: mapper)
        }

        return instance
    }

}


public class JSONDeserializer<T: HandyJSON> {

    /// Converts a NSDictionary to Model if the properties match
    public static func deserializeFrom(dict: NSDictionary?) -> T? {
        guard let _dict = dict else {
            return nil
        }
        return T._transform(dict: _dict, toType: T.self) as? T
    }

    /// Finds the internal NSDictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    public static func deserializeFrom(dict: NSDictionary?, designatedPath: String?) -> T? {
        if let targetDict = self.getObject(inside: dict, by: designatedPath) as? NSDictionary {
            return self.deserializeFrom(dict: targetDict)
        }
        return nil
    }

    /// Converts a JSON string to Model if the properties match
    /// return `nil` if the string is not in valid JSON format
    public static func deserializeFrom(json: String?) -> T? {
        return self.deserializeFrom(json: json, designatedPath: nil)
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    public static func deserializeFrom(json: String?, designatedPath: String?) -> T? {
        guard let _json = json else {
            return nil
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonDict = jsonObject as? NSDictionary {
                return self.deserializeFrom(dict: jsonDict, designatedPath: designatedPath)
            }
        } catch let error {
            print(error)
        }
        return nil
    }

    /// if `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserializeModelArrayFrom(json: String?) -> [T?]? {
        return self.deserializeModelArrayFrom(json: json, designatedPath: nil)
    }

    /// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserializeModelArrayFrom(json: String?, designatedPath: String?) -> [T?]? {
        guard let _json = json else {
            return nil
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonArray = self.getObject(inside: jsonObject as? NSObject, by: designatedPath) as? NSArray {
                return jsonArray.map({ (jsonDict) -> T? in
                    return self.deserializeFrom(dict: jsonDict as? NSDictionary)
                })
            }
        } catch let error {
            print(error)
        }
        return nil
    }

    internal static func getObject(inside jsonObject: NSObject?, by designatedPath: String?) -> NSObject? {
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
}
