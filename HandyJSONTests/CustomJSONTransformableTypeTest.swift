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
//  CustomJSONTransformableType.swift
//  HandyJSON
//
//  Created by Haizhen Lee on 1/15/17.
//

import Foundation
import XCTest
import HandyJSON

/// 可以通过实现 `JSONTransformable` 来增加对自定义类型的支持. 
/// 但是一个问题时,对于 URL, Date 等这些类型的转换如果每次的序列化有不同的参数需求.
/// 这样的实现方法不方便控制. 虽然对于全局的控制可以通过静态变量, 如下的 `shouldEncodeURLString` 来实现.
extension URL: JSONTransformable{
    static var shouldEncodeURLString = false
    public static func transform(from object:NSObject) -> URL?{
        guard let URLString = object as? NSString else { return nil }
        
        if !shouldEncodeURLString {
            return URL(string: URLString as String)
        }
        
        guard let escapedURLString = URLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        return URL(string: escapedURLString)
    }
    
    public func toJSONValue() -> Any?{
        return self.absoluteString
    }
}

class CustomJSONTransformableType: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testURLProperty() {
        struct A: HandyJSON {
            var url: URL?
            
            mutating func mapping(mapper: HelpingMapper) {
            }
        }
        let githubSite = URL(string: "https://github.com")
        let jsonString = "{\"url\":\"\(githubSite!.absoluteString)\"}"
        let a = A.deserialize(from: jsonString)!
        XCTAssert(a.url == githubSite)
    }
}
