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

class NestTypesTest: XCTestCase {

    let jsonString = "{\"classMemberOptional\":{\"enumString\":\"Default\",\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5]},\"lowerLayerModel\":{\"classMemberOptional\":{\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5]},\"structMember\":{\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"]},\"classMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMemberOptional\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"arrayEnumInt\":[],\"nsArrayOptional\":[\"one\",\"two\",\"three\"]},\"classMemberImplicitlyUnwrapped\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"enumMember\":\"Default\",\"structMemberImplicitlyUnwrapped\":{\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"]}},\"structMember\":{\"enumString\":\"Default\",\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"dictString\":{}},\"classMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMemberOptional\":{\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"nsArrayOptional\":[\"one\",\"two\",\"three\"]},\"classMemberImplicitlyUnwrapped\":{\"int\":11,\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5]},\"structMemberImplicitlyUnwrapped\":{\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"]},\"lowerLayerModelOptional\":{\"classMemberOptional\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"arrayNSNumber\":[],\"string\":\"\"},\"classMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayInt\":[],\"bool\":true,\"dictDouble\":{},\"enumInt\":0,\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"arrayNSNumber\":[],\"string\":\"\",\"dictInt\":{},\"arrayBool\":[],\"nsArray\":[],\"anyObject\":true,\"arrayString\":[],\"dictFloat\":{},\"arrayNSString\":[],\"arrayDouble\":[],\"arrayFloat\":[],\"enumDouble\":0,\"arrayAnyObject\":[],\"float\":0,\"nsNumber\":0,\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMemberOptional\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"dictString\":{}},\"classMemberImplicitlyUnwrapped\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"enumMember\":\"Default\",\"structMemberImplicitlyUnwrapped\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"arrayNSNumber\":[],\"string\":\"\",\"dictInt\":{},\"arrayBool\":[],\"nsArray\":[],\"anyObject\":true,\"arrayString\":[],\"dictFloat\":{},\"arrayNSString\":[],\"arrayDouble\":[],\"arrayFloat\":[],\"enumDouble\":0,\"arrayAnyObject\":[],\"float\":0,\"nsNumber\":0,\"dictString\":{}}},\"lowerLayerModelImplicitlyUnwrapped\":{\"classMemberOptional\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayInt\":[],\"bool\":true,\"dictDouble\":{},\"enumInt\":0,\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"arrayNSNumber\":[],\"string\":\"\",\"dictInt\":{},\"arrayBool\":[],\"nsArray\":[],\"anyObject\":true,\"arrayString\":[],\"dictFloat\":{},\"arrayNSString\":[],\"arrayDouble\":[],\"arrayFloat\":[],\"enumDouble\":0,\"arrayAnyObject\":[],\"float\":0,\"nsNumber\":0,\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"arrayEnumInt\":[],\"double\":0,\"nsString\":\"\",\"dictBool\":{},\"enumFloat\":0,\"dictAnyObject\":{},\"nsDictionary\":{},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"nsNumber\":0,\"dictString\":{}},\"classMember\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"structMemberOptional\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"arrayNSNumber\":[],\"string\":\"\",\"dictInt\":{},\"arrayBool\":[],\"nsArray\":[],\"anyObject\":true,\"arrayString\":[],\"dictFloat\":{},\"arrayNSString\":[],\"arrayDouble\":[],\"arrayFloat\":[],\"enumDouble\":0,\"arrayAnyObject\":[],\"float\":0,\"nsNumber\":0,\"dictString\":{}},\"classMemberImplicitlyUnwrapped\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":11,\"stringOptional\":\"stringOptional\",\"arrayIntImplicitlyUnwrapped\":[1,2,3,4,5],\"dictString\":{}},\"enumMember\":\"Default\",\"structMemberImplicitlyUnwrapped\":{\"enumString\":\"Default\",\"dictEnumInt\":{},\"int\":0,\"arrayInt\":[],\"dictDouble\":{},\"bool\":true,\"enumInt\":0,\"dictBoolImplicitlyUnwrapped\":{\"true\":true,\"false\":false},\"nsArrayOptional\":[\"one\",\"two\",\"three\"],\"arrayNSNumber\":[],\"dictString\":{}}}}"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMappingNestTypesFromJSON() {
        let mappedObject = TopMostLayerModel.deserialize(from: jsonString)!

        XCTAssertEqual(11, mappedObject.classMember.int)
        XCTAssertEqual("stringOptional", mappedObject.classMemberOptional?.stringOptional)
        XCTAssertEqual(5, mappedObject.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count)

        XCTAssertEqual(BasicTypesInStruct.EnumInt.Default, mappedObject.structMember.enumInt)
        XCTAssertEqual(3, mappedObject.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(false, mappedObject.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"])

        XCTAssertEqual("stringOptional", mappedObject.lowerLayerModel.classMember.stringOptional)
        XCTAssertEqual(3, mappedObject.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(BasicTypesInStruct.EnumInt.Default, mappedObject.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt)
        XCTAssertEqual("stringOptional", mappedObject.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional)
    }

    func testMappingNestTypesToJSON() {
        let basicClassModel = BasicTypesInClass()
        basicClassModel.int = 11
        basicClassModel.stringOptional = "stringOptional"
        basicClassModel.arrayIntImplicitlyUnwrapped = [1, 2, 3, 4, 5]

        var basicStructModel = BasicTypesInStruct()
        basicStructModel.enumInt = BasicTypesInStruct.EnumInt.Another
        basicStructModel.nsArrayOptional = ["one", "two", "three"]
        basicStructModel.dictBoolImplicitlyUnwrapped = ["true": true, "false": false]

        let lowerModel = LowerLayerModel()
        lowerModel.enumMember = StringEnum.Another
        lowerModel.enumMemberOptional = StringEnum.Another
        lowerModel.enumMemberImplicitlyUnwrapped = StringEnum.Another
        lowerModel.classMember = basicClassModel
        lowerModel.classMemberOptional = basicClassModel
        lowerModel.classMemberImplicitlyUnwrapped = basicClassModel
        lowerModel.structMember = basicStructModel
        lowerModel.structMemberOptional = basicStructModel
        lowerModel.structMemberImplicitlyUnwrapped = basicStructModel

        let topmostModel = TopMostLayerModel()
        topmostModel.classMember = basicClassModel
        topmostModel.classMemberOptional = basicClassModel
        topmostModel.classMemberImplicitlyUnwrapped = basicClassModel
        topmostModel.structMember = basicStructModel
        topmostModel.structMemberOptional = basicStructModel
        topmostModel.structMemberImplicitlyUnwrapped = basicStructModel
        topmostModel.lowerLayerModel = lowerModel
        topmostModel.lowerLayerModelOptional = lowerModel
        topmostModel.lowerLayerModelImplicitlyUnwrapped = lowerModel

        let jsonString = topmostModel.toJSONString()!
        let mappedObject = TopMostLayerModel.deserialize(from: jsonString)!

        XCTAssertEqual(topmostModel.classMember.int, mappedObject.classMember.int)
        XCTAssertEqual(topmostModel.classMemberOptional?.stringOptional, mappedObject.classMemberOptional?.stringOptional)
        XCTAssertEqual(topmostModel.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count, mappedObject.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count)

        XCTAssertEqual(topmostModel.structMember.enumInt, mappedObject.structMember.enumInt)
        XCTAssertEqual(topmostModel.structMemberOptional?.nsArrayOptional?.count, mappedObject.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"],
                       mappedObject.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"])

        XCTAssertEqual(topmostModel.lowerLayerModel.enumMember, mappedObject.lowerLayerModel.enumMember)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberOptional, mappedObject.lowerLayerModel.enumMemberOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberImplicitlyUnwrapped, mappedObject.lowerLayerModel.enumMemberImplicitlyUnwrapped)

        XCTAssertEqual(topmostModel.lowerLayerModel.classMember.stringOptional, mappedObject.lowerLayerModel.classMember.stringOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count,
                       mappedObject.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt,
                       mappedObject.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt)
        XCTAssertEqual(topmostModel.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional,
                       mappedObject.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional)
    }

    func testMappingNestTypesFromNSDictionary() {
        let jsonObject = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: .allowFragments)
        let dictionary = jsonObject as! NSDictionary
        let mappedObject = TopMostLayerModel.deserialize(from: dictionary)!

        XCTAssertEqual(11, mappedObject.classMember.int)
        XCTAssertEqual("stringOptional", mappedObject.classMemberOptional?.stringOptional)
        XCTAssertEqual(5, mappedObject.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count)

        XCTAssertEqual(BasicTypesInStruct.EnumInt.Default, mappedObject.structMember.enumInt)
        XCTAssertEqual(3, mappedObject.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(false, mappedObject.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"])

        XCTAssertEqual("stringOptional", mappedObject.lowerLayerModel.classMember.stringOptional)
        XCTAssertEqual(3, mappedObject.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(BasicTypesInStruct.EnumInt.Default, mappedObject.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt)
        XCTAssertEqual("stringOptional", mappedObject.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional)
    }

    func testMappingNestTypesFromPureDictionary() {
        let basicClassModel = BasicTypesInClass()
        basicClassModel.int = 11
        basicClassModel.stringOptional = "stringOptional"
        basicClassModel.arrayIntImplicitlyUnwrapped = [1, 2, 3, 4, 5]

        var basicStructModel = BasicTypesInStruct()
        basicStructModel.enumInt = BasicTypesInStruct.EnumInt.Another
        basicStructModel.nsArrayOptional = ["one", "two", "three"]
        basicStructModel.dictBoolImplicitlyUnwrapped = ["true": true, "false": false]

        let lowerModel = LowerLayerModel()
        lowerModel.enumMember = StringEnum.Another
        lowerModel.enumMemberOptional = StringEnum.Another
        lowerModel.enumMemberImplicitlyUnwrapped = StringEnum.Another
        lowerModel.classMember = basicClassModel
        lowerModel.classMemberOptional = basicClassModel
        lowerModel.classMemberImplicitlyUnwrapped = basicClassModel
        lowerModel.structMember = basicStructModel
        lowerModel.structMemberOptional = basicStructModel
        lowerModel.structMemberImplicitlyUnwrapped = basicStructModel

        let topmostModel = TopMostLayerModel()
        topmostModel.classMember = basicClassModel
        topmostModel.classMemberOptional = basicClassModel
        topmostModel.classMemberImplicitlyUnwrapped = basicClassModel
        topmostModel.structMember = basicStructModel
        topmostModel.structMemberOptional = basicStructModel
        topmostModel.structMemberImplicitlyUnwrapped = basicStructModel
        topmostModel.lowerLayerModel = lowerModel
        topmostModel.lowerLayerModelOptional = lowerModel
        topmostModel.lowerLayerModelImplicitlyUnwrapped = lowerModel

        var basicDict = [String: Any]()
        basicDict["int"] = 11
        basicDict["stringOptional"] = "stringOptional"
        basicDict["arrayIntImplicitlyUnwrapped"] = [1, 2, 3, 4, 5]
        basicDict["enumInt"] = BasicTypesInStruct.EnumInt.Another.rawValue
        basicDict["nsArrayOptional"] = ["one", "two", "three"]
        basicDict["dictBoolImplicitlyUnwrapped"] = ["true": true, "false": false]

        var lowerDict = [String: Any]()
        lowerDict["enumMember"] = StringEnum.Another
        lowerDict["enumMemberOptional"] = StringEnum.Another
        lowerDict["enumMemberImplicitlyUnwrapped"] = StringEnum.Another
        lowerDict["classMember"] = basicClassModel
        lowerDict["classMemberOptional"] = basicClassModel
        lowerDict["dictBoolImplicitlyUnwrapped"] = basicClassModel
        lowerDict["structMember"] = basicDict
        lowerDict["structMemberOptional"] = basicDict
        lowerDict["structMemberImplicitlyUnwrapped"] = basicDict

        var topmostDict = [String: Any]()
        topmostDict["classMember"] = basicDict
        topmostDict["classMemberOptional"] = basicDict
        topmostDict["classMemberImplicitlyUnwrapped"] = basicDict
        topmostDict["structMember"] = basicStructModel
        topmostDict["structMemberOptional"] = basicStructModel
        topmostDict["structMemberImplicitlyUnwrapped"] = basicStructModel
        topmostDict["lowerLayerModel"] = lowerDict
        topmostDict["lowerLayerModelOptional"] = lowerDict
        topmostDict["lowerLayerModelImplicitlyUnwrapped"] = lowerModel

        let mappedObject = TopMostLayerModel.deserialize(from: topmostDict)!

        XCTAssertEqual(topmostModel.classMember.int, mappedObject.classMember.int)
        XCTAssertEqual(topmostModel.classMemberOptional?.stringOptional, mappedObject.classMemberOptional?.stringOptional)
        XCTAssertEqual(topmostModel.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count, mappedObject.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count)

        XCTAssertEqual(topmostModel.structMember.enumInt, mappedObject.structMember.enumInt)
        XCTAssertEqual(topmostModel.structMemberOptional?.nsArrayOptional?.count, mappedObject.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"],
                       mappedObject.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"])

        XCTAssertEqual(topmostModel.lowerLayerModel.enumMember, mappedObject.lowerLayerModel.enumMember)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberOptional, mappedObject.lowerLayerModel.enumMemberOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberImplicitlyUnwrapped, mappedObject.lowerLayerModel.enumMemberImplicitlyUnwrapped)

        XCTAssertEqual(topmostModel.lowerLayerModel.classMember.stringOptional, mappedObject.lowerLayerModel.classMember.stringOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count,
                       mappedObject.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt,
                       mappedObject.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt)
        XCTAssertEqual(topmostModel.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional,
                       mappedObject.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional)
    }

    func testMappingNestTypesToAndFromDict() {
        let basicClassModel = BasicTypesInClass()
        basicClassModel.int = 11
        basicClassModel.stringOptional = "stringOptional"
        basicClassModel.arrayIntImplicitlyUnwrapped = [1, 2, 3, 4, 5]

        var basicStructModel = BasicTypesInStruct()
        basicStructModel.enumInt = BasicTypesInStruct.EnumInt.Another
        basicStructModel.nsArrayOptional = ["one", "two", "three"]
        basicStructModel.dictBoolImplicitlyUnwrapped = ["true": true, "false": false]

        let lowerModel = LowerLayerModel()
        lowerModel.enumMember = StringEnum.Another
        lowerModel.enumMemberOptional = StringEnum.Another
        lowerModel.enumMemberImplicitlyUnwrapped = StringEnum.Another
        lowerModel.classMember = basicClassModel
        lowerModel.classMemberOptional = basicClassModel
        lowerModel.classMemberImplicitlyUnwrapped = basicClassModel
        lowerModel.structMember = basicStructModel
        lowerModel.structMemberOptional = basicStructModel
        lowerModel.structMemberImplicitlyUnwrapped = basicStructModel

        let topmostModel = TopMostLayerModel()
        topmostModel.classMember = basicClassModel
        topmostModel.classMemberOptional = basicClassModel
        topmostModel.classMemberImplicitlyUnwrapped = basicClassModel
        topmostModel.structMember = basicStructModel
        topmostModel.structMemberOptional = basicStructModel
        topmostModel.structMemberImplicitlyUnwrapped = basicStructModel
        topmostModel.lowerLayerModel = lowerModel
        topmostModel.lowerLayerModelOptional = lowerModel
        topmostModel.lowerLayerModelImplicitlyUnwrapped = lowerModel

        let dict = topmostModel.toJSON()!
        let mappedObject = TopMostLayerModel.deserialize(from: dict)!

        XCTAssertEqual(topmostModel.classMember.int, mappedObject.classMember.int)
        XCTAssertEqual(topmostModel.classMemberOptional?.stringOptional, mappedObject.classMemberOptional?.stringOptional)
        XCTAssertEqual(topmostModel.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count, mappedObject.classMemberImplicitlyUnwrapped.arrayIntImplicitlyUnwrapped.count)

        XCTAssertEqual(topmostModel.structMember.enumInt, mappedObject.structMember.enumInt)
        XCTAssertEqual(topmostModel.structMemberOptional?.nsArrayOptional?.count, mappedObject.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"],
                       mappedObject.structMemberImplicitlyUnwrapped.dictBoolImplicitlyUnwrapped["false"])

        XCTAssertEqual(topmostModel.lowerLayerModel.enumMember, mappedObject.lowerLayerModel.enumMember)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberOptional, mappedObject.lowerLayerModel.enumMemberOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.enumMemberImplicitlyUnwrapped, mappedObject.lowerLayerModel.enumMemberImplicitlyUnwrapped)

        XCTAssertEqual(topmostModel.lowerLayerModel.classMember.stringOptional, mappedObject.lowerLayerModel.classMember.stringOptional)
        XCTAssertEqual(topmostModel.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count,
                       mappedObject.lowerLayerModel.structMemberOptional?.nsArrayOptional?.count)
        XCTAssertEqual(topmostModel.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt,
                       mappedObject.lowerLayerModelOptional?.structMemberImplicitlyUnwrapped.enumInt)
        XCTAssertEqual(topmostModel.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional,
                       mappedObject.lowerLayerModelImplicitlyUnwrapped.classMemberImplicitlyUnwrapped.stringOptional)
    }
}
