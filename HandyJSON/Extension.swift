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

/*
 
 Int,
 Int8,
 Int16,
 Int32,
 Int64,
 UInt,
 UInt8,
 UInt16,
 UInt32,
 UInt64,
 Bool,
 Float,
 Double,
 String,
 */

extension Int: BasePropertyProtocol {}
extension Int8: BasePropertyProtocol {}
extension Int16: BasePropertyProtocol {}
extension Int32: BasePropertyProtocol {}
extension Int64: BasePropertyProtocol {}
extension UInt: BasePropertyProtocol {}
extension UInt8: BasePropertyProtocol {}
extension UInt16: BasePropertyProtocol {}
extension UInt32: BasePropertyProtocol {}
extension UInt64: BasePropertyProtocol {}
extension Bool: BasePropertyProtocol {}
extension Float: BasePropertyProtocol {}
extension Double: BasePropertyProtocol {}
extension String: BasePropertyProtocol {}

extension NSString: BasePropertyProtocol {}
extension NSNumber: BasePropertyProtocol {}

