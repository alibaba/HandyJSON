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

class InvalidStateHandlingTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDeserializeFromInvalidJSONString() {
        class A: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}
        }

        let jsonString = "{\"name\"\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = A.deserialize(from: jsonString)
        XCTAssertNil(a)
        let b = [A].deserialize(from: jsonString)
        XCTAssertNil(b)
    }

    func testDeserializeByIncorrectDesignatedPath() {
        class B: HandyJSON {
            var name: String?
            var id: String?
            var height: Int?

            required init() {}
        }

        let jsonString = "{\"name\":\"Bob\",\"id\":\"12345\",\"height\":180}"
        let a = B.deserialize(from: jsonString, designatedPath: "wrong")
        XCTAssertNil(a)
        let b = B.deserialize(from: jsonString, designatedPath: "name.name")
        XCTAssertNil(b)
    }
}
