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
//  CustomMappingTest.swift
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

        struct A: HandyJSON {
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

        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":\"180\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "json_12345")
        XCTAssert(a.height == 180)
    }

    func testMultipleNamesMapToOneProperty() {

        class A: HandyJSON {
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

        var jsonString = "{\"var1_v1\":\"var1_value\",\"var2_v1\":\"var2_value\",\"var3_v1\":\"var3_value\"}"
        var a = A.deserialize(from: jsonString)!
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
        a = A.deserialize(from: jsonString)!
        XCTAssert(a.var1 == "var1_value")
        XCTAssert(a.var2 == "var2_value")
        XCTAssert(a.var3 == nil)

        jsonString = "{\"var1\":\"var1_value\",\"var2\":\"var2_value\",\"var3\":\"var3_value\"}"
        a = A.deserialize(from: jsonString)!
        XCTAssert(a.var1 == nil)
        XCTAssert(a.var2 == nil)
        XCTAssert(a.var3 == nil)
    }

    func testClassMapping() {

        class A: HandyJSON {
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

        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":18000}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "json_12345")
        XCTAssert(a.height == 180)
    }

    func testExlucdePropertyForClass() {
        struct NotHandyJSON {
            var empty: String?
        }
        class A: HandyJSON {
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
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.name == nil)
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }

    func testExlucdePropertyForStruct() {
        class NotHandyJSON {
            var empty: String?
        }
        struct A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?
            var notHandyJSONProperty: NotHandyJSON?

            mutating func mapping(mapper: HelpingMapper) {
                mapper >>> self.notHandyJSONProperty
                mapper >>> name
            }
        }
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180, \"notHandyJSONProperty\":\"value\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.name == nil)
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }
    
    func testAfterMappingForClass() {
        class A: HandyJSON {
            var name: String?
            var upperName: String?
            required init() {}
            
            func afterMap() {
                upperName = name?.uppercased()
            }
        }
        
        let jsonString = "{\"name\":\"HandyJson\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssertEqual(a.upperName, "HANDYJSON")
    }
    
    func testAfterMappingForStruct() {
        struct A: HandyJSON {
            var name: String?
            var upperName: String?
            
            mutating func afterMap() {
                upperName = name?.uppercased()
            }
        }
        
        let jsonString = "{\"name\":\"HandyJson\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssertEqual(a.upperName, "HANDYJSON")
    }
}
