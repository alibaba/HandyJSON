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

    func testNSArrayDeserialization() {
        class A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}
        }

        let jsonArrayString = "[{\"name\":\"Bob\",\"id\":\"1\",\"height\":180}, {\"name\":\"Lily\",\"id\":\"2\",\"height\":150}, {\"name\":\"Lucy\",\"id\":\"3\",\"height\":160}]"

        let jsonObject = try! JSONSerialization.jsonObject(with: jsonArrayString.data(using: String.Encoding.utf8)!, options: .allowFragments)
        let nsArray = jsonObject as! NSArray
        let arr = [A].deserialize(from: nsArray)!
        XCTAssert(arr[0]?.name == "Bob")
        XCTAssert(arr[0]?.id == "1")
        XCTAssert(arr[0]?.height == 180)
        XCTAssert(arr[1]?.name == "Lily")
        XCTAssert(arr[1]?.id == "2")
        XCTAssert(arr[1]?.height == 150)
        XCTAssert(arr[2]?.name == "Lucy")
        XCTAssert(arr[2]?.id == "3")
        XCTAssert(arr[2]?.height == 160)
    }

    func testArrayJSONDeserialization() {
        class A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}
        }

        let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\",\"height\":180}, {\"name\":\"Lily\",\"id\":\"2\",\"height\":150}, {\"name\":\"Lucy\",\"id\":\"3\",\"height\":160}]"
        let arr = [A].deserialize(from: jsonArrayString)!
        XCTAssert(arr[0]?.name == "Bob")
        XCTAssert(arr[0]?.id == "1")
        XCTAssert(arr[0]?.height == 180)
        XCTAssert(arr[1]?.name == "Lily")
        XCTAssert(arr[1]?.id == "2")
        XCTAssert(arr[1]?.height == 150)
        XCTAssert(arr[2]?.name == "Lucy")
        XCTAssert(arr[2]?.id == "3")
        XCTAssert(arr[2]?.height == 160)
    }

    func testArrayJSONDeserializationWithDesignatePath() {
        class A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}
        }

        let jsonArrayString: String? = "{\"result\":{\"data\":[{\"name\":\"Bob\",\"id\":\"1\",\"height\":180},{\"name\":\"Lily\",\"id\":\"2\",\"height\":150},{\"name\":\"Lucy\",\"id\":\"3\",\"height\":160}]}}"
        let arr = [A].deserialize(from: jsonArrayString, designatedPath: "result.data")!
        XCTAssert(arr[0]?.name == "Bob")
        XCTAssert(arr[0]?.id == "1")
        XCTAssert(arr[0]?.height == 180)
        XCTAssert(arr[1]?.name == "Lily")
        XCTAssert(arr[1]?.id == "2")
        XCTAssert(arr[1]?.height == 150)
        XCTAssert(arr[2]?.name == "Lucy")
        XCTAssert(arr[2]?.id == "3")
        XCTAssert(arr[2]?.height == 160)
    }

    func testTypeAdaptationString2Others() {
        class F: HandyJSON {
            // from corresponding type
            var aBool: Bool?
            var aFloat: Float?
            var aDouble: Double?
            var aNSNumber: NSNumber?
            var aInt: Int?
            var aInt8: Int8?
            var aInt16: Int16?
            var aInt32: Int32?
            var aInt64: Int64?
            var aUInt: UInt?
            var aUInt8: UInt8?
            var aUInt16: UInt16?
            var aUInt32: UInt32?
            var aUInt64: UInt64?

            // from string
            var bBool: Bool?
            var bFloat: Float?
            var bDouble: Double?
            var bNSNumber: NSNumber?
            var bInt: Int?
            var bInt8: Int8?
            var bInt16: Int16?
            var bInt32: Int32?
            var bInt64: Int64?
            var bUInt: UInt?
            var bUInt8: UInt8?
            var bUInt16: UInt16?
            var bUInt32: UInt32?
            var bUInt64: UInt64?

            required init() {}
        }

        let jsonString = "{\"aBool\":false,\"aFloat\":1.23,\"aDouble\":1.23,\"aNSNumber\":1.23,\"aInt\":-1,\"aInt8\":-1,\"aInt16\":-1,\"aInt32\":-1,\"aInt64\":-1,\"aUInt\":1,\"aUInt8\":1,\"aUInt16\":1,\"aUInt32\":1,\"aUInt64\":1,\"bBool\":\"false\",\"bFloat\":\"1.23\",\"bDouble\":\"1.23\",\"bNSNumber\":\"1.23\",\"bInt\":\"-1\",\"bInt8\":\"-1\",\"bInt16\":\"-1\",\"bInt32\":\"-1\",\"bInt64\":\"-1\",\"bUInt\":\"1\",\"bUInt8\":\"1\",\"bUInt16\":\"1\",\"bUInt32\":\"1\",\"bUInt64\":\"1\"}"
        let model = F.deserialize(from: jsonString)!
        XCTAssertTrue(model.aBool == false)
        XCTAssertTrue(model.aFloat == 1.23)
        XCTAssertTrue(model.aDouble == 1.23)
        XCTAssertTrue(model.aNSNumber == 1.23)
        XCTAssertTrue(model.aInt == -1)
        XCTAssertTrue(model.aInt8 == -1)
        XCTAssertTrue(model.aInt16 == -1)
        XCTAssertTrue(model.aInt32 == -1)
        XCTAssertTrue(model.aInt64 == -1)
        XCTAssertTrue(model.aUInt == 1)
        XCTAssertTrue(model.aUInt8 == 1)
        XCTAssertTrue(model.aUInt16 == 1)
        XCTAssertTrue(model.aUInt32 == 1)
        XCTAssertTrue(model.aUInt64 == 1)
        XCTAssertTrue(model.bBool == false)
        XCTAssertTrue(model.bFloat == 1.23)
        XCTAssertTrue(model.bDouble == 1.23)
        XCTAssertTrue(model.bNSNumber == 1.23)
        XCTAssertTrue(model.bInt == -1)
        XCTAssertTrue(model.bInt8 == -1)
        XCTAssertTrue(model.bInt16 == -1)
        XCTAssertTrue(model.bInt32 == -1)
        XCTAssertTrue(model.bInt64 == -1)
        XCTAssertTrue(model.bUInt == 1)
        XCTAssertTrue(model.bUInt8 == 1)
        XCTAssertTrue(model.bUInt16 == 1)
        XCTAssertTrue(model.bUInt32 == 1)
        XCTAssertTrue(model.bUInt64 == 1)
    }

    func testTypeAdaptationOthers2String() {
        class G: HandyJSON {
            // to string
            var aBool: String?
            var aFloat: String?
            var aDouble: String?
            var aNSNumber: String?
            var aInt: String?
            var aInt8: String?
            var aInt16: String?
            var aInt32: String?
            var aInt64: String?
            var aUInt: String?
            var aUInt8: String?
            var aUInt16: String?
            var aUInt32: String?
            var aUInt64: String?

            // to nsstring
            var bBool: NSString?
            var bFloat: NSString?
            var bDouble: NSString?
            var bNSNumber: NSString?
            var bInt: NSString?
            var bInt8: NSString?
            var bInt16: NSString?
            var bInt32: NSString?
            var bInt64: NSString?
            var bUInt: NSString?
            var bUInt8: NSString?
            var bUInt16: NSString?
            var bUInt32: NSString?
            var bUInt64: NSString?

            required init() {}
        }

        let jsonString = "{\"aBool\":false,\"aFloat\":1.23,\"aDouble\":1.23,\"aNSNumber\":1.23,\"aInt\":-1,\"aInt8\":-1,\"aInt16\":-1,\"aInt32\":-1,\"aInt64\":-1,\"aUInt\":1,\"aUInt8\":1,\"aUInt16\":1,\"aUInt32\":1,\"aUInt64\":1,\"bBool\":false,\"bFloat\":1.23,\"bDouble\":1.23,\"bNSNumber\":1.23,\"bInt\":-1,\"bInt8\":-1,\"bInt16\":-1,\"bInt32\":-1,\"bInt64\":-1,\"bUInt\":1,\"bUInt8\":1,\"bUInt16\":1,\"bUInt32\":1,\"bUInt64\":1}"
        let model = G.deserialize(from: jsonString)!
        XCTAssertTrue(model.aBool == "false")
        XCTAssertTrue(model.aFloat == "1.23")
        XCTAssertTrue(model.aDouble == "1.23")
        XCTAssertTrue(model.aNSNumber == "1.23")
        XCTAssertTrue(model.aInt == "-1")
        XCTAssertTrue(model.aInt8 == "-1")
        XCTAssertTrue(model.aInt16 == "-1")
        XCTAssertTrue(model.aInt32 == "-1")
        XCTAssertTrue(model.aInt64 == "-1")
        XCTAssertTrue(model.aUInt == "1")
        XCTAssertTrue(model.aUInt8 == "1")
        XCTAssertTrue(model.aUInt16 == "1")
        XCTAssertTrue(model.aUInt32 == "1")
        XCTAssertTrue(model.aUInt64 == "1")
        XCTAssertTrue(model.bBool == "false")
        XCTAssertTrue(model.bFloat == "1.23")
        XCTAssertTrue(model.bDouble == "1.23")
        XCTAssertTrue(model.bNSNumber == "1.23")
        XCTAssertTrue(model.bInt == "-1")
        XCTAssertTrue(model.bInt8 == "-1")
        XCTAssertTrue(model.bInt16 == "-1")
        XCTAssertTrue(model.bInt32 == "-1")
        XCTAssertTrue(model.bInt64 == "-1")
        XCTAssertTrue(model.bUInt == "1")
        XCTAssertTrue(model.bUInt8 == "1")
        XCTAssertTrue(model.bUInt16 == "1")
        XCTAssertTrue(model.bUInt32 == "1")
        XCTAssertTrue(model.bUInt64 == "1")
    }

    func testTypeAdaptationNSNull2Others() {
        class H: HandyJSON {
            // from corresponding type
            var aBool: Bool?
            var aFloat: Float?
            var aDouble: Double?
            var aNSNumber: NSNumber?
            var aInt: Int?
            var aInt8: Int8?
            var aInt16: Int16?
            var aInt32: Int32?
            var aInt64: Int64?
            var aUInt: UInt?
            var aUInt8: UInt8?
            var aUInt16: UInt16?
            var aUInt32: UInt32?
            var aUInt64: UInt64?

            required init() {}
        }

        let jsonString = "{\"aBool\":null,\"aFloat\":null,\"aDouble\":null,\"aNSNumber\":null,\"aInt\":null,\"aInt8\":null,\"aInt16\":null,\"aInt32\":null,\"aInt64\":null,\"aUInt\":null,\"aUInt8\":null,\"aUInt16\":null,\"aUInt32\":null,\"aUInt64\":null}"
        let model = H.deserialize(from: jsonString)!
        XCTAssertNil(model.aBool)
        XCTAssertNil(model.aFloat)
        XCTAssertNil(model.aDouble)
        XCTAssertNil(model.aNSNumber)
        XCTAssertNil(model.aInt)
        XCTAssertNil(model.aInt8)
        XCTAssertNil(model.aInt16)
        XCTAssertNil(model.aInt32)
        XCTAssertNil(model.aInt64)
        XCTAssertNil(model.aUInt)
        XCTAssertNil(model.aUInt8)
        XCTAssertNil(model.aUInt16)
        XCTAssertNil(model.aUInt32)
        XCTAssertNil(model.aUInt64)
    }

    func testForIssue76(){
        // https://github.com/alibaba/HandyJSON/issues/76
        struct A :HandyJSON{
            var p = Array<P>()
        }
        struct P:HandyJSON{
            var name = "dddd"
        }

        let a = A(p:[P(), P()])

        let jsonstr = a.toJSONString()
        XCTAssert(jsonstr == "{\"p\":[{\"name\":\"dddd\"},{\"name\":\"dddd\"}]}")
    }

    func testDidFinishMappingForClass() {
        class A: HandyJSON {
            var name: String?
            var upperName: String?
            required init() {}

            func didFinishMapping() {
                upperName = name?.uppercased()
            }
        }

        let jsonString = "{\"name\":\"HandyJson\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssertEqual(a.upperName, "HANDYJSON")
    }

    func testDidFinishMappingForStruct() {
        struct A: HandyJSON {
            var name: String?
            var upperName: String?

            mutating func didFinishMapping() {
                upperName = name?.uppercased()
            }
        }

        let jsonString = "{\"name\":\"HandyJson\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssertEqual(a.upperName, "HANDYJSON")
    }
}
