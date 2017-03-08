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

    func testClassMapping() {

        class A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}

            func mapping(mapper: HelpingMapper) {
                // specify json field name
                mapper.specify(property: &name, name: "json_name")

                // specify converting method
                mapper.specify(property: &id, converter: { rawValue -> String in
                    return "json_" + rawValue
                })

                // specify both
                mapper.specify(property: &height, name: "json_height", converter: { rawValue -> Int? in
                    return Int(rawValue)
                })
            }
        }

        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":180}"
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
}
