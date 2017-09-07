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
//  BasicTypesInStructTestsToJSON.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/09/2017.
//

import Foundation
import XCTest
import HandyJSON

class BasicTypesInStructTestsToJSON: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMappingBoolToJSON(){
        let value: Bool = true
        var object = BasicTypesInStruct()
        object.bool = value
        object.boolOptional = value
        object.boolImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.bool, value)
        XCTAssertEqual(mappedObject?.boolOptional, value)
        XCTAssertEqual(mappedObject?.boolImplicitlyUnwrapped, value)
    }

    func testMappingIntToJSON(){
        let value: Int = 11
        var object = BasicTypesInStruct()
        object.int = value
        object.intOptional = value
        object.intImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
       let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.int, value)
        XCTAssertEqual(mappedObject?.intOptional, value)
        XCTAssertEqual(mappedObject?.intImplicitlyUnwrapped, value)
    }

    func testMappingDoubleToJSON(){
        let value: Double = 11
        var object = BasicTypesInStruct()
        object.double = value
        object.doubleOptional = value
        object.doubleImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject =  BasicTypesInStruct.deserialize(from: JSONString) // BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.double, value)
        XCTAssertEqual(mappedObject?.doubleOptional, value)
        XCTAssertEqual(mappedObject?.doubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatToJSON(){
        let value: Float = 11
        var object = BasicTypesInStruct()
        object.float = value
        object.floatOptional = value
        object.floatImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.float, value)
        XCTAssertEqual(mappedObject?.floatOptional, value)
        XCTAssertEqual(mappedObject?.floatImplicitlyUnwrapped, value)
    }

    func testMappingStringToJSON(){
        let value: String = "STRINGNGNGG"
        var object = BasicTypesInStruct()
        object.string = value
        object.stringOptional = value
        object.stringImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.string, value)
        XCTAssertEqual(mappedObject?.stringOptional, value)
        XCTAssertEqual(mappedObject?.stringImplicitlyUnwrapped, value)
    }

    func testMappingAnyObjectToJSON(){
        let value: String = "STRINGNGNGG"
        var object = BasicTypesInStruct()
        object.anyObject = value
        object.anyObjectOptional = value
        object.anyObjectImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.anyObject as? String, value)
        XCTAssertEqual(mappedObject?.anyObjectOptional as? String, value)
        XCTAssertEqual(mappedObject?.anyObjectImplicitlyUnwrapped as? String, value)
    }

    // MARK: Test mapping Arrays to JSON and back (with basic types in them Bool, Int, Double, Float, String)
    func testMappingEmptyArrayToJSON(){
        var object = BasicTypesInStruct()
        object.arrayBool = []
        object.arrayBoolOptional = []
        object.arrayBoolImplicitlyUnwrapped = []

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.arrayBool, [])
        XCTAssertEqual(mappedObject!.arrayBoolOptional!, [])
        XCTAssertEqual(mappedObject!.arrayBoolImplicitlyUnwrapped, [])
    }

    func testMappingBoolArrayToJSON(){
        let value: Bool = true
        var object = BasicTypesInStruct()
        object.arrayBool = [value]
        object.arrayBoolOptional = [value]
        object.arrayBoolImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayBool.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolImplicitlyUnwrapped.first, value)
    }

    func testMappingIntArrayToJSON(){
        let value: Int = 1
        var object = BasicTypesInStruct()
        object.arrayInt = [value]
        object.arrayIntOptional = [value]
        object.arrayIntImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayInt.first, value)
        XCTAssertEqual(mappedObject?.arrayIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayIntImplicitlyUnwrapped.first, value)
    }

    func testMappingDoubleArrayToJSON(){
        let value: Double = 1.0
        var object = BasicTypesInStruct()
        object.arrayDouble = [value]
        object.arrayDoubleOptional = [value]
        object.arrayDoubleImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayDouble.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleImplicitlyUnwrapped.first, value)
    }

    func testMappingFloatArrayToJSON(){
        let value: Float = 1.001
        var object = BasicTypesInStruct()
        object.arrayFloat = [value]
        object.arrayFloatOptional = [value]
        object.arrayFloatImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayFloat.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatImplicitlyUnwrapped.first, value)
    }

    func testMappingStringArrayToJSON(){
        let value: String = "Stringgggg"
        var object = BasicTypesInStruct()
        object.arrayString = [value]
        object.arrayStringOptional = [value]
        object.arrayStringImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayString.first, value)
        XCTAssertEqual(mappedObject?.arrayStringOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayStringImplicitlyUnwrapped.first, value)
    }

    func testMappingAnyObjectArrayToJSON(){
        let value: String = "Stringgggg"
        var object = BasicTypesInStruct()
        object.arrayAnyObject = [value]
        object.arrayAnyObjectOptional = [value]
        object.arrayAnyObjectImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayAnyObject.first as? String, value)
        XCTAssertEqual(mappedObject?.arrayAnyObjectOptional?.first as? String, value)
        XCTAssertEqual(mappedObject?.arrayAnyObjectImplicitlyUnwrapped.first as? String, value)
    }

    // MARK: Test mapping Dictionaries to JSON and back (with basic types in them Bool, Int, Double, Float, String)

    func testMappingEmptyDictionaryToJSON(){
        var object = BasicTypesInStruct()
        object.dictBool = [:]
        object.dictBoolOptional = [:]
        object.dictBoolImplicitlyUnwrapped = [:]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.dictBool, [:])
        XCTAssertEqual(mappedObject!.dictBoolOptional!, [:])
        XCTAssertEqual(mappedObject!.dictBoolImplicitlyUnwrapped, [:])
    }

    func testMappingBoolDictionaryToJSON(){
        let key = "key"
        let value: Bool = true
        var object = BasicTypesInStruct()
        object.dictBool = [key:value]
        object.dictBoolOptional = [key:value]
        object.dictBoolImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictBool[key], value)
        XCTAssertEqual(mappedObject?.dictBoolOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictBoolImplicitlyUnwrapped[key], value)
    }

    func testMappingIntDictionaryToJSON(){
        let key = "key"
        let value: Int = 11
        var object = BasicTypesInStruct()
        object.dictInt = [key:value]
        object.dictIntOptional = [key:value]
        object.dictIntImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictInt[key], value)
        XCTAssertEqual(mappedObject?.dictIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictIntImplicitlyUnwrapped[key], value)
    }

    func testMappingDoubleDictionaryToJSON(){
        let key = "key"
        let value: Double = 11
        var object = BasicTypesInStruct()
        object.dictDouble = [key:value]
        object.dictDoubleOptional = [key:value]
        object.dictDoubleImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictDouble[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleImplicitlyUnwrapped[key], value)
    }

    func testMappingFloatDictionaryToJSON(){
        let key = "key"
        let value: Float = 11
        var object = BasicTypesInStruct()
        object.dictFloat = [key:value]
        object.dictFloatOptional = [key:value]
        object.dictFloatImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictFloat[key], value)
        XCTAssertEqual(mappedObject?.dictFloatOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictFloatImplicitlyUnwrapped[key], value)
    }

    func testMappingStringDictionaryToJSON(){
        let key = "key"
        let value = "value"
        var object = BasicTypesInStruct()
        object.dictString = [key:value]
        object.dictStringOptional = [key:value]
        object.dictStringImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictString[key], value)
        XCTAssertEqual(mappedObject?.dictStringOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictStringImplicitlyUnwrapped[key], value)
    }

    func testMappingAnyObjectDictionaryToJSON(){
        let key = "key"
        let value = "value"
        var object = BasicTypesInStruct()
        object.dictAnyObject = [key:value]
        object.dictAnyObjectOptional = [key:value]
        object.dictAnyObjectImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictAnyObject[key] as? String, value)
        XCTAssertEqual(mappedObject?.dictAnyObjectOptional?[key] as? String, value)
        XCTAssertEqual(mappedObject?.dictAnyObjectImplicitlyUnwrapped[key] as? String, value)
    }

    func testMappingIntEnumToJSON(){
        let value = BasicTypesInStruct.EnumInt.Another
        var object = BasicTypesInStruct()
        object.enumInt = value
        object.enumIntOptional = value
        object.enumIntImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumInt, value)
        XCTAssertEqual(mappedObject?.enumIntOptional, value)
        XCTAssertEqual(mappedObject?.enumIntImplicitlyUnwrapped, value)
    }

    func testMappingDoubleEnumToJSON(){
        let value = BasicTypesInStruct.EnumDouble.Another
        var object = BasicTypesInStruct()
        object.enumDouble = value
        object.enumDoubleOptional = value
        object.enumDoubleImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumDouble, value)
        XCTAssertEqual(mappedObject?.enumDoubleOptional, value)
        XCTAssertEqual(mappedObject?.enumDoubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatEnumToJSON(){
        let value = BasicTypesInStruct.EnumFloat.Another
        var object = BasicTypesInStruct()
        object.enumFloat = value
        object.enumFloatOptional = value
        object.enumFloatImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumFloat, value)
        XCTAssertEqual(mappedObject?.enumFloatOptional, value)
        XCTAssertEqual(mappedObject?.enumFloatImplicitlyUnwrapped, value)
    }

    func testMappingStringEnumToJSON(){
        let value = BasicTypesInStruct.EnumString.Another
        var object = BasicTypesInStruct()
        object.enumString = value
        object.enumStringOptional = value
        object.enumStringImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumString, value)
        XCTAssertEqual(mappedObject?.enumStringOptional, value)
        XCTAssertEqual(mappedObject?.enumStringImplicitlyUnwrapped, value)
    }

    func testMappingEnumIntArrayToJSON(){
        let value = BasicTypesInStruct.EnumInt.Another
        var object = BasicTypesInStruct()
        object.arrayEnumInt = [value]
        object.arrayEnumIntOptional = [value]
        object.arrayEnumIntImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayEnumInt.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntImplicitlyUnwrapped.first, value)
    }

    func testMappingEnumIntDictionaryToJSON(){
        let key = "key"
        let value = BasicTypesInStruct.EnumInt.Another
        var object = BasicTypesInStruct()
        object.dictEnumInt = [key: value]
        object.dictEnumIntOptional = [key: value]
        object.dictEnumIntImplicitlyUnwrapped = [key: value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictEnumInt[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntImplicitlyUnwrapped[key], value)
    }

    func testMappingNSNumberToJSON(){
        let value: NSNumber = 11
        var object = BasicTypesInStruct()
        object.nsNumber = value
        object.nsNumberOptional = value
        object.nsNumberImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
       let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.nsNumber, value)
        XCTAssertEqual(mappedObject?.nsNumberOptional, value)
        XCTAssertEqual(mappedObject?.nsNumberImplicitlyUnwrapped, value)
    }

    func testMappingNSStringToJSON(){
        let value: NSString = "11"
        var object = BasicTypesInStruct()
        object.nsString = value
        object.nsStringOptional = value
        object.nsStringImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
       let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.nsString, value)
        XCTAssertEqual(mappedObject?.nsStringOptional, value)
        XCTAssertEqual(mappedObject?.nsStringImplicitlyUnwrapped, value)
    }

    func testMappingNSStringArrayToJSON(){
        let value: NSString = "Stringgggg"
        var object = BasicTypesInStruct()
        object.arrayNSString = [value]
        object.arrayNSStringOptional = [value]
        object.arrayNSStringImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayNSString.first, value)
        XCTAssertEqual(mappedObject?.arrayNSStringOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayNSStringImplicitlyUnwrapped.first, value)
    }

    func testMappingNSNumberArrayToJSON(){
        let value: NSNumber = 1.234
        var object = BasicTypesInStruct()
        object.arrayNSNumber = [value]
        object.arrayNSNumberOptional = [value]
        object.arrayNSNumberImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayNSNumber.first, value)
        XCTAssertEqual(mappedObject?.arrayNSNumberOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayNSNumberImplicitlyUnwrapped.first, value)
    }

    func testMappingNSArrayToJSON() {
        let nsArray = NSMutableArray()
        nsArray.add(1)
        nsArray.add("one")
        nsArray.add([1, 2, 3])

        var object = BasicTypesInStruct()
        object.nsArray = nsArray
        object.nsArrayOptional = nsArray
        object.nsArrayImplicitlyUnwrapped = nsArray

        let JSONString = object.toJSONString(prettyPrint: false)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)
        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.nsArray.count, 3)
        XCTAssertEqual(mappedObject!.nsArrayOptional?.count ?? 0, 3)
        XCTAssertEqual(mappedObject!.nsArrayImplicitlyUnwrapped.count, 3)
        XCTAssertEqual(mappedObject!.nsArrayImplicitlyUnwrapped.object(at: 1) as! String, "one")
        XCTAssertEqual((mappedObject!.nsArrayImplicitlyUnwrapped.object(at: 2) as! NSArray).count, 3)
    }

    func testMappingNSDictionaryToJSON() {
        let nsDict = NSMutableDictionary()
        nsDict.setObject(1, forKey: "name1" as NSString)
        nsDict.setObject("one", forKey: "name2" as NSString)
        nsDict.setObject([1, 2, 3], forKey: "name3" as NSString)
        nsDict.setObject(["key": "value"], forKey: "name4" as NSString)

        var object = BasicTypesInStruct()
        object.nsDictionary = nsDict
        object.nsDictionaryOptional = nsDict
        object.nsDictionaryImplicitlyUnwrapped = nsDict
        let JSONString = object.toJSONString(prettyPrint: false)
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString!)
        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.nsDictionary.count, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryOptional?.count ?? 0, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryImplicitlyUnwrapped.count, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name2") as! String, "one")
        XCTAssertEqual((mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name3") as! NSArray).count, 3)
        XCTAssertEqual((mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name4") as! [String: String])["key"], "value")
    }
}
