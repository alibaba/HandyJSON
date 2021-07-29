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
//  ExtendCustomBasicType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/09/2017.
//

public protocol _ExtendCustomBasicType: _Transformable {

    static func _transform(from object: Any, transformer: _Transformer?) -> Self?
    func _plainValue(transformer: _Transformer?) -> Any?
}
