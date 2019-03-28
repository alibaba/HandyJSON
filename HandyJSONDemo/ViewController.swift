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

class Model: HandyJSON {
    var name: String?
    var id: Int64?

    required init() {
    }
}

class Test: HandyJSON {
    var name: String?
    var id: Int64?
    required init() {}
}

class Result<T: HandyJSON>: Test {
    var code: String?
    var data: T?
    var data2: T?
    var data3: Test?
    var data4: T?

    required init() {
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("\n--------------------- serilization ---------------------\n")
        // self.serialization()
        print("\n--------------------- deserilization ---------------------\n")
        self.deserialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func serialization() {
//        let model = Model()
//        model.name = "xyc"
//        model.id = 1234
//        let result = Result<Model>()
//        result.code = "success"
//        result.data = model
//
//        let json = result.toJSONString() ?? ""
//        print("\(json)")
//    }

    func deserialization() {
        let model = Model()
        model.name = "item"
        model.id = 1001
        let result = Result<Model>()
//        result.code = "success"
        result.data = model
//        result.data2 = model

        let json = result.toJSONString() ?? ""
//        let json = """
//        {
//            "name": "hehe"
//        }
//        """
        print("\(json)")

        if let fromJson = Result<Model>.deserialize(from: json) {
            print(fromJson.data?.id)
        }
    }
}
