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
//  SerializeToSimpleObjectTest.swift
//  HandyJSON
//
//  Created by zhouzhuo on 10/23/16.
//

import Foundation
import XCTest
import HandyJSON

class serializeToSimpleObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func stringCompareHelper(_ actual: String?, _ expected: String?) {
        print(actual ?? "")
        print(expected ?? "")
        XCTAssertTrue(expected == actual, "expected value:\(expected) not equal to actual:\(actual)")
    }

    func testTransformClassToDictionary() {
        class A {
            var a: String?
            var b: Int?
            var c: [Double]?

            init() {
                self.a = "hello"
                self.b = 12345
                self.c = [1.1, 2.1]
            }
        }

        class B {
            var a: A?
            var b: [A]?

            init() {
                self.a = A()
                self.b = [A(), A(), A()]
            }
        }

        let dict1 = JSONSerializer.serialize(model: A()).toSimpleDictionary()!
        XCTAssertEqual(dict1["a"] as! String, "hello")
        XCTAssertEqual(dict1["b"] as! Int, 12345)
        XCTAssertEqual(dict1["c"] as! [Double], [1.1, 2.1])

        let dict2 = JSONSerializer.serialize(model: B()).toSimpleDictionary()!
        XCTAssertEqual((dict2["a"] as! [String:Any])["a"] as! String, "hello")

        let dict3 = (dict2["b"] as! [Any])[0] as! [String: Any]
        XCTAssertEqual(dict3["a"] as! String, "hello")
        XCTAssertEqual(dict3["b"] as! Int, 12345)
        XCTAssertEqual(dict3["c"] as! [Double], [1.1, 2.1])
    }

    func testTransformStructToDictionary() {
        struct A {
            var a: String?
            var b: Int?
            var c: [Double]?

            init() {
                self.a = "hello"
                self.b = 12345
                self.c = [1.1, 2.1]
            }
        }

        struct B {
            var a: A?
            var b: [A]?

            init() {
                self.a = A()
                self.b = [A(), A(), A()]
            }
        }

        let dict1 = JSONSerializer.serialize(model: A()).toSimpleDictionary()!
        XCTAssertEqual(dict1["a"] as! String, "hello")
        XCTAssertEqual(dict1["b"] as! Int, 12345)
        XCTAssertEqual(dict1["c"] as! [Double], [1.1, 2.1])

        let dict2 = JSONSerializer.serialize(model: B()).toSimpleDictionary()!
        XCTAssertEqual((dict2["a"] as! [String:Any])["a"] as! String, "hello")

        let dict3 = (dict2["b"] as! [Any])[0] as! [String: Any]
        XCTAssertEqual(dict3["a"] as! String, "hello")
        XCTAssertEqual(dict3["b"] as! Int, 12345)
        XCTAssertEqual(dict3["c"] as! [Double], [1.1, 2.1])
    }

    func testTransformComplexDictionaryToSimple() {
        class A {
            var a: String?
            var b: Int?
            var c: [Double]?

            init() {
                self.a = "hello"
                self.b = 12345
                self.c = [1.1, 2.1]
            }
        }

        let dict: [String: Any] = ["a": A(), "b": [A(), A(), A()]]
        let simpleDict = JSONSerializer.serialize(dict: dict).toSimpleDictionary()!
        let dict3 = (simpleDict["b"] as! [Any])[0] as! [String: Any]
        XCTAssertEqual(dict3["a"] as! String, "hello")
        XCTAssertEqual(dict3["b"] as! Int, 12345)
        XCTAssertEqual(dict3["c"] as! [Double], [1.1, 2.1])

        let nsDict: NSDictionary = ["a": A(), "b": [A(), A(), A()]]
        let simpleDict2 = JSONSerializer.serialize(dict: nsDict).toSimpleDictionary()!
        let dict4 = (simpleDict2["b"] as! [Any])[0] as! [String: Any]
        XCTAssertEqual(dict4["a"] as! String, "hello")
        XCTAssertEqual(dict4["b"] as! Int, 12345)
        XCTAssertEqual(dict4["c"] as! [Double], [1.1, 2.1])
    }

    func testTransformComplexArraryToSimple() {
        class A {
            var a: String?
            var b: Int?
            var c: [Double]?

            init() {
                self.a = "hello"
                self.b = 12345
                self.c = [1.1, 2.1]
            }
        }

        let array = [A(), A(), A()]
        let simpleArray = JSONSerializer.serialize(array: array as [Any]).toSimpleArray()!
        let dict3 = simpleArray[0] as! [String: Any]
        XCTAssertEqual(dict3["a"] as! String, "hello")
        XCTAssertEqual(dict3["b"] as! Int, 12345)
        XCTAssertEqual(dict3["c"] as! [Double], [1.1, 2.1])

        let nsArray: NSArray = [A(), A(), A()]
        let simpleArray2 = JSONSerializer.serialize(array: nsArray).toSimpleArray()!
        let dict4 = simpleArray2[0] as! [String: Any]
        XCTAssertEqual(dict4["a"] as! String, "hello")
        XCTAssertEqual(dict4["b"] as! Int, 12345)
        XCTAssertEqual(dict4["c"] as! [Double], [1.1, 2.1])
    }
}
