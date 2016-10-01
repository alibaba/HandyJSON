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

public class JSONSerializer {

    public static func serializeToJSON(object: Any?, prettify: Bool = false) -> String? {
        if let _object = object {
            var json = _serializeToJSON(object: _object)

            if prettify {
                let jsonData = json.data(using: String.Encoding.utf8)!
                let jsonObject:AnyObject = try! JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
                let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                json = NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)! as String
            }
            return json
        } else {
            return nil
        }
    }

    static func _serializeToJSON(object: Any) -> String {

        if (type(of: object) is String.Type || type(of: object) is NSString.Type ) {
            let json = "\"" + String(describing: object)  + "\""
            return json
        } else if (type(of: object) is BasePropertyProtocol.Type) {
            let json = String(describing: object)
            return json
        }

        var json = String()
        let mirror = Mirror(reflecting: object)

        if mirror.displayStyle == .class || mirror.displayStyle == .struct {
            var handledValue = String()
            var children = [(label: String?, value: Any)]()
            let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
            children += mirrorChildrenCollection

            var currentMirror = mirror
            while let superclassChildren = currentMirror.superclassMirror?.children {
                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
                children += randomCollection
                currentMirror = currentMirror.superclassMirror!
            }

            children.enumerated().forEach({ (index, element) in
                handledValue = _serializeToJSON(object: element.value)
                json += "\"\(element.label ?? "")\":\(handledValue)" + (index < children.count-1 ? "," : "")
            })

            return "{" + json + "}"
        } else if mirror.displayStyle == .enum {
            return  "\"" + String(describing: object) + "\""
        } else if  mirror.displayStyle == .optional {
            if mirror.children.count != 0 {
                let (_, some) = mirror.children.first!
                return _serializeToJSON(object: some)
            } else {
                return "null"
            }
        } else if mirror.displayStyle == .collection || mirror.displayStyle == .set {
            json = "["

            let count = mirror.children.count
            mirror.children.enumerated().forEach({ (index, element) in
                let transformValue = _serializeToJSON(object: element.value)
                json += transformValue
                json += (index < count-1 ? "," : "")
            })

            json += "]"
            return json
        } else if mirror.displayStyle == .dictionary {
            json += "{"
            mirror.children.enumerated().forEach({ (index, element) in
                let _mirror = Mirror(reflecting: element.value)
                _mirror.children.enumerated().forEach({ (_index, _element) in
                    if _index == 0 {
                        json += _serializeToJSON(object: _element.value) + ":"
                    } else {
                        json += _serializeToJSON(object: _element.value)
                        json += (index < mirror.children.count-1 ? "," : "")
                    }
                })
            })
            json += "}"
            return json
        } else {
            return String(describing: object) != "nil" ? "\"\(object)\"" : "null"
        }
    }
}
