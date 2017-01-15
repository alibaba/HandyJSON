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

//  Created by zhouzhuo on 8/9/16.
//

import XCTest
import HandyJSON

class AllBaseTypePropertyObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOptionalStruct() {
        /**
         {
         "aInt": -12345678,
         "aInt8": -8,
         "aInt16": -16,
         "aInt32": -32,
         "aInt64": -64,
         "aUInt": 12345678,
         "aUInt8": 8,
         "aUInt16": 16,
         "aUInt32": 32,
         "aUInt64": 64,
         "aBool": true,
         "aFloat": 12.34,
         "aDouble": 12.34,
         "aString": "hello wolrd!"
         }

         **/
        struct AStruct : HandyJSON {
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
            var aBool: Bool?
            var aFloat: Float?
            var aDouble: Double?
            var aString: String?
        }

        let jsonString = "{\"aInt\":-12345678,\"aInt8\":-8,\"aInt16\":-16,\"aInt32\":-32,\"aInt64\":-64,\"aUInt\":12345678,\"aUInt8\":8,\"aUInt16\":16,\"aUInt32\":32,\"aUInt64\":64,\"aBool\":true,\"aFloat\":12.34,\"aDouble\":12.34,\"aString\":\"hello world!\"}"

        let aStruct = JSONDeserializer<AStruct>.deserializeFrom(json: jsonString)!
        XCTAssert(aStruct.aInt == -12345678)
        XCTAssert(aStruct.aInt8 == -8)
        XCTAssert(aStruct.aInt16 == -16)
        XCTAssert(aStruct.aInt32 == -32)
        XCTAssert(aStruct.aInt64 == -64)
        XCTAssert(aStruct.aUInt == 12345678)
        XCTAssert(aStruct.aUInt8 == 8)
        XCTAssert(aStruct.aUInt16 == 16)
        XCTAssert(aStruct.aUInt32 == 32)
        XCTAssert(aStruct.aUInt64 == 64)
        XCTAssert(aStruct.aBool == true)
        XCTAssert(aStruct.aFloat == 12.34)
        XCTAssert(aStruct.aDouble == 12.34)
        XCTAssert(aStruct.aString == "hello world!")
    }

    func testOptionalClass() {
        /**
         {
         "aInt": -12345678,
         "aInt8": -8,
         "aInt16": -16,
         "aInt32": -32,
         "aInt64": -64,
         "aUInt": 12345678,
         "aUInt8": 8,
         "aUInt16": 16,
         "aUInt32": 32,
         "aUInt64": 64,
         "aBool": true,
         "aFloat": 12.34,
         "aDouble": 12.34,
         "aString": "hello wolrd!"
         }

         **/
        class AClass : HandyJSON {
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
            var aBool: Bool?
            var aFloat: Float?
            var aDouble: Double?
            var aString: String?

            required init() {}
        }

        let jsonString = "{\"aInt\":-12345678,\"aInt8\":-8,\"aInt16\":-16,\"aInt32\":-32,\"aInt64\":-64,\"aUInt\":12345678,\"aUInt8\":8,\"aUInt16\":16,\"aUInt32\":32,\"aUInt64\":64,\"aBool\":true,\"aFloat\":12.34,\"aDouble\":12.34,\"aString\":\"hello world!\"}"

        let aClass = JSONDeserializer<AClass>.deserializeFrom(json: jsonString)!
        XCTAssert(aClass.aInt == -12345678)
        XCTAssert(aClass.aInt8 == -8)
        XCTAssert(aClass.aInt16 == -16)
        XCTAssert(aClass.aInt32 == -32)
        XCTAssert(aClass.aInt64 == -64)
        XCTAssert(aClass.aUInt == 12345678)
        XCTAssert(aClass.aUInt8 == 8)
        XCTAssert(aClass.aUInt16 == 16)
        XCTAssert(aClass.aUInt32 == 32)
        XCTAssert(aClass.aUInt64 == 64)
        XCTAssert(aClass.aBool == true)
        XCTAssert(aClass.aFloat == 12.34)
        XCTAssert(aClass.aDouble == 12.34)
        XCTAssert(aClass.aString == "hello world!")
    }

    func testClassImplicitlyUnwrapped() {
        /**
         {
         "aInt": -12345678,
         "aInt8": -8,
         "aInt16": -16,
         "aInt32": -32,
         "aInt64": -64,
         "aUInt": 12345678,
         "aUInt8": 8,
         "aUInt16": 16,
         "aUInt32": 32,
         "aUInt64": 64,
         "aBool": true,
         "aFloat": 12.34,
         "aDouble": 12.34,
         "aString": "hello wolrd!"
         }

         **/
        class AClassImplicitlyUnwrapped : HandyJSON {
            var aInt: Int!
            var aInt8: Int8!
            var aInt16: Int16!
            var aInt32: Int32!
            var aInt64: Int64!
            var aUInt: UInt!
            var aUInt8: UInt8!
            var aUInt16: UInt16!
            var aUInt32: UInt32!
            var aUInt64: UInt64!
            var aBool: Bool!
            var aFloat: Float!
            var aDouble: Double!
            var aString: String!

            required init() {}
        }

        let jsonString = "{\"aInt\":-12345678,\"aInt8\":-8,\"aInt16\":-16,\"aInt32\":-32,\"aInt64\":-64,\"aUInt\":12345678,\"aUInt8\":8,\"aUInt16\":16,\"aUInt32\":32,\"aUInt64\":64,\"aBool\":true,\"aFloat\":12.34,\"aDouble\":12.34,\"aString\":\"hello world!\"}"

        let aClass = JSONDeserializer<AClassImplicitlyUnwrapped>.deserializeFrom(json: jsonString)!
        XCTAssert(aClass.aInt == -12345678)
        XCTAssert(aClass.aInt8 == -8)
        XCTAssert(aClass.aInt16 == -16)
        XCTAssert(aClass.aInt32 == -32)
        XCTAssert(aClass.aInt64 == -64)
        XCTAssert(aClass.aUInt == 12345678)
        XCTAssert(aClass.aUInt8 == 8)
        XCTAssert(aClass.aUInt16 == 16)
        XCTAssert(aClass.aUInt32 == 32)
        XCTAssert(aClass.aUInt64 == 64)
        XCTAssert(aClass.aBool == true)
        XCTAssert(aClass.aFloat == 12.34)
        XCTAssert(aClass.aDouble == 12.34)
        XCTAssert(aClass.aString == "hello world!")
    }

    /**
     {
        "aEnum1": 1,
        "bEnum1": 2,
        "cEnum1": 3,
        "aEnum2": "a",
        "bEnum2": "b",
        "cEnum2": "c",
        "aEnum3": 1.1,
        "bEnum3": 2.2,
        "cEnum3": 3.3
        "aEnumArr": [1, 2, 3],
        "bEnumArr": ["a", "b", "c"],
        "cEnumArr": [1.1, 2.2, 3.3]
     }
     */
    func testEnumTypeOfCommonRawType() {
        enum AEnum: Int, HandyJSONEnum {
            case A = 1, B = 2, C = 3
        }

        enum BEnum: String, HandyJSONEnum {
            case A = "a", B = "b", C = "c"
        }

        enum CEnum: Double, HandyJSONEnum {
            case A = 1.1, B = 2.2, C = 3.3
        }

        struct TestEnum: HandyJSON {
            var aEnum1: AEnum?
            var bEnum1: BEnum?
            var cEnum1: CEnum?

            var aEnum2: AEnum = .A
            var bEnum2: BEnum = .A
            var cEnum2: CEnum = .A

            var aEnum3: AEnum!
            var bEnum3: BEnum!
            var cEnum3: CEnum!

            var aEnumArr: [AEnum]?
            var bEnumArr: [BEnum]!
            var cEnumArr: [CEnum] = []
        }

        let jsonString = "{\"aEnum1\":1,\"bEnum1\":2,\"cEnum1\":3,\"aEnum2\":\"a\",\"bEnum2\":\"b\",\"cEnum2\":\"c\",\"aEnum3\":1.1,\"bEnum3\":2.2,\"cEnum3\":3.3,\"aEnumArr\":[1,2,3],\"bEnumArr\":[\"a\",\"b\",\"c\"],\"cEnumArr\":[1.1,2.2,3.3]}"
        let model = JSONDeserializer<TestEnum>.deserializeFrom(json: jsonString)!

        XCTAssert(model.aEnum1 == .A)
        XCTAssert(model.bEnum2 == .B)
        XCTAssert(model.cEnum3 == .C)

        XCTAssert(model.aEnumArr?[0] == .A)
        XCTAssert(model.bEnumArr[1] == .B)
        XCTAssert(model.cEnumArr[2] == .C)
    }
}
