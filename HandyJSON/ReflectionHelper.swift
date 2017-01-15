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
//  Helper.swift
//  HandyJSON
//
//  Created by zhouzhuo on 07/01/2017.
//

struct ReflectionHelper {

    static func mutableStorage<T>(instance: inout T) -> UnsafeMutableRawPointer {
        return UnsafeMutableRawPointer(mutating: storage(instance: &instance))
    }

    static func storage<T>(instance: inout T) -> UnsafeRawPointer {
        if type(of: instance) is AnyClass {
            let opaquePointer = Unmanaged.passUnretained(instance as AnyObject).toOpaque()
            return UnsafeRawPointer(opaquePointer)
        } else {
            return withUnsafePointer(to: &instance) { pointer in
                return UnsafeRawPointer(pointer)
            }
        }
    }
}


