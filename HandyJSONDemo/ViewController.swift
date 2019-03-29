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

//  Created by zhouzhuo on 7/11/16.

import UIKit
import HandyJSON

enum Grade: Int, HandyJSONEnum {
    case One = 1
    case Two = 2
    case Three = 3
}

enum Gender: String, HandyJSONEnum {
    case Male = "Male"
    case Female = "Female"
}

struct Teacher: HandyJSON {
    var name: String?
    var age: Int?
    var height: Int?
    var gender: Gender?
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
    var grade: Grade = .One
    var height: Int?
    var gender: Gender?
    var className: String?
    var teacher: Teacher = Teacher()
    var subjects: [Subject]?
    var seat: String?

    required init() {}
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("\n--------------------- serilization ---------------------\n")
        self.serialization()
        print("\n--------------------- deserilization ---------------------\n")
        self.deserialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func serialization() {
        let student = Student()
        student.name = "Jack"
        student.gender = .Female
        student.subjects = [Subject(name: "Math", id: 1, credit: 23, lessonPeriod: 64), Subject(name: "English", id: 2, credit: 12, lessonPeriod: 32)]

        print(student.toJSON()!)
        print(student.toJSONString()!)
        print(student.toJSONString(prettyPrint: true)!)

        print([student].toJSON())
        print([student].toJSONString()!)
        print([student].toJSONString(prettyPrint: true)!)
    }

    func deserialization() {
        let jsonString = "{\"id\":\"77544\",\"json_name\":\"Tom Li\",\"age\":18,\"grade\":2,\"height\":180,\"gender\":\"Female\",\"className\":\"A\",\"teacher\":{\"name\":\"Lucy He\",\"age\":28,\"height\":172,\"gender\":\"Female\",},\"subjects\":[{\"name\":\"math\",\"id\":18000324583,\"credit\":4,\"lessonPeriod\":48},{\"name\":\"computer\",\"id\":18000324584,\"credit\":8,\"lessonPeriod\":64}],\"seat\":\"4-3-23\"}"

        if let student = Student.deserialize(from: jsonString) {
            print(student.toJSON()!)
        }

        let arrayJSONString = "[{\"id\":\"77544\",\"json_name\":\"Tom Li\",\"age\":18,\"grade\":2,\"height\":180,\"gender\":\"Female\",\"className\":\"A\",\"teacher\":{\"name\":\"Lucy He\",\"age\":28,\"height\":172,\"gender\":\"Female\",},\"subjects\":[{\"name\":\"math\",\"id\":18000324583,\"credit\":4,\"lessonPeriod\":48},{\"name\":\"computer\",\"id\":18000324584,\"credit\":8,\"lessonPeriod\":64}],\"seat\":\"4-3-23\"}]"
        if let students = [Student].deserialize(from: arrayJSONString) {
            print(students.count)
            print(students[0]!.toJSON()!)
        }
    }
}
