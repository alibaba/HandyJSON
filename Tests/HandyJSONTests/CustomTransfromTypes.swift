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
//  CustomTransfromTypes.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/09/2017.
//

import XCTest
import HandyJSON

enum PureEnum {
    case type1, type2
}

extension PureEnum: HandyJSONCustomTransformable {

    static func _transform(from object: Any) -> PureEnum? {
        if let strValue = object as? String {
            return strValue == "type1" ? PureEnum.type1 : PureEnum.type2
        }
        return nil
    }

    func _plainValue() -> Any? {
        return "\(self)"
    }
}

struct EnumTestType: HandyJSON {
    var aStr: String?
    var aEnum: PureEnum?
}

struct CustomMappingStruct: HandyJSON {
    var name: String?
    var id: String?
    var height: Int?

    mutating func mapping(mapper: HelpingMapper) {
        // specify json field name
        mapper <<<
            self.name <-- "json_name"

        // specify converting method
        mapper <<<
            self.id <-- TransformOf<String, String>(fromJSON: { (rawValue) -> String? in
                if let str = rawValue {
                    return "json_" + str
                }
                return nil
            }, toJSON: { (id) -> String? in
                return id
            })

        mapper <<<
            self.height <-- ("json_height", TransformOf<Int, String>(fromJSON: { (rawValue) -> Int? in
                if let _str = rawValue {
                    return Int(_str) ?? 0
                }
                return nil
            }, toJSON: { (height) -> String? in
                if let _height = height {
                    return "\(_height)"
                }
                return nil
            }))
    }
}

class CustomMappingClass: HandyJSON {
    var name: String?
    var id: String?
    var height: Int?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        // specify json field name
        mapper <<<
                self.name <-- "json_name"

        // specify converting method
        mapper <<<
                self.id <-- TransformOf<String, String>(fromJSON: { (rawStr) -> String? in
                    if let _str = rawStr {
                        return "json_" + _str
                    }
                    return nil
                }, toJSON: { (srcStr) -> String? in
                    return srcStr
                })

        // specify both
        mapper <<<
            self.height <-- ("json_height", TransformOf<Int, Int>(fromJSON: { (rawInt) -> Int? in
                if let _int = rawInt {
                    return _int / 100
                }
                return nil
            }, toJSON: { (srcInt) -> Int? in
                if let _int = srcInt {
                    return _int * 100
                }
                return nil
            }))
    }
}

class KeyArrayMappingClass: HandyJSON {
    var var1: String?
    var var2: String?
    var var3: String?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.var1 <-- ["var1_v1", "var1_v2", "var1_v3"]

        mapper <<<
            self.var2 <-- (["var2_v1", "var2_v2", "var2_v3"], TransformOf<String, String>(fromJSON: { (rawStr) -> String? in
                return rawStr
            }, toJSON: { (srcStr) -> String? in
                return srcStr
            }))

        mapper <<<
            self.var3 <-- ["var3_v1"]
    }
}

struct NotHandyJSON {
    var empty: String?
}

class ExcludedMappingTestClass: HandyJSON {
    var notHandyJSONProperty: NotHandyJSON?
    var name: String?
    var id: String?
    var height: Int?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper >>> self.notHandyJSONProperty
        mapper >>> self.name
    }
}

struct ExcludedMappingTestStruct: HandyJSON {
    var name: String?
    var id: String?
    var height: Int?
    var notHandyJSONProperty: NotHandyJSON?

    mutating func mapping(mapper: HelpingMapper) {
        mapper >>> self.notHandyJSONProperty
        mapper >>> name
    }
}

class FlatLayerModel: HandyJSON {
    var enumMember: StringEnum = StringEnum.Default
    var enumMemberOptional: StringEnum?
    var enumMemberImplicitlyUnwrapped: StringEnum!
    var int: Int = 0
    var stringOptional: String?
    var dictBoolImplicitlyUnwrapped: [String: Bool]!

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            enumMember <-- "lowerLayerModel.enumMember"

        mapper <<<
            enumMemberOptional <-- "lowerLayerModelOptional.enumMemberOptional"

        mapper <<<
            enumMemberImplicitlyUnwrapped <-- "lowerLayerModelImplicitlyUnwrapped.enumMemberImplicitlyUnwrapped"

        mapper <<<
            int <-- "classMember.int"

        mapper <<<
            stringOptional <-- "lowerLayerModelOptional.classMemberOptional.stringOptional"

        mapper <<<
            dictBoolImplicitlyUnwrapped <-- "lowerLayerModelImplicitlyUnwrapped.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped"
    }

    required init() {}
}


class DeepPathPropModel: HandyJSON {
    var enumMemberOptional: StringEnum?

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            enumMemberOptional <-- ["serializeKey", "first layer.second\\.layer.thirdlayer.enumMemberOptional"]
    }

    required init() {}
}
