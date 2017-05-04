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

//  Created by zhouzhuo on 8/8/16.
//

import XCTest
import HandyJSON

class NestObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    enum Gender: String, HandyJSONEnum {
        case Male = "Male"
        case Female = "Female"
    }

    class Teacher: HandyJSON {
        var name: String?
        var age: Int?
        var height: Int?
        var gender: Gender?

        required init() {}
    }

    struct Subject: HandyJSON {
        var name: String?
        var id: Int64?
        var credit: Int?
        var lessonPeriod: Int?
    }

    class Student: HandyJSON {
        var id: String?
        var name: String?
        var age: Int?
        var height: Int?
        var gender: Gender?
        var className: String?
        var teacher: Teacher?
        var subject: [Subject]?
        var seat: String?

        required init() {}
    }

    func testNormalNestObject() {
        /**
         {
            "id": "77544",
            "name": "Tom Li",
            "age": 18,
            "height": 180,
            "gender": "Male",
            "className": "A",
            "teacher": {
                "name": "Lucy He",
                "age": 28,
                "height": 172,
                "gender": "Female",
            },
            "subject": [
                {
                    "name": "math",
                    "id": 18000324583,
                    "credit": 4,
                    "lessonPeriod": 48
                },
                {
                    "name": "computer",
                    "id": 18000324584,
                    "credit": 8,
                    "lessonPeriod": 64
                }
            ],
            "seat": "4-3-23"
         }
        **/
        let jsonString = "{\"id\":\"77544\",\"name\":\"Tom Li\",\"age\":18,\"height\":180,\"gender\":\"Male\",\"className\":\"A\",\"teacher\":{\"name\":\"Lucy He\",\"age\":28,\"height\":172,\"gender\":\"Female\",},\"subject\":[{\"name\":\"math\",\"id\":18000324583,\"credit\":4,\"lessonPeriod\":48},{\"name\":\"computer\",\"id\":18000324584,\"credit\":8,\"lessonPeriod\":64}],\"seat\":\"4-3-23\"}"
        let student = Student.deserialize(from: jsonString)!
        XCTAssert(student.id == "77544")
        XCTAssert(student.name == "Tom Li")
        XCTAssert(student.age == 18)
        XCTAssert(student.height == 180)
        XCTAssert(student.gender == .Male)
        XCTAssert(student.className == "A")
        XCTAssert(student.teacher?.name == "Lucy He")
        XCTAssert(student.teacher?.age == 28)
        XCTAssert(student.teacher?.height == 172)
        XCTAssert(student.teacher?.gender == .Female)
        XCTAssert(student.subject?.first?.name == "math")
        XCTAssert(student.subject?.first?.id == 18000324583)
        XCTAssert(student.subject?.first?.credit == 4)
        XCTAssert(student.subject?.first?.lessonPeriod == 48)
        XCTAssert(student.subject?.last?.name == "computer")
        XCTAssert(student.subject?.last?.id == 18000324584)
        XCTAssert(student.subject?.last?.credit == 8)
        XCTAssert(student.subject?.last?.lessonPeriod == 64)
        XCTAssert(student.seat == "4-3-23")
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
        XCTAssert(jsonstr?.countOf(char: "d") == 8)
        XCTAssert(jsonstr == "{\"p\":[{\"name\":\"dddd\"},{\"name\":\"dddd\"}]}")

    }

}

extension String{
    func countOf(char: Character) -> Int{
        return characters.filter{ $0 == char }.count
    }
}
