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
//  Serializer+Legacy.swift
//  HandyJSON
//
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol ModelTransformerProtocol {

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toPrettifyJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toSimpleDictionary() -> [String: Any]?
}

public protocol ArrayTransformerProtocol {

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toPrettifyJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toSimpleArray() -> [Any]?
}

public protocol DictionaryTransformerProtocol {

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toPrettifyJSON() -> String?

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    func toSimpleDictionary() -> [String: Any]?
}

class GenericObjectTransformer: ModelTransformerProtocol, ArrayTransformerProtocol, DictionaryTransformerProtocol {

    private var object: Any?

    init(of object: Any?) {
        self.object = object
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public func toSimpleArray() -> [Any]? {
        if let _object = self.object, let result = GenericObjectTransformer.transformToSimpleObject(object: _object) {
            return result as? [Any]
        }
        return nil
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public func toSimpleDictionary() -> [String: Any]? {
        if let _object = self.object, let result = GenericObjectTransformer.transformToSimpleObject(object: _object) {
            return result as? [String: Any]
        }
        return nil
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public func toJSON() -> String? {
        if let _object = self.object, let result = GenericObjectTransformer.transformToSimpleObject(object: _object) {
            return GenericObjectTransformer.transformSimpleObjectToJSON(object: result)
        }
        return nil
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public func toPrettifyJSON() -> String? {
        if let result = toJSON() {
            let jsonData = result.data(using: String.Encoding.utf8)!
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as AnyObject, let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                return NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
        return nil
    }
}

extension GenericObjectTransformer {

    static func transformToSimpleObject(object: Any) -> Any? {
        if (type(of: object) is PlainJSONValue.Type) {
            return object
        }

        let mirror = Mirror(reflecting: object)

        guard let displayStyle = mirror.displayStyle else {
            return object
        }

        switch displayStyle {
        case .class, .struct:
            var children = [(label: String?, value: Any)]()
            let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
            children += mirrorChildrenCollection

            var currentMirror = mirror
            while let superclassChildren = currentMirror.superclassMirror?.children {
                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
                children += randomCollection
                currentMirror = currentMirror.superclassMirror!
            }

            var dict = [String: Any]()
            children.enumerated().forEach({ (index, element) in
                let key = element.label ?? ""
                let handledValue = transformToSimpleObject(object: element.value)
                if key != "" && handledValue != nil {
                    dict[key] = handledValue
                }
            })

            return dict as Any
        case .enum:
            return object as Any
        case .optional:
            if mirror.children.count != 0 {
                let (_, some) = mirror.children.first!
                return transformToSimpleObject(object: some)
            } else {
                return nil
            }
        case .collection, .set:
            var array = [Any]()
            mirror.children.enumerated().forEach({ (index, element) in
                if let transformValue = transformToSimpleObject(object: element.value) {
                    array.append(transformValue)
                }
            })
            return array as Any
        case .dictionary:
            var dict = [String: Any]()
            mirror.children.enumerated().forEach({ (index, element) in
                let _mirror = Mirror(reflecting: element.value)
                var key: String?
                var value: Any?
                _mirror.children.enumerated().forEach({ (_index, _element) in
                    if _index == 0 {
                        key = "\(_element.value)"
                    } else {
                        value = transformToSimpleObject(object: _element.value)
                    }
                })
                if (key ?? "") != "" && value != nil {
                    dict[key!] = value!
                }
            })
            return dict as Any
        default:
            return object
        }
    }

    static func transformSimpleObjectToJSON(object: Any) -> String {
        let objectType: Any.Type = type(of: object)

        switch objectType {
        case is String.Type, is NSString.Type:
            let json = "\"" + String(describing: object) + "\""
            return json
        case is PlainJSONValue.Type:
            let json = String(describing: object)
            return json
        case is Array<Any>.Type:
            let array = object as! Array<Any>
            var json = ""
            array.enumerated().forEach({ (index, element) in
                if index != 0 {
                    json += ","
                }
                json += transformSimpleObjectToJSON(object: element)
            })
            return "[" + json + "]"
        case is Dictionary<String, Any>.Type:
            let dict = object as! [String: Any]
            var json = ""
            dict.enumerated().forEach({ (index, kv) in
                if index != 0 {
                    json += ","
                }
                json += "\"\(kv.key)\":\(transformSimpleObjectToJSON(object: kv.value))"
            })
            return "{" + json + "}"
        default:
            return "\"\(String(describing: object))\""
        }
    }
}

public class JSONSerializer {

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(model: Any?) -> ModelTransformerProtocol {
        return GenericObjectTransformer(of: model)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(model: AnyObject?) -> ModelTransformerProtocol {
        return GenericObjectTransformer(of: model)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(array: [Any]?) -> ArrayTransformerProtocol {
        return GenericObjectTransformer(of: array)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(array: [AnyObject]?) -> ArrayTransformerProtocol {
        return GenericObjectTransformer(of: array)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(array: NSArray?) -> ArrayTransformerProtocol {
        return GenericObjectTransformer(of: array)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(dict: [String: Any]?) -> DictionaryTransformerProtocol {
        return GenericObjectTransformer(of: dict)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(dict: [String: AnyObject]?) -> DictionaryTransformerProtocol {
        return GenericObjectTransformer(of: dict)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serialize(dict: NSDictionary?) -> DictionaryTransformerProtocol {
        return GenericObjectTransformer(of: dict)
    }

    @available(*, deprecated, message: "This method will be removed in the future, see the replacement serialization methods at: https://github.com/alibaba/handyjson")
    public static func serializeToJSON(object: Any?, prettify: Bool = false) -> String? {
        if prettify {
            return JSONSerializer.serialize(model: object).toPrettifyJSON()
        }
        return JSONSerializer.serialize(model: object).toJSON()
    }
}
