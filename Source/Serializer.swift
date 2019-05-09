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

public extension HandyJSON {

    func toJSON() -> [String: Any]? {
        if let dict = Self._serializeAny(object: self) as? [String: Any] {
            return dict
        }
        return nil
    }

    func toJSONString(prettyPrint: Bool = false) -> String? {

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

    func toJSON() -> [[String: Any]?] {
        return self.map{ $0.toJSON() }
    }

    func toJSONString(prettyPrint: Bool = false) -> String? {

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
