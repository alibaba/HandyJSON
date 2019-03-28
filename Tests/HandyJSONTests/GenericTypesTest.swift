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

    func testGeneric() {
        let genericClass = GenericClass<AConformToOneProtocolClass, InheritanceBasicType, BConformToOneProtocolStruct, GenericStruct<AConformToOneProtocolClass>>()
        let a = AConformToOneProtocolClass()
        a.a1 = 123
        a.a2 = "456"
        a.a3 = ["hehe": "hoho"]
        let a4 = TestCollectionOfPrimitives()
        a4.arrayInt = [9, 7, 5, 3]
        a.a4 = a4
        genericClass.oneProtocol = a
        var b = BConformToOneProtocolStruct()
        b.b1 = 11111111111
        genericClass.handyJSON = b
        let inheritanceBasicType = InheritanceBasicType()
        inheritanceBasicType.anotherInt = 789
        genericClass.inheritanceBasicType = inheritanceBasicType
        genericClass.basicTypesInClass = b
        var basicStruct = BasicTypesInStruct()
        basicStruct.arrayInt = [8,9,0]
        genericClass.basicTypesInStruct = basicStruct
        var genericStruct = GenericStruct<AConformToOneProtocolClass>()
        genericStruct.a = a
        genericClass.genericStruct = genericStruct

        let json = genericClass.toJSONString() ?? ""
    }
}
