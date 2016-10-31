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

public class JSONDeserializer<T: HandyJSON> {

    public static func deserializeFrom(dict: NSDictionary?) -> T? {
        guard let _dict = dict else {
            return nil
        }
        return T._transform(dict: _dict, toType: T.self) as? T
    }

    public static func deserializeFrom(dict: NSDictionary?, designatedPath: String?) -> T? {
        var nodeValue: AnyObject? = dict
        if let paths = designatedPath?.components(separatedBy: "."), paths.count > 0 {
            paths.forEach({ (seg) in
                nodeValue = (nodeValue as? NSDictionary)?.object(forKey: seg) as AnyObject?
            })
        }
        if let targetDict = nodeValue as? NSDictionary {
            return deserializeFrom(dict: targetDict)
        }
        return nil
    }

    public static func deserializeFrom(json: String?) -> T? {
        return deserializeFrom(json: json, designatedPath: nil)
    }

    public static func deserializeFrom(json: String?, designatedPath: String?) -> T? {
        guard let _json = json else {
            return nil
        }
        if let jsonObject = try? JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments) {
            if let jsonDict = jsonObject as? NSDictionary {
                return deserializeFrom(dict: jsonDict, designatedPath: designatedPath)
            }
        }
        return nil
    }

    public static func deserializeModelArrayFrom(json: String?) -> Array<T?>? {
        guard let _json = json else {
            return nil
        }
        if let jsonObject = try? JSONSerialization.jsonObject(with: _json.data(using: String.Encoding.utf8)!, options: .allowFragments) {
            if let jsonArray = jsonObject as? NSArray {
                return jsonArray.map({ (jsonDict) -> T? in
                    return deserializeFrom(dict: jsonDict as? NSDictionary)
                })
            }
        }
        return nil
    }
}
