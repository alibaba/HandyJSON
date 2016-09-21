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

enum Gender: String, HandyJSON {
    case Male = "Male"
    case Female = "Female"

    init() {
        self = .Male
    }
}

class Teacher: HandyJSON {
    var name: String?
    var age: Int?
    var height: Int?
    var gender: Gender?

    required init() {}

    func mapping(mapper: Mapper) {
        mapper.specify(&gender) {
            return Gender(rawValue: $0)
        }
    }
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

    func mapping(mapper: Mapper) {
        mapper.specify(&gender) {
            return Gender(rawValue: $0)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.demo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func demo() {
        let jsonString = "{\"id\":\"77544\",\"name\":\"Tom Li\",\"age\":18,\"height\":180,\"gender\":\"Male\",\"className\":\"A\",\"teacher\":{\"name\":\"Lucy He\",\"age\":28,\"height\":172,\"gender\":\"Female\",},\"subject\":[{\"name\":\"math\",\"id\":18000324583,\"credit\":4,\"lessonPeriod\":48},{\"name\":\"computer\",\"id\":18000324584,\"credit\":8,\"lessonPeriod\":64}],\"seat\":\"4-3-23\"}"

        if let student = JSONDeserializer<Student>.deserializeFrom(jsonString) {
            print(student)
            print(student.id)
            print(student.name)
            print(student.age)
            print(student.height)
            print(student.gender)
            print(student.className)
            print(student.teacher?.name)
            print(student.teacher?.age)
            print(student.teacher?.height)
            print(student.teacher?.gender)
            print(student.subject?.first?.name)
            print(student.subject?.first?.id)
            print(student.subject?.first?.credit)
            print(student.subject?.first?.lessonPeriod)
            print(student.subject?.last?.name)
            print(student.subject?.last?.id)
            print(student.subject?.last?.credit)
            print(student.subject?.last?.lessonPeriod)
            print(student.seat)
        }
    }
}
