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

enum Biz: String, HandyJSONEnum {
    case social = "social"
    case education = "education"
    case news = "news"
}

protocol Data: HandyJSON {}

class Common: Data {
    var id: Int?
    required init() {}
}

class Model: Common {
    var aInt: Int?
    var aStr: String?
    required init() {}
}

class Result<T: Data>: HandyJSON {
    var code: Int?
    var biz: Biz?
    var data: T?
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
        let model = Model()
        model.id = 1
        model.aInt = 100
        model.aStr = "string data"
        let result = Result<Model>()
        result.biz = Biz.social
        result.code = 200
        result.data = model
        print(result.toJSON()!)
        print(result.toJSONString()!)
        print(result.toJSONString(prettyPrint: true)!)

        print([result].toJSON())
        print([result].toJSONString()!)
        print([result].toJSONString(prettyPrint: true)!)
    }

    func deserialization() {
        let jsonString = "{\"data\":{\"aInt\":100,\"aStr\":\"string data\",\"id\":1},\"code\":200,\"biz\":\"social\"}"
        if let result = Result<Model>.deserialize(from: jsonString) {
            print(result.data?.id ?? 0)
            print(result.code ?? "")
            print(result.biz ?? "")
            print(result.data?.aInt ?? 0)
            print(result.data?.aStr ?? "")
        }
    }
}
