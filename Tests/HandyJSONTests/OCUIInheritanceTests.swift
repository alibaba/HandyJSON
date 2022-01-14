//
//  OCUIInheritanceTests.swift
//  HandyJSON iOS Tests
//
//  Created by chantu on 2020/2/24.
//  Copyright © 2020 aliyun. All rights reserved.
//

import Foundation
import XCTest
import HandyJSON

class OCUIInheritanceTests: XCTestCase {

    func testInheritFromUIViewController() {
        let obj = InheritFromUIViewControllerClass()
        obj.a = 0x1234
        obj.b = "hehe"

        let JSONString = obj.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<InheritFromUIViewControllerClass>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.a, 0x1234)
        XCTAssertEqual(mappedObject!.b, "hehe")
    }
    
    func testSubClassOfInheritFromUIViewController() {
        let obj = SubClassOfInheritFromUIViewController()
        obj.a = 0x1234
        obj.b = "hehe"
        obj.c = 0.5678

        let JSONString = obj.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<SubClassOfInheritFromUIViewController>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.a, 0x1234)
        XCTAssertEqual(mappedObject!.b, "hehe")
        XCTAssertEqual(mappedObject!.c, 0.5678)
    }
}
