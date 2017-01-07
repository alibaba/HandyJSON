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
//  Created by zhouzhuo on 07/01/2017.
//

protocol PointerType : Equatable {
    associatedtype Pointee
    var pointer: UnsafePointer<Pointee> { get set }
}

extension PointerType {
    init<T>(pointer: UnsafePointer<T>) {
        func cast<T, U>(_ value: T) -> U {
            return unsafeBitCast(value, to: U.self)
        }
        self = cast(UnsafePointer<Pointee>(pointer))
    }
}

func == <T: PointerType>(lhs: T, rhs: T) -> Bool {
    return lhs.pointer == rhs.pointer
}
