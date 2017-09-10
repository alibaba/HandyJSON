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
//  BasicTypesInStructTestsFromJSON.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/09/2017.
//

import Foundation
import XCTest
import HandyJSON

class BasicTypesInStructTestsFromJSON: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Test mapping to JSON and back (basic types: Bool, Int, Double, Float, String)

    func testMappingBoolFromJSON(){
        let value: Bool = true
        let JSONString = "{\"bool\" : \(value), \"boolOptional\" : \(value), \"boolImplicitlyUnwrapped\" : \(value)}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.bool, value)
        XCTAssertEqual(mappedObject?.boolOptional, value)
        XCTAssertEqual(mappedObject?.boolImplicitlyUnwrapped, value)
    }

    func testMappingIntFromJSON(){
        let value: Int = 11
        let JSONString = "{\"int\" : \(value), \"intOptional\" : \(value), \"intImplicitlyUnwrapped\" : \(value)}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.int, value)
        XCTAssertEqual(mappedObject?.intOptional, value)
        XCTAssertEqual(mappedObject?.intImplicitlyUnwrapped, value)
    }

    func testMappingDoubleFromJSON(){
        let value: Double = 11
        let JSONString = "{\"double\" : \(value), \"doubleOptional\" : \(value), \"doubleImplicitlyUnwrapped\" : \(value)}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.double, value)
        XCTAssertEqual(mappedObject?.doubleOptional, value)
        XCTAssertEqual(mappedObject?.doubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatFromJSON(){
        let value: Float = 11
        let JSONString = "{\"float\" : \(value), \"floatOptional\" : \(value), \"floatImplicitlyUnwrapped\" : \(value)}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.float, value)
        XCTAssertEqual(mappedObject?.floatOptional, value)
        XCTAssertEqual(mappedObject?.floatImplicitlyUnwrapped, value)
    }

    func testMappingStringFromJSON(){
        let value: String = "STRINGNGNGG"
        let JSONString = "{\"string\" : \"\(value)\", \"stringOptional\" : \"\(value)\", \"stringImplicitlyUnwrapped\" : \"\(value)\"}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.string, value)
        XCTAssertEqual(mappedObject?.stringOptional, value)
        XCTAssertEqual(mappedObject?.stringImplicitlyUnwrapped, value)
    }

    func testMappingAnyObjectFromJSON(){
        let value1 = "STRING"
        let value2: Int = 1234
        let value3: Double = 11.11
        let JSONString = "{\"anyObject\" : \"\(value1)\", \"anyObjectOptional\" : \(value2), \"anyObjectImplicitlyUnwrapped\" : \(value3)}"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.anyObject as? String, value1)
        XCTAssertEqual(mappedObject?.anyObjectOptional as? Int, value2)
        XCTAssertEqual(mappedObject?.anyObjectImplicitlyUnwrapped as? Double, value3)
    }

    func testMappingStringFromNSStringJSON(){
        let value: String = "STRINGNGNGG"
        let JSONNSString : NSString = "{\"string\" : \"\(value)\", \"stringOptional\" : \"\(value)\", \"stringImplicitlyUnwrapped\" : \"\(value)\"}" as NSString

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONNSString as String)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.string, value)
        XCTAssertEqual(mappedObject?.stringOptional, value)
        XCTAssertEqual(mappedObject?.stringImplicitlyUnwrapped, value)
    }

    // MARK: Test mapping Arrays to JSON and back (with basic types in them Bool, Int, Double, Float, String)

    func testMappingBoolArrayFromJSON(){
        let value: Bool = true
        let JSONString = "{\"arrayBool\" : [\(value)], \"arrayBoolOptional\" : [\(value)], \"arrayBoolImplicitlyUnwrapped\" : [\(value)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayBool.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolImplicitlyUnwrapped.first, value)
    }

    func testMappingIntArrayFromJSON(){
        let value: Int = 1
        let JSONString = "{\"arrayInt\" : [\(value)], \"arrayIntOptional\" : [\(value)], \"arrayIntImplicitlyUnwrapped\" : [\(value)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayInt.first, value)
        XCTAssertEqual(mappedObject?.arrayIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayIntImplicitlyUnwrapped.first, value)
    }

    func testMappingDoubleArrayFromJSON(){
        let value: Double = 1.0
        let JSONString = "{\"arrayDouble\" : [\(value)], \"arrayDoubleOptional\" : [\(value)], \"arrayDoubleImplicitlyUnwrapped\" : [\(value)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayDouble.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleImplicitlyUnwrapped.first, value)
    }

    func testMappingFloatArrayFromJSON(){
        let value: Float = 1.001
        let JSONString = "{\"arrayFloat\" : [\(value)], \"arrayFloatOptional\" : [\(value)], \"arrayFloatImplicitlyUnwrapped\" : [\(value)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayFloat.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatImplicitlyUnwrapped.first, value)
    }

    func testMappingStringArrayFromJSON(){
        let value: String = "Stringgggg"
        let JSONString = "{\"arrayString\" : [\"\(value)\"], \"arrayStringOptional\" : [\"\(value)\"], \"arrayStringImplicitlyUnwrapped\" : [\"\(value)\"] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayString.first, value)
        XCTAssertEqual(mappedObject?.arrayStringOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayStringImplicitlyUnwrapped.first, value)
    }

    func testMappingAnyObjectArrayFromJSON(){
        let value1 = "STRING"
        let value2: Int = 1234
        let value3: Double = 11.11
        let JSONString = "{\"arrayAnyObject\" : [\"\(value1)\"], \"arrayAnyObjectOptional\" : [\(value2)], \"arrayAnyObjectImplicitlyUnwrapped\" : [\(value3)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayAnyObject.first as? String, value1)
        XCTAssertEqual(mappedObject?.arrayAnyObjectOptional?.first as? Int, value2)
        XCTAssertEqual(mappedObject?.arrayAnyObjectImplicitlyUnwrapped.first as? Double, value3)
    }

    // MARK: Test mapping Dictionaries to JSON and back (with basic types in them Bool, Int, Double, Float, String)

    func testMappingBoolDictionaryFromJSON(){
        let key = "key"
        let value: Bool = true
        let JSONString = "{\"dictBool\" : { \"\(key)\" : \(value)}, \"dictBoolOptional\" : { \"\(key)\" : \(value)}, \"dictBoolImplicitlyUnwrapped\" : { \"\(key)\" : \(value)} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictBool[key], value)
        XCTAssertEqual(mappedObject?.dictBoolOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictBoolImplicitlyUnwrapped[key], value)
    }

    func testMappingIntDictionaryFromJSON(){
        let key = "key"
        let value: Int = 11
        let JSONString = "{\"dictInt\" : { \"\(key)\" : \(value)}, \"dictIntOptional\" : { \"\(key)\" : \(value)}, \"dictIntImplicitlyUnwrapped\" : { \"\(key)\" : \(value)} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictInt[key], value)
        XCTAssertEqual(mappedObject?.dictIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictIntImplicitlyUnwrapped[key], value)
    }

    func testMappingDoubleDictionaryFromJSON(){
        let key = "key"
        let value: Double = 11
        let JSONString = "{\"dictDouble\" : { \"\(key)\" : \(value)}, \"dictDoubleOptional\" : { \"\(key)\" : \(value)}, \"dictDoubleImplicitlyUnwrapped\" : { \"\(key)\" : \(value)} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictDouble[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleImplicitlyUnwrapped[key], value)
    }

    func testMappingFloatDictionaryFromJSON(){
        let key = "key"
        let value: Float = 111.1
        let JSONString = "{\"dictFloat\" : { \"\(key)\" : \(value)}, \"dictFloatOptional\" : { \"\(key)\" : \(value)}, \"dictFloatImplicitlyUnwrapped\" : { \"\(key)\" : \(value)} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictFloat[key], value)
        XCTAssertEqual(mappedObject?.dictFloatOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictFloatImplicitlyUnwrapped[key], value)
    }

    func testMappingStringDictionaryFromJSON(){
        let key = "key"
        let value = "value"
        let JSONString = "{\"dictString\" : { \"\(key)\" : \"\(value)\"}, \"dictStringOptional\" : { \"\(key)\" : \"\(value)\"}, \"dictStringImplicitlyUnwrapped\" : { \"\(key)\" : \"\(value)\"} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictString[key], value)
        XCTAssertEqual(mappedObject?.dictStringOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictStringImplicitlyUnwrapped[key], value)
    }

    func testMappingAnyObjectDictionaryFromJSON(){
        let key = "key"
        let value1 = "STRING"
        let value2: Int = 1234
        let value3: Double = 11.11
        let JSONString = "{\"dictAnyObject\" : { \"\(key)\" : \"\(value1)\"}, \"dictAnyObjectOptional\" : { \"\(key)\" : \(value2)}, \"dictAnyObjectImplicitlyUnwrapped\" : { \"\(key)\" : \(value3)} }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictAnyObject[key] as? String, value1)
        XCTAssertEqual(mappedObject?.dictAnyObjectOptional?[key] as? Int, value2)
        XCTAssertEqual(mappedObject?.dictAnyObjectImplicitlyUnwrapped[key] as? Double, value3)
    }

    func testMappingIntEnumFromJSON(){
        let value: BasicTypesInStruct.EnumInt = .Another
        let JSONString = "{\"enumInt\" : \(value.rawValue), \"enumIntOptional\" : \(value.rawValue), \"enumIntImplicitlyUnwrapped\" : \(value.rawValue) }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumInt, value)
        XCTAssertEqual(mappedObject?.enumIntOptional, value)
        XCTAssertEqual(mappedObject?.enumIntImplicitlyUnwrapped, value)
    }

    func testMappingIntEnumFromJSONShouldNotCrashWithNonDefinedvalue() {
        let value = Int.min
        let JSONString = "{\"enumInt\" : \(value), \"enumIntOptional\" : \(value), \"enumIntImplicitlyUnwrapped\" : \(value) }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumInt, BasicTypesInStruct.EnumInt.Default)
        XCTAssertNil(mappedObject?.enumIntOptional)
        XCTAssertNil(mappedObject?.enumIntImplicitlyUnwrapped)
    }

    func testMappingDoubleEnumFromJSON(){
        let value: BasicTypesInStruct.EnumDouble = .Another
        let JSONString = "{\"enumDouble\" : \(value.rawValue), \"enumDoubleOptional\" : \(value.rawValue), \"enumDoubleImplicitlyUnwrapped\" : \(value.rawValue) }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumDouble, value)
        XCTAssertEqual(mappedObject?.enumDoubleOptional, value)
        XCTAssertEqual(mappedObject?.enumDoubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatEnumFromJSON(){
        let value: BasicTypesInStruct.EnumFloat = .Another
        let JSONString = "{\"enumFloat\" : \(value.rawValue), \"enumFloatOptional\" : \(value.rawValue), \"enumFloatImplicitlyUnwrapped\" : \(value.rawValue) }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumFloat, value)
        XCTAssertEqual(mappedObject?.enumFloatOptional, value)
        XCTAssertEqual(mappedObject?.enumFloatImplicitlyUnwrapped, value)
    }

    func testMappingStringEnumFromJSON(){
        let value: BasicTypesInStruct.EnumString = .Another
        let JSONString = "{\"enumString\" : \"\(value.rawValue)\", \"enumStringOptional\" : \"\(value.rawValue)\", \"enumStringImplicitlyUnwrapped\" : \"\(value.rawValue)\" }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumString, value)
        XCTAssertEqual(mappedObject?.enumStringOptional, value)
        XCTAssertEqual(mappedObject?.enumStringImplicitlyUnwrapped, value)
    }

    func testMappingEnumIntArrayFromJSON(){
        let value: BasicTypesInStruct.EnumInt = .Another
        let JSONString = "{ \"arrayEnumInt\" : [\(value.rawValue)], \"arrayEnumIntOptional\" : [\(value.rawValue)], \"arrayEnumIntImplicitlyUnwrapped\" : [\(value.rawValue)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayEnumInt.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntImplicitlyUnwrapped.first, value)
    }

    func testMappingEnumIntArrayFromJSONShouldNotCrashWithNonDefinedvalue() {
        let value = Int.min
        let JSONString = "{ \"arrayEnumInt\" : [\(value)], \"arrayEnumIntOptional\" : [\(value)], \"arrayEnumIntImplicitlyUnwrapped\" : [\(value)] }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertNil(mappedObject?.arrayEnumInt.first)
        XCTAssertNil(mappedObject?.arrayEnumIntOptional?.first)
        XCTAssertNil(mappedObject?.arrayEnumIntImplicitlyUnwrapped.first)
    }

    func testMappingEnumIntDictionaryFromJSON(){
        let key = "key"
        let value: BasicTypesInStruct.EnumInt = .Another
        let JSONString = "{ \"dictEnumInt\" : { \"\(key)\" : \(value.rawValue) }, \"dictEnumIntOptional\" : { \"\(key)\" : \(value.rawValue) }, \"dictEnumIntImplicitlyUnwrapped\" : { \"\(key)\" : \(value.rawValue) } }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictEnumInt[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntImplicitlyUnwrapped[key], value)
    }

    func testMappingNSDictionaryFromJSON() {
        let JSONString = "{\"nsDictionaryOptional\":{\"name4\":{\"key\":\"value\"},\"name2\":\"one\",\"name1\":1,\"name3\":[1,2,3]},\"nsDictionary\":{\"name4\":{\"key\":\"value\"},\"name2\":\"one\",\"name1\":1,\"name3\":[1,2,3]},\"nsDictionaryImplicitlyUnwrapped\":{\"name4\":{\"key\":\"value\"},\"name2\":\"one\",\"name1\":1,\"name3\":[1,2,3]}}"
        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)
        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.nsDictionary.count, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryOptional?.count ?? 0, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryImplicitlyUnwrapped.count, 4)
        XCTAssertEqual(mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name2") as! String, "one")
        XCTAssertEqual((mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name3") as! NSArray).count, 3)
        XCTAssertEqual((mappedObject!.nsDictionaryImplicitlyUnwrapped.object(forKey: "name4") as! [String: String])["key"], "value")
    }

    func testMappingEnumIntDictionaryFromJSONShouldNotCrashWithNonDefinedvalue() {
        let key = "key"
        let value = Int.min
        let JSONString = "{ \"dictEnumInt\" : { \"\(key)\" : \(value) }, \"dictEnumIntOptional\" : { \"\(key)\" : \(value) }, \"dictEnumIntImplicitlyUnwrapped\" : { \"\(key)\" : \(value) } }"

        let mappedObject = BasicTypesInStruct.deserialize(from: JSONString)

        XCTAssertNotNil(mappedObject)
        XCTAssertNil(mappedObject?.dictEnumInt[key])
        XCTAssertNil(mappedObject?.dictEnumIntOptional?[key])
        XCTAssertNil(mappedObject?.dictEnumIntImplicitlyUnwrapped[key])
    }

    func testObjectModelOptionalDictionnaryOfPrimitives() {
        let JSON: [String: [String: Any]] = ["dictStringString":["string": "string"], "dictStringBool":["string": false], "dictStringInt":["string": 1], "dictStringDouble":["string": 1.1], "dictStringFloat":["string": Float(1.2)]]

        let testSet = JSONDeserializer<TestCollectionOfPrimitives>.deserializeFrom(dict: JSON as NSDictionary)!

        XCTAssertNotNil(testSet)

        XCTAssertTrue(testSet.dictStringString.count > 0)
        XCTAssertTrue(testSet.dictStringInt.count > 0)
        XCTAssertTrue(testSet.dictStringBool.count > 0)
        XCTAssertTrue(testSet.dictStringDouble.count > 0)
        XCTAssertTrue(testSet.dictStringFloat.count > 0)
    }

    func testUpdateExistModel() {
        var basicObject = BasicTypesInStruct()
        basicObject.int = 3
        basicObject.intOptional = nil

        var object = BasicTypesInClass()
        object.int = 2
        object.intOptional = 2

        let jsonString = basicObject.toJSONString()!
        JSONDeserializer.update(object: &object, from: jsonString)

        XCTAssertEqual(3, object.int)
        XCTAssertEqual(2, object.intOptional)

        basicObject.int = 4
        let jsonDict = basicObject.toJSON()!
        JSONDeserializer.update(object: &object, from: jsonDict)

        XCTAssertEqual(4, object.int)
        XCTAssertEqual(2, object.intOptional)
    }
}
