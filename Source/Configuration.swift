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
//  Configuration.swift
//  HandyJSON
//
//  Created by zhouzhuo on 08/01/2017.
//

public struct DeserializeOptions: OptionSet {
    public let rawValue: Int

    public static let caseInsensitive = DeserializeOptions(rawValue: 1 << 0)
    
    public static let snakeToCamel = DeserializeOptions(rawValue: 1 << 1)

    public static let defaultOptions: DeserializeOptions = []

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public enum DebugMode: Int {
    case verbose = 0
    case debug = 1
    case error = 2
    case none = 3
}

public struct HandyJSONConfiguration {

    private static var _mode = DebugMode.error
    public static var debugMode: DebugMode {
        get {
            return _mode
        }
        set {
            _mode = newValue
        }
    }

    public static var deserializeOptions: DeserializeOptions = .defaultOptions
}
