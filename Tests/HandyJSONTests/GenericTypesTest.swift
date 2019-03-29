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

    // TODO:
    // 1. 无父类的泛型
    // 2. 有父类的泛型
    // 3. 有父类的父类的泛型
    // 4. 父类也是泛型的泛型
    // 5. 遵守协议的泛型
    // 6. 普通类的泛型
    // 7. struct 的泛型
    // 8. enum 的泛型
    // 9. 有多个泛型，泛型的类型互不相同
    // 10. 继承空的类

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
    }

    func testComplecatedGeneric() {
    }
}
