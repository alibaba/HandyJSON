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
//  NestTypes.swift
//  HandyJSON
//
//  Created by zhouzhuo on 07/09/2017.
//

import Foundation
import HandyJSON

enum StringEnum: String, HandyJSONEnum {
    case Default = "Default"
    case Another = "Another"
}

class LowerLayerModel: HandyJSON {
    var enumMember: StringEnum = StringEnum.Default
    var enumMemberOptional: StringEnum?
    var enumMemberImplicitlyUnwrapped: StringEnum!
    var structMember: BasicTypesInStruct = BasicTypesInStruct()
    var structMemberOptional: BasicTypesInStruct?
    var structMemberImplicitlyUnwrapped: BasicTypesInStruct!
    var classMember: BasicTypesInClass = BasicTypesInClass()
    var classMemberOptional: BasicTypesInClass?
    var classMemberImplicitlyUnwrapped: BasicTypesInClass!

    required init() {}
}

class TopMostLayerModel: HandyJSON {
    var structMember: BasicTypesInStruct = BasicTypesInStruct()
    var structMemberOptional: BasicTypesInStruct?
    var structMemberImplicitlyUnwrapped: BasicTypesInStruct!
    var classMember: BasicTypesInClass = BasicTypesInClass()
    var classMemberOptional: BasicTypesInClass?
    var classMemberImplicitlyUnwrapped: BasicTypesInClass!
    var lowerLayerModel: LowerLayerModel = LowerLayerModel()
    var lowerLayerModelOptional: LowerLayerModel?
    var lowerLayerModelImplicitlyUnwrapped: LowerLayerModel!

    required init() {}
}
