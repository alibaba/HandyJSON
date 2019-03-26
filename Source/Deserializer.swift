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

public extension HandyJSON {

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func deserialize(from dict: NSDictionary?, designatedPath: String? = nil) -> Self? {
        return deserialize(from: dict as? [String: Any], designatedPath: designatedPath)
    }

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func deserialize(from dict: [String: Any]?, designatedPath: String? = nil) -> Self? {
        return JSONDeserializer<Self>.deserializeFrom(dict: dict, designatedPath: designatedPath)
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer
    static func deserialize(from json: String?, designatedPath: String? = nil) -> Self? {
        return JSONDeserializer<Self>.deserializeFrom(json: json, designatedPath: designatedPath)
    }
}

public extension Array where Element: HandyJSON {

    /// if the JSON field finded by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    static func deserialize(from json: String?, designatedPath: String? = nil) -> [Element?]? {
        return JSONDeserializer<Element>.deserializeModelArrayFrom(json: json, designatedPath: designatedPath)
    }

    /// deserialize model array from NSArray
    static func deserialize(from array: NSArray?) -> [Element?]? {
        return JSONDeserializer<Element>.deserializeModelArrayFrom(array: array)
    }

    /// deserialize model array from array
    static func deserialize(from array: [Any]?) -> [Element?]? {
        return JSONDeserializer<Element>.deserializeModelArrayFrom(array: array)
    }
}

public class JSONDeserializer<T: HandyJSON> {

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and map it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func deserializeFrom(dict: NSDictionary?, designatedPath: String? = nil) -> T? {
        return deserializeFrom(dict: dict as? [String: Any], designatedPath: designatedPath)
    }

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and map it to a Model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func deserializeFrom(dict: [String: Any]?, designatedPath: String? = nil) -> T? {
        var targetDict = dict
        if let path = designatedPath {
            targetDict = getInnerObject(inside: targetDict, by: path) as? [String: Any]
        }
        if let _dict = targetDict {
            return T._transform(dict: _dict) as? T
        }
        return nil
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and converts it to Model
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

    /// Finds the internal dictionary in `dict` as the `designatedPath` specified, and use it to reassign an exist model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func update(object: inout T, from dict: [String: Any]?, designatedPath: String? = nil) {
        var targetDict = dict
        if let path = designatedPath {
            targetDict = getInnerObject(inside: targetDict, by: path) as? [String: Any]
        }
        if let _dict = targetDict {
            T._transform(dict: _dict, to: &object)
        }
    }

    /// Finds the internal JSON field in `json` as the `designatedPath` specified, and use it to reassign an exist model
    /// `designatedPath` is a string like `result.data.orderInfo`, which each element split by `.` represents key of each layer, or nil
    public static func update(object: inout T, from json: String?, designatedPath: String? = nil) {
        guard let _json = json else {
            return
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonDict = jsonObject as? [String: Any] {
                update(object: &object, from: jsonDict, designatedPath: designatedPath)
            }
        } catch let error {
            InternalLogger.logError(error)
        }
    }

    /// if the JSON field found by `designatedPath` in `json` is representing a array, such as `[{...}, {...}, {...}]`,
    /// this method converts it to a Models array
    public static func deserializeModelArrayFrom(json: String?, designatedPath: String? = nil) -> [T?]? {
        guard let _json = json else {
            return nil
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments)
            if let jsonArray = getInnerObject(inside: jsonObject, by: designatedPath) as? [Any] {
                return jsonArray.map({ (item) -> T? in
                    return self.deserializeFrom(dict: item as? [String: Any])
                })
            }
        } catch let error {
            InternalLogger.logError(error)
        }
        return nil
    }

    /// mapping raw array to Models array
    public static func deserializeModelArrayFrom(array: NSArray?) -> [T?]? {
        return deserializeModelArrayFrom(array: array as? [Any])
    }

    /// mapping raw array to Models array
    public static func deserializeModelArrayFrom(array: [Any]?) -> [T?]? {
        guard let _arr = array else {
            return nil
        }
        return _arr.map({ (item) -> T? in
            return self.deserializeFrom(dict: item as? NSDictionary)
        })
    }
}

fileprivate func getInnerObject(inside object: Any?, by designatedPath: String?) -> Any? {
    var result: Any? = object
    var abort = false
    if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
        var next = object as? [String: Any]
        paths.forEach({ (seg) in
            if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
                return
            }
            if let _next = next?[seg] {
                result = _next
                next = _next as? [String: Any]
            } else {
                abort = true
            }
        })
    }
    return abort ? nil : result
}
