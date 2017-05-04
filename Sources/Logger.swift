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
//  Logger.swift
//  HandyJSON
//
//  Created by zhouzhuo on 08/01/2017.
//

struct InternalLogger {

    static func logError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.error.rawValue {
            print(items, separator: separator, terminator: terminator)
        }
    }

    static func logDebug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.debug.rawValue {
            print(items, separator: separator, terminator: terminator)
        }
    }

    static func logVerbose(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        if HandyJSONConfiguration.debugMode.rawValue <= DebugMode.verbose.rawValue {
            print(items, separator: separator, terminator: terminator)
        }
    }
}
