//
//  GenericTypesTest.swift
//  HandyJSON
//
//  Created by chantu on 2019/3/27.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation
import HandyJSON
import XCTest

class GenericTypesTest: XCTestCase {

    func testNoSuperClass() {

        let basicCls = BasicTypesInClass()
        basicCls.intOptional = 123
        basicCls.arrayString = ["456", "789"]

        let cls = BaseGenericClass<BasicTypesInClass>()
        cls.base = basicCls

        let json = cls.toJSONString()

        let deserializedCls = BaseGenericClass<BasicTypesInClass>.deserialize(from: json)

        XCTAssertEqual(deserializedCls!.base!.intOptional, 123)
        XCTAssertEqual(deserializedCls!.base!.arrayString, ["456", "789"])

        let inheritBasicCls = InheritanceBasicType()
        inheritBasicCls.intOptional = 123
        inheritBasicCls.arrayString = ["456", "789"]

        let cls1 = GenericWithNormalClass<InheritanceBasicType>()
        cls1.t = inheritBasicCls

        let json1 = cls1.toJSONString()

        let deserializedCls1 = GenericWithNormalClass<InheritanceBasicType>.deserialize(from: json1)

        XCTAssertEqual(deserializedCls1!.t!.intOptional, 123)
        XCTAssertEqual(deserializedCls1!.t!.arrayString, ["456", "789"])
    }

    func testSuperClass() {

        let basicCls = BasicTypesInClass()
        basicCls.intOptional = 123
        basicCls.arrayString = ["456", "789"]
        let cls = SuperGenericClass<BasicTypesInClass>()
        cls.t = basicCls

        let json = cls.toJSONString()

        let deserializedCls = SuperGenericClass<BasicTypesInClass>.deserialize(from: json)

        XCTAssertEqual(deserializedCls!.t!.intOptional, 123)
        XCTAssertEqual(deserializedCls!.t!.arrayString, ["456", "789"])

        let cls1 = SubGenericClassInheritGeneric<BasicTypesInClass>()
        cls1.t = basicCls

        let json1 = cls1.toJSONString()

        let deserializedCls1 = SubGenericClassInheritGeneric<BasicTypesInClass>.deserialize(from: json1)

        XCTAssertEqual(deserializedCls1!.t!.intOptional, 123)
        XCTAssertEqual(deserializedCls1!.t!.arrayString, ["456", "789"])
    }

    func testSuperSuperClass() {

        let basicCls = BasicTypesInClass()
        basicCls.intOptional = 123
        basicCls.arrayString = ["456", "789"]
        let cls = SubGenericClassInheritGeneric<BasicTypesInClass>()
        cls.t = basicCls

        let json = cls.toJSONString()

        let deserializedCls = SubGenericClassInheritGeneric<BasicTypesInClass>.deserialize(from: json)

        XCTAssertEqual(deserializedCls!.t!.intOptional, 123)
        XCTAssertEqual(deserializedCls!.t!.arrayString, ["456", "789"])

        let cls1 = SubGenericClass<BasicTypesInClass>()
        cls1.sub = basicCls

        let json1 = cls1.toJSONString()

        let deserializedCls1 = SubGenericClass<BasicTypesInClass>.deserialize(from: json1)

        XCTAssertEqual(deserializedCls1!.sub!.intOptional, 123)
        XCTAssertEqual(deserializedCls1!.sub!.arrayString, ["456", "789"])

        let inheritBasicCls = InheritanceBasicType()
        inheritBasicCls.intOptional = 123
        inheritBasicCls.arrayString = ["456", "789"]

        let cls2 = SubGenericClassInheritGenericWithNormalClass<InheritanceBasicType>()
        cls2.t = inheritBasicCls

        let json2 = cls2.toJSONString()

        let deserializedCls2 = SubGenericClassInheritGenericWithNormalClass<InheritanceBasicType>.deserialize(from: json2)

        XCTAssertEqual(deserializedCls2!.t!.intOptional, 123)
        XCTAssertEqual(deserializedCls2!.t!.arrayString, ["456", "789"])
    }

    func testStructClass() {

        var basicStruct = BasicTypesInStruct()
        basicStruct.intOptional = 123
        basicStruct.arrayString = ["456", "789"]
        var genericStruct = GenericStruct<BasicTypesInStruct>()
        genericStruct.t = basicStruct

        let json = genericStruct.toJSONString()

        let deserializedStruct = GenericStruct<BasicTypesInStruct>.deserialize(from: json)

        XCTAssertEqual(deserializedStruct!.t!.intOptional, 123)
        XCTAssertEqual(deserializedStruct!.t!.arrayString, ["456", "789"])

        let basicCls = BasicTypesInClass()
        basicCls.intOptional = 123
        basicCls.arrayString = ["456", "789"]
        var genericStruct1 = GenericStruct<BasicTypesInClass>()
        genericStruct1.t = basicCls

        let json1 = genericStruct1.toJSONString()

        let deserializedStruct1 = GenericStruct<BasicTypesInStruct>.deserialize(from: json1)

        XCTAssertEqual(deserializedStruct1!.t!.intOptional, 123)
        XCTAssertEqual(deserializedStruct1!.t!.arrayString, ["456", "789"])
    }

    func testComplicatedGeneric() {

        let basicCls = BasicTypesInClass()
        basicCls.intOptional = 123
        basicCls.arrayString = ["456", "789"]

        let inheritBasicCls = InheritanceBasicType()
        inheritBasicCls.intOptional = 123
        inheritBasicCls.arrayString = ["456", "789"]

        var basicStruct = BasicTypesInStruct()
        basicStruct.intOptional = 123
        basicStruct.arrayString = ["456", "789"]

        let complicated = ComplicatedGenericClass<InheritanceBasicType, InheritanceBasicType, BasicTypesInStruct, BasicTypesInClass>()
        complicated.basicTypesInClass = inheritBasicCls
        complicated.inheritanceBasicType = inheritBasicCls
        complicated.handyJSONProtocol1 = basicStruct
        complicated.handyJSONProtocol2 = basicCls
        complicated.basicTypesInStruct = basicStruct

        let json = complicated.toJSONString()

        let deserializedComplicated = ComplicatedGenericClass<InheritanceBasicType, InheritanceBasicType, BasicTypesInStruct, BasicTypesInClass>.deserialize(from: json)

        XCTAssertEqual(deserializedComplicated!.basicTypesInClass!.intOptional, 123)
        XCTAssertEqual(deserializedComplicated!.basicTypesInClass!.arrayString, ["456", "789"])
        XCTAssertEqual(deserializedComplicated!.inheritanceBasicType!.intOptional, 123)
        XCTAssertEqual(deserializedComplicated!.inheritanceBasicType!.arrayString, ["456", "789"])
        XCTAssertEqual(deserializedComplicated!.handyJSONProtocol1!.intOptional, 123)
        XCTAssertEqual(deserializedComplicated!.handyJSONProtocol1!.arrayString, ["456", "789"])
        XCTAssertEqual(deserializedComplicated!.handyJSONProtocol2!.intOptional, 123)
        XCTAssertEqual(deserializedComplicated!.handyJSONProtocol2!.arrayString, ["456", "789"])
        XCTAssertEqual(deserializedComplicated!.basicTypesInStruct!.intOptional, 123)
        XCTAssertEqual(deserializedComplicated!.basicTypesInStruct!.arrayString, ["456", "789"])
    }
}
