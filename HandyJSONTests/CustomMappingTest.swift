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
                mapper.specify(property: &name, name: "json_name")

                // specify converting method
                mapper.specify(property: &id, converter: { rawValue -> String in
                    return "json_" + rawValue
                })

                // specify both
                mapper.specify(property: &height, name: "json_height", converter: { rawValue -> Int in
                    print("classMapping: ", rawValue)
                    return Int(rawValue) ?? 0
                })
            }
        }

        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":180}"
        let a = JSONDeserializer<A>.deserializeFrom(json: jsonString)!
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
                    print("classMapping: ", rawValue)
                    return Int(rawValue)
                })
            }
        }

        let jsonString = "{\"json_name\":\"Bob\",\"id\":\"12345\",\"json_height\":180}"
        let a = JSONDeserializer<A>.deserializeFrom(json: jsonString)!
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
                mapper.exclude(property: &notHandyJSONProperty)
            }
        }
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = JSONDeserializer<A>.deserializeFrom(json: jsonString)!
        XCTAssert(a.name == "Bob")
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
                mapper.exclude(property: &notHandyJSONProperty)
            }
        }
        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180, \"notHandyJSONProperty\":\"value\"}"
        let a = JSONDeserializer<A>.deserializeFrom(json: jsonString)!
        XCTAssert(a.name == "Bob")
        XCTAssert(a.id == "12345")
        XCTAssert(a.height == 180)
    }
}
