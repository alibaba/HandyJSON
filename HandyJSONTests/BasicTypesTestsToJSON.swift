//
//  BasicTypesTests.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-12-04.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2016 Hearst
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import XCTest
import HandyJSON

class BasicTypesTestsToJSON: XCTestCase {

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
        let object = BasicTypes()
        object.bool = value
        object.boolOptional = value
        object.boolImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.bool, value)
        XCTAssertEqual(mappedObject?.boolOptional, value)
        XCTAssertEqual(mappedObject?.boolImplicitlyUnwrapped, value)
    }

    func testMappingIntToJSON(){
        let value: Int = 11
        let object = BasicTypes()
        object.int = value
        object.intOptional = value
        object.intImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.int, value)
        XCTAssertEqual(mappedObject?.intOptional, value)
        XCTAssertEqual(mappedObject?.intImplicitlyUnwrapped, value)
    }

    func testMappingDoubleToJSON(){
        let value: Double = 11
        let object = BasicTypes()
        object.double = value
        object.doubleOptional = value
        object.doubleImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.double, value)
        XCTAssertEqual(mappedObject?.doubleOptional, value)
        XCTAssertEqual(mappedObject?.doubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatToJSON(){
        let value: Float = 11
        let object = BasicTypes()
        object.float = value
        object.floatOptional = value
        object.floatImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.float, value)
        XCTAssertEqual(mappedObject?.floatOptional, value)
        XCTAssertEqual(mappedObject?.floatImplicitlyUnwrapped, value)
    }

    func testMappingStringToJSON(){
        let value: String = "STRINGNGNGG"
        let object = BasicTypes()
        object.string = value
        object.stringOptional = value
        object.stringImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.string, value)
        XCTAssertEqual(mappedObject?.stringOptional, value)
        XCTAssertEqual(mappedObject?.stringImplicitlyUnwrapped, value)
    }

    func testMappingAnyObjectToJSON(){
        let value: String = "STRINGNGNGG"
        let object = BasicTypes()
        object.anyObject = value
        object.anyObjectOptional = value
        object.anyObjectImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.anyObject as? String, value)
        XCTAssertEqual(mappedObject?.anyObjectOptional as? String, value)
        XCTAssertEqual(mappedObject?.anyObjectImplicitlyUnwrapped as? String, value)
    }

    // MARK: Test mapping Arrays to JSON and back (with basic types in them Bool, Int, Double, Float, String)
    func testMappingEmptyArrayToJSON(){
        let object = BasicTypes()
        object.arrayBool = []
        object.arrayBoolOptional = []
        object.arrayBoolImplicitlyUnwrapped = []

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.arrayBool, [])
        XCTAssertEqual(mappedObject!.arrayBoolOptional!, [])
        XCTAssertEqual(mappedObject!.arrayBoolImplicitlyUnwrapped, [])
    }

    func testMappingBoolArrayToJSON(){
        let value: Bool = true
        let object = BasicTypes()
        object.arrayBool = [value]
        object.arrayBoolOptional = [value]
        object.arrayBoolImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayBool.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayBoolImplicitlyUnwrapped.first, value)
    }

    func testMappingIntArrayToJSON(){
        let value: Int = 1
        let object = BasicTypes()
        object.arrayInt = [value]
        object.arrayIntOptional = [value]
        object.arrayIntImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayInt.first, value)
        XCTAssertEqual(mappedObject?.arrayIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayIntImplicitlyUnwrapped.first, value)
    }

    func testMappingDoubleArrayToJSON(){
        let value: Double = 1.0
        let object = BasicTypes()
        object.arrayDouble = [value]
        object.arrayDoubleOptional = [value]
        object.arrayDoubleImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayDouble.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayDoubleImplicitlyUnwrapped.first, value)
    }

    func testMappingFloatArrayToJSON(){
        let value: Float = 1.001
        let object = BasicTypes()
        object.arrayFloat = [value]
        object.arrayFloatOptional = [value]
        object.arrayFloatImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayFloat.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayFloatImplicitlyUnwrapped.first, value)
    }

    func testMappingStringArrayToJSON(){
        let value: String = "Stringgggg"
        let object = BasicTypes()
        object.arrayString = [value]
        object.arrayStringOptional = [value]
        object.arrayStringImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayString.first, value)
        XCTAssertEqual(mappedObject?.arrayStringOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayStringImplicitlyUnwrapped.first, value)
    }

    func testMappingAnyObjectArrayToJSON(){
        let value: String = "Stringgggg"
        let object = BasicTypes()
        object.arrayAnyObject = [value]
        object.arrayAnyObjectOptional = [value]
        object.arrayAnyObjectImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayAnyObject.first as? String, value)
        XCTAssertEqual(mappedObject?.arrayAnyObjectOptional?.first as? String, value)
        XCTAssertEqual(mappedObject?.arrayAnyObjectImplicitlyUnwrapped.first as? String, value)
    }

    // MARK: Test mapping Dictionaries to JSON and back (with basic types in them Bool, Int, Double, Float, String)

    func testMappingEmptyDictionaryToJSON(){
        let object = BasicTypes()
        object.dictBool = [:]
        object.dictBoolOptional = [:]
        object.dictBoolImplicitlyUnwrapped = [:]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject!.dictBool, [:])
        XCTAssertEqual(mappedObject!.dictBoolOptional!, [:])
        XCTAssertEqual(mappedObject!.dictBoolImplicitlyUnwrapped, [:])
    }

    func testMappingBoolDictionaryToJSON(){
        let key = "key"
        let value: Bool = true
        let object = BasicTypes()
        object.dictBool = [key:value]
        object.dictBoolOptional = [key:value]
        object.dictBoolImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictBool[key], value)
        XCTAssertEqual(mappedObject?.dictBoolOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictBoolImplicitlyUnwrapped[key], value)
    }

    func testMappingIntDictionaryToJSON(){
        let key = "key"
        let value: Int = 11
        let object = BasicTypes()
        object.dictInt = [key:value]
        object.dictIntOptional = [key:value]
        object.dictIntImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictInt[key], value)
        XCTAssertEqual(mappedObject?.dictIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictIntImplicitlyUnwrapped[key], value)
    }

    func testMappingDoubleDictionaryToJSON(){
        let key = "key"
        let value: Double = 11
        let object = BasicTypes()
        object.dictDouble = [key:value]
        object.dictDoubleOptional = [key:value]
        object.dictDoubleImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictDouble[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictDoubleImplicitlyUnwrapped[key], value)
    }

    func testMappingFloatDictionaryToJSON(){
        let key = "key"
        let value: Float = 11
        let object = BasicTypes()
        object.dictFloat = [key:value]
        object.dictFloatOptional = [key:value]
        object.dictFloatImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictFloat[key], value)
        XCTAssertEqual(mappedObject?.dictFloatOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictFloatImplicitlyUnwrapped[key], value)
    }

    func testMappingStringDictionaryToJSON(){
        let key = "key"
        let value = "value"
        let object = BasicTypes()
        object.dictString = [key:value]
        object.dictStringOptional = [key:value]
        object.dictStringImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictString[key], value)
        XCTAssertEqual(mappedObject?.dictStringOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictStringImplicitlyUnwrapped[key], value)
    }

    func testMappingAnyObjectDictionaryToJSON(){
        let key = "key"
        let value = "value"
        let object = BasicTypes()
        object.dictAnyObject = [key:value]
        object.dictAnyObjectOptional = [key:value]
        object.dictAnyObjectImplicitlyUnwrapped = [key:value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictAnyObject[key] as? String, value)
        XCTAssertEqual(mappedObject?.dictAnyObjectOptional?[key] as? String, value)
        XCTAssertEqual(mappedObject?.dictAnyObjectImplicitlyUnwrapped[key] as? String, value)
    }

    func testMappingIntEnumToJSON(){
        let value = BasicTypes.EnumInt.Another
        let object = BasicTypes()
        object.enumInt = value
        object.enumIntOptional = value
        object.enumIntImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumInt, value)
        XCTAssertEqual(mappedObject?.enumIntOptional, value)
        XCTAssertEqual(mappedObject?.enumIntImplicitlyUnwrapped, value)
    }

    func testMappingDoubleEnumToJSON(){
        let value = BasicTypes.EnumDouble.Another
        let object = BasicTypes()
        object.enumDouble = value
        object.enumDoubleOptional = value
        object.enumDoubleImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumDouble, value)
        XCTAssertEqual(mappedObject?.enumDoubleOptional, value)
        XCTAssertEqual(mappedObject?.enumDoubleImplicitlyUnwrapped, value)
    }

    func testMappingFloatEnumToJSON(){
        let value = BasicTypes.EnumFloat.Another
        let object = BasicTypes()
        object.enumFloat = value
        object.enumFloatOptional = value
        object.enumFloatImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumFloat, value)
        XCTAssertEqual(mappedObject?.enumFloatOptional, value)
        XCTAssertEqual(mappedObject?.enumFloatImplicitlyUnwrapped, value)
    }

    func testMappingStringEnumToJSON(){
        let value = BasicTypes.EnumString.Another
        let object = BasicTypes()
        object.enumString = value
        object.enumStringOptional = value
        object.enumStringImplicitlyUnwrapped = value

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.enumString, value)
        XCTAssertEqual(mappedObject?.enumStringOptional, value)
        XCTAssertEqual(mappedObject?.enumStringImplicitlyUnwrapped, value)
    }

    func testMappingEnumIntArrayToJSON(){
        let value = BasicTypes.EnumInt.Another
        let object = BasicTypes()
        object.arrayEnumInt = [value]
        object.arrayEnumIntOptional = [value]
        object.arrayEnumIntImplicitlyUnwrapped = [value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.arrayEnumInt.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntOptional?.first, value)
        XCTAssertEqual(mappedObject?.arrayEnumIntImplicitlyUnwrapped.first, value)
    }

    func testMappingEnumIntDictionaryToJSON(){
        let key = "key"
        let value = BasicTypes.EnumInt.Another
        let object = BasicTypes()
        object.dictEnumInt = [key: value]
        object.dictEnumIntOptional = [key: value]
        object.dictEnumIntImplicitlyUnwrapped = [key: value]

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<BasicTypes>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.dictEnumInt[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntOptional?[key], value)
        XCTAssertEqual(mappedObject?.dictEnumIntImplicitlyUnwrapped[key], value)
    }

    func testObjectToModelDictionnaryOfPrimitives() {
        let object = TestCollectionOfPrimitives()
        object.dictStringString = ["string": "string"]
        object.dictStringBool = ["string": false]
        object.dictStringInt = ["string": 1]
        object.dictStringDouble = ["string": 1.2]
        object.dictStringFloat = ["string": 1.3]

        let json = object.toJSON()!

        XCTAssertTrue((json["dictStringString"] as? [String:String])?.count ?? 0 > 0)
        XCTAssertTrue((json["dictStringBool"] as? [String:Bool])?.count ?? 0 > 0)
        XCTAssertTrue((json["dictStringInt"] as? [String:Int])?.count ?? 0 > 0)
        XCTAssertTrue((json["dictStringDouble"] as? [String:Double])?.count ?? 0 > 0)
        XCTAssertTrue((json["dictStringFloat"] as? [String:Float])?.count ?? 0 > 0)
        XCTAssertEqual((json["dictStringString"] as? [String:String])?["string"], "string")
    }

    func testObjectInheritFromBasicTypesToModel() {
        let object = InheritanceBasicType()
        let value1 = 1
        let value2 = 2
        object.int = value1
        object.intOptional = value1
        object.intImplicitlyUnwrapped = value1
        object.anotherInt = value2
        object.anotherIntOptional = value2
        object.anotherIntImplicitlyUnwrapped = value2

        let JSONString = object.toJSONString(prettyPrint: true)
        let mappedObject = JSONDeserializer<InheritanceBasicType>.deserializeFrom(json: JSONString!)

        XCTAssertNotNil(mappedObject)
        XCTAssertEqual(mappedObject?.int, value1)
        XCTAssertEqual(mappedObject?.intOptional, value1)
        XCTAssertEqual(mappedObject?.intImplicitlyUnwrapped, value1)
        XCTAssertEqual(mappedObject?.anotherInt, value2)
        XCTAssertEqual(mappedObject?.anotherIntOptional, value2)
        XCTAssertEqual(mappedObject?.anotherIntImplicitlyUnwrapped, value2)
    }
}
