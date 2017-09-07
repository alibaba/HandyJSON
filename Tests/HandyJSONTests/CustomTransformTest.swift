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
//  CustomTransformTest.swift
//  HandyJSON
//
//  Created by zhouzhuo on 9/27/16.
//

import XCTest
import HandyJSON

class CustomMappingTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStructMapping() {
        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":\"180\"}"
        let a = CustomMappingStruct.deserialize(from: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "json_12345")
        XCTAssert(a.height == 180)
    }

    func testMultipleNamesMapToOneProperty() {
        var jsonString = "{\"var1_v1\":\"var1_value\",\"var2_v1\":\"var2_value\",\"var3_v1\":\"var3_value\"}"
        var a = KeyArrayMappingClass.deserialize(from: jsonString)!
        XCTAssert(a.var1 == "var1_value")
        XCTAssert(a.var2 == "var2_value")
        XCTAssert(a.var3 == "var3_value")

        let toJson = a.toJSON()!
        XCTAssert(toJson["var1_v1"] as? String == "var1_value")
        XCTAssert(toJson["var1_v2"] as? String == nil)
        XCTAssert(toJson["var1_v3"] as? String == nil)
        XCTAssert(toJson["var2_v1"] as? String == "var2_value")
        XCTAssert(toJson["var2_v2"] as? String == nil)
        XCTAssert(toJson["var2_v3"] as? String == nil)
        XCTAssert(toJson["var3_v1"] as? String == "var3_value")

        jsonString = "{\"var1_v2\":\"var1_value\",\"var2_v2\":\"var2_value\",\"var3_v2\":\"var3_value\"}"
        a = KeyArrayMappingClass.deserialize(from: jsonString)!
        XCTAssert(a.var1 == "var1_value")
        XCTAssert(a.var2 == "var2_value")
        XCTAssert(a.var3 == nil)

        jsonString = "{\"var1\":\"var1_value\",\"var2\":\"var2_value\",\"var3\":\"var3_value\"}"
        a = KeyArrayMappingClass.deserialize(from: jsonString)!
        XCTAssert(a.var1 == nil)
        XCTAssert(a.var2 == nil)
        XCTAssert(a.var3 == nil)
    }

    func testClassMapping() {
        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":18000}"
        let a = CustomMappingClass.deserialize(from: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "json_12345")
        XCTAssert(a.height == 180)
    }

    func testExlucdePropertyForClass() {
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = ExcludedMappingTestClass.deserialize(from: jsonString)!
        XCTAssert(a.name == nil)
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }

    func testExcludedPropertyForStruct() {
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180, \"notHandyJSONProperty\":\"value\"}"
        let a = ExcludedMappingTestStruct.deserialize(from: jsonString)!
        XCTAssert(a.name == nil)
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }

    func testCustomTransformableType() {
        let jsonString = "{\"aStr\":\"Bob\",\"aEnum\":\"type2\"}"
        let object = EnumTestType.deserialize(from: jsonString)!
        XCTAssertEqual(PureEnum.type2, object.aEnum!)
    }

    func testSpecifyPropertyPathMapping() {
        let basicClassModel = BasicTypesInClass()
        basicClassModel.int = 11
        basicClassModel.stringOptional = "stringOptional"
        basicClassModel.arrayIntImplicitlyUnwrapped = [1, 2, 3, 4, 5]

        var basicStructModel = BasicTypesInStruct()
        basicStructModel.enumInt = BasicTypesInStruct.EnumInt.Another
        basicStructModel.nsArrayOptional = ["one", "two", "three"]
        basicStructModel.dictBoolImplicitlyUnwrapped = ["true": true, "false": false]

        let lowerModel = LowerLayerModel()
        lowerModel.enumMember = StringEnum.Another
        lowerModel.enumMemberOptional = StringEnum.Another
        lowerModel.enumMemberImplicitlyUnwrapped = StringEnum.Another
        lowerModel.classMember = basicClassModel
        lowerModel.classMemberOptional = basicClassModel
        lowerModel.classMemberImplicitlyUnwrapped = basicClassModel
        lowerModel.structMember = basicStructModel
        lowerModel.structMemberOptional = basicStructModel
        lowerModel.structMemberImplicitlyUnwrapped = basicStructModel

        let topmostModel = TopMostLayerModel()
        topmostModel.classMember = basicClassModel
        topmostModel.classMemberOptional = basicClassModel
        topmostModel.classMemberImplicitlyUnwrapped = basicClassModel
        topmostModel.structMember = basicStructModel
        topmostModel.structMemberOptional = basicStructModel
        topmostModel.structMemberImplicitlyUnwrapped = basicStructModel
        topmostModel.lowerLayerModel = lowerModel
        topmostModel.lowerLayerModelOptional = lowerModel
        topmostModel.lowerLayerModelImplicitlyUnwrapped = lowerModel

        let dict = topmostModel.toJSON()!
        let mappedObject1 = FlatLayerModel.deserialize(from: dict)!

        XCTAssertEqual(mappedObject1.enumMember, StringEnum.Another)
        XCTAssertEqual(mappedObject1.enumMemberOptional, StringEnum.Another)
        XCTAssertEqual(mappedObject1.enumMemberImplicitlyUnwrapped, StringEnum.Another)
        XCTAssertEqual(mappedObject1.int, 11)
        XCTAssertEqual(mappedObject1.stringOptional, "stringOptional")
        XCTAssertEqual(mappedObject1.dictBoolImplicitlyUnwrapped["false"], false)

        let jsonString = topmostModel.toJSONString()!
        let mappedObject2 = FlatLayerModel.deserialize(from: jsonString)!

        XCTAssertEqual(mappedObject2.enumMember, StringEnum.Another)
        XCTAssertEqual(mappedObject2.enumMemberOptional, StringEnum.Another)
        XCTAssertEqual(mappedObject2.enumMemberImplicitlyUnwrapped, StringEnum.Another)
        XCTAssertEqual(mappedObject2.int, 11)
        XCTAssertEqual(mappedObject2.stringOptional, "stringOptional")
        XCTAssertEqual(mappedObject2.dictBoolImplicitlyUnwrapped["false"], false)
    }

    func testMappingDeepPathPropModelFromJSON() {
        let jsonString = "{\"first layer\":{\"second.layer\":{\"thirdlayer\":{\"enumMemberOptional\":\"Another\"}}}}"
        let mappedObject = DeepPathPropModel.deserialize(from: jsonString)!

        XCTAssertEqual(StringEnum.Another, mappedObject.enumMemberOptional)

        let serializeJSON = mappedObject.toJSON()!

        XCTAssertEqual(StringEnum.Another.rawValue, serializeJSON["serializeKey"] as! String)
    }
}
