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

//  Created by cijianzy(cijainzy@gmail.com) on 17/9/16.
//

import Foundation
import XCTest
import HandyJSON

class serializeToJSONTests: XCTestCase {

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

    func testForBasicTypeValue() {
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 1), "1")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: "HandyJSON"), "\"HandyJSON\"")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 1.2), "1.2")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: 10), "10")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: true), "true")

        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }
        stringCompareHelper(JSONSerializer.serializeToJSON(object: Week.Friday), "\"Friday\"")
    }

    func testForIntArray() {
        let array = [1,2,3,4]
        let json = JSONSerializer.serializeToJSON(object: array)
        stringCompareHelper(json, "[1,2,3,4]")
    }

    func testForStringArray() {
        let array = ["Monday", "Tuesday", "Wednesday"]
        let json = JSONSerializer.serializeToJSON(object: array)
        stringCompareHelper(json, "[\"Monday\",\"Tuesday\",\"Wednesday\"]")
    }

    func testForNSDictionary() {
        let dic: NSDictionary = NSDictionary.init(dictionary: ["Today": "Monday"])
        let json = JSONSerializer.serializeToJSON(object: dic)
        stringCompareHelper(json, "{\"Today\":\"Monday\"}")
    }

    func testForClass() {
        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        class ClassA {
            let month = 4
            let day = 18
            let year = 1994
            let today = Week.Monday
            let name = "cijian"
            let time = ["Morning","Afternoon","Night"]
            let dic = ["today": "Monday", "tomorrow": "Tuesday"]
        }

        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), "{\"name\":\"cijian\",\"day\":18,\"year\":1994,\"today\":\"Monday\",\"month\":4,\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"},\"time\":[\"Morning\",\"Afternoon\",\"Night\"]}")
    }

    func testForOptionalBasicValueType() {
        var optionalInt: Int?
        var optionalString: String?
        var optionalBool: Bool?
        var optionalDouble: Double?
        var optionalNil: String?

        optionalInt = 10
        optionalString = "hello"
        optionalBool = false
        optionalDouble = 1.23
        optionalNil = nil

        stringCompareHelper(JSONSerializer.serializeToJSON(object: optionalInt),"10")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optionalString),"\"hello\"")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optionalBool),"false")
        stringCompareHelper(JSONSerializer.serializeToJSON(object: optionalDouble),"1.23")
        XCTAssertNil(JSONSerializer.serializeToJSON(object: optionalNil))
    }

    func testForOptionalInArray() {
        var optionalvalue: Int?
        var array: [Int?] = []
        optionalvalue = 1
        array.append(optionalvalue)
        optionalvalue = 10
        array.append(optionalvalue)
        optionalvalue = 50
        array.append(optionalvalue)
        stringCompareHelper(JSONSerializer.serializeToJSON(object: array),"[1,10,50]")
    }

    func testForClassWithOptinalValue() {
        class ClassA {
            var value: Int? = 2
        }
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()),"{\"value\":2}")
    }

    func testForStringBaseEnum() {
        enum Week: String {
            case Monday
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }

        class ClassA {

            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }

        let expected = "{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}"

        let json = JSONSerializer.serializeToJSON(object: ClassA())

        stringCompareHelper(json, expected)
    }

    func testForIntBaseEnum() {
        enum Week: Int {
            case Monday = 1000
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }
        class ClassA {

            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }
        let expected = "{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), expected)
    }

    func testForStringBaseEnumWithCustomValue() {
        enum Week: String {
            case Monday = "hello"
            case Tuesday
            case Wednesday
            case Thursday
            case Friday
            case Saturday
            case Sunday
        }
        class ClassA {
            var today = Week.Monday
            var tomorrow = Week.Tuesday
        }
        let expected = "{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), expected)
    }

    func testForClassWithDictionaryProperty() {
        class ClassA {
            var dic = ["today": "Monday", "tomorrow": "Tuesday"]
        }

        let expected = "{\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), expected)
    }

    func testForCompositionClass() {
        class A {
            var a: String?
            var b: Int?
            var c: [Double]?
            var d: [String: String]?

            init() {
                self.a = "hello"
                self.b = 111
                self.c = [1, 2.1, 3, 4.0]
                self.d = ["name1": "value1", "name2": "value2"]
            }
        }

        class B {
            var a: A?
            var b: A?

            init() {
                self.a = A()
                self.b = A()
            }
        }

        let expected = "{\"b\":{\"b\":111,\"a\":\"hello\",\"d\":{\"name1\":\"value1\",\"name2\":\"value2\"},\"c\":[1.0,2.1,3.0,4.0]},\"a\":{\"b\":111,\"a\":\"hello\",\"d\":{\"name1\":\"value1\",\"name2\":\"value2\"},\"c\":[1.0,2.1,3.0,4.0]}}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: B()), expected)
        print(JSONSerializer.serializeToJSON(object: B(), prettify: true)!)
    }

    func testForCompositionStruct() {
        struct A {
            var a: String?
            var b: Int?
            var c: [Double]?
            var d: [String: String]?

            init() {
                self.a = "hello"
                self.b = 111
                self.c = [1, 2.1, 3, 4.0]
                self.d = ["name1": "value1", "name2": "value2"]
            }
        }

        struct B {
            var a: A?
            var b: A?

            init() {
                self.a = A()
                self.b = A()
            }
        }

        let expected = "{\"b\":{\"b\":111,\"a\":\"hello\",\"d\":{\"name1\":\"value1\",\"name2\":\"value2\"},\"c\":[1.0,2.1,3.0,4.0]},\"a\":{\"b\":111,\"a\":\"hello\",\"d\":{\"name1\":\"value1\",\"name2\":\"value2\"},\"c\":[1.0,2.1,3.0,4.0]}}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: B()), expected)
        print(JSONSerializer.serializeToJSON(object: B(), prettify: true)!)
    }

    func testForClassWithComplexDictionaryProperty() {
        class ClassB {
            var value: Int?

            init(value: Int) {
                self.value = value
            }
        }

        class ClassA {
            var dic = ["today": ClassB(value: 1), "tomorrow": ClassB(value: 2)]
        }

        let expected = "{\"dic\":{\"tomorrow\":{\"value\":2},\"today\":{\"value\":1}}}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), expected)

    }

    func testForClassDefinedInsideBlock() {
        _ = {
            class ClassA {
                var dic = ["today": "Monday", "tomorrow": "Tuesday"]
            }

            let expected = "{\"dic\":{\"tomorrow\":\"Tuesday\",\"today\":\"Monday\"}}"
            stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), expected)
        }()
    }

    func testForSet() {
        let set: Set = [1, 2, 3, 4]
        stringCompareHelper(JSONSerializer.serializeToJSON(object: set),  "[2,3,1,4]")
    }

    func testForClassWithSetProperty() {
        class ClassA {
            let set: Set = [1, 2, 3, 4]
        }

        stringCompareHelper(JSONSerializer.serializeToJSON(object: ClassA()), "{\"set\":[2,3,1,4]}")
    }

    func testForInheritedClass() {
        class A {
            var a: Int?
            var b: String?

            init() {
                self.a = 1
                self.b = "hello"
            }
        }

        class B: A {
            var c: Double?
            var d: [Bool]?

            override init() {
                super.init()
                self.c = 123.45
                self.d = [false, true, false]
            }
        }

        let expected = "{\"b\":\"hello\",\"a\":1,\"d\":[false,true,false],\"c\":123.45}"
        stringCompareHelper(JSONSerializer.serializeToJSON(object: B()), expected)
    }
}
