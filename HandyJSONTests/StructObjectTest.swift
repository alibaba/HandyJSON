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

//  Created by zhouzhuo on 8/7/16.
//

import XCTest
import HandyJSON

class StructObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleStruct() {
        struct A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?
        }

        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }

    func testStructWithArrayProperty() {
        struct B: HandyJSON {
            var id: Int?
            var arr1: [Int]?
            var arr2: [String]?
        }

        let jsonString = "{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}"
        let b = B.deserialize(from: jsonString)!
        XCTAssert(b.id == 123456)
        XCTAssert(b.arr1?.count == 6)
        XCTAssert(b.arr2?.count == 5)
        XCTAssert(b.arr1?.last == 6)
        XCTAssert(b.arr2?.last == "e")
    }

    func testStructWithiImpliicitlyUnwrappedOptionalProperty() {
        struct C: HandyJSON {
            var id: Int?
            var arr1: [Int?]!
            var arr2: [String?]?
        }

        let jsonString = "{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}"
        let c = C.deserialize(from: jsonString)!
        XCTAssert(c.id == 123456)
        XCTAssert(c.arr1.count == 6)
        XCTAssert(c.arr2?.count == 5)
        XCTAssert((c.arr1.last ?? 0) == 6)
        XCTAssert((c.arr2?.last ?? "") == "e")
    }

    func testStructWithDummyProperty() {
        struct C: HandyJSON {
            var id: Int?
            var arr1: [Int?]!
            var arr2: [String?]?
        }
        struct D: HandyJSON {
            var dummy1: String?
            var id: Int!
            var arr1: [Int]?
            var dummy2: C?
            var arr2: [String] = [String]()
            var dumimy3: C!
        }

        let jsonString = "{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}"
        let d = D.deserialize(from: jsonString)!
        XCTAssert(d.id == 123456)
        XCTAssert(d.arr1?.count == 6)
        XCTAssert(d.arr2.count == 5)
        XCTAssert(d.arr1?.last == 6)
        XCTAssert(d.arr2.last == "e")
    }

    func testStructWithiDummyiJsonField() {
        struct E: HandyJSON {
            var id: Int?
            var arr1: [Int?]!
            var arr2: [String?]?
        }

        let jsonString = "{\"id\":123456,\"dummy1\":23334,\"arr1\":[1,2,3,4,5,6],\"dummy2\":\"string\",\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}"
        let e = E.deserialize(from: jsonString)!
        XCTAssert(e.id == 123456)
        XCTAssert(e.arr1.count == 6)
        XCTAssert(e.arr2?.count == 5)
        XCTAssert((e.arr1.last ?? 0) == 6)
        XCTAssert((e.arr2?.last ?? "") == "e")
    }

    func testStructWithiDesiginatePath() {
        struct F: HandyJSON {
            var id: Int?
            var arr1: [Int?]!
            var arr2: [String?]?
        }

        let jsonString = "{\"data\":{\"result\":{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}},\"code\":200}"
        var f = F.deserialize(from: jsonString, designatedPath: "data.result")!
        XCTAssert(f.id == 123456)
        XCTAssert(f.arr1.count == 6)
        XCTAssert(f.arr2?.count == 5)
        XCTAssert((f.arr1.last ?? 0) == 6)
        XCTAssert((f.arr2?.last ?? "") == "e")

        f = F.deserialize(from: jsonString, designatedPath: "data.result.")!
        XCTAssert(f.id == 123456)
        XCTAssert(f.arr1.count == 6)
        XCTAssert(f.arr2?.count == 5)
        XCTAssert((f.arr1.last ?? 0) == 6)
        XCTAssert((f.arr2?.last ?? "") == "e")

        f =  F.deserialize(from: jsonString, designatedPath: ".data.result.")!
        XCTAssert(f.id == 123456)
        XCTAssert(f.arr1.count == 6)
        XCTAssert(f.arr2?.count == 5)
        XCTAssert((f.arr1.last ?? 0) == 6)
        XCTAssert((f.arr2?.last ?? "") == "e")

        let targetJsonString = "{\"id\":123456,\"arr1\":[1,2,3,4,5,6],\"arr2\":[\"a\",\"b\",\"c\",\"d\",\"e\"]}"
        f =  F.deserialize(from: targetJsonString, designatedPath: "")!
        XCTAssert(f.id == 123456)
        XCTAssert(f.arr1.count == 6)
        XCTAssert(f.arr2?.count == 5)
        XCTAssert((f.arr1.last ?? 0) == 6)
        XCTAssert((f.arr2?.last ?? "") == "e")

        f = F.deserialize(from: targetJsonString, designatedPath: ".")!
        XCTAssert(f.id == 123456)
        XCTAssert(f.arr1.count == 6)
        XCTAssert(f.arr2?.count == 5)
        XCTAssert((f.arr1.last ?? 0) == 6)
        XCTAssert((f.arr2?.last ?? "") == "e")
    }
}
