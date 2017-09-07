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
//  BasicTypesInStruct.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/09/2017.
//

import Foundation
import HandyJSON

struct BasicTypesInStruct: HandyJSON {
    var bool: Bool = true
    var boolOptional: Bool?
    var boolImplicitlyUnwrapped: Bool!
    var int: Int = 0
    var intOptional: Int?
    var intImplicitlyUnwrapped: Int!
    var double: Double = 0
    var doubleOptional: Double?
    var doubleImplicitlyUnwrapped: Double!
    var float: Float = 0
    var floatOptional: Float?
    var floatImplicitlyUnwrapped: Float!
    var string: String = ""
    var stringOptional: String?
    var stringImplicitlyUnwrapped: String!
    var anyObject: Any = true
    var anyObjectOptional: Any?
    var anyObjectImplicitlyUnwrapped: Any!

    var arrayBool: Array<Bool> = []
    var arrayBoolOptional: Array<Bool>?
    var arrayBoolImplicitlyUnwrapped: Array<Bool>!
    var arrayInt: Array<Int> = []
    var arrayIntOptional: Array<Int>?
    var arrayIntImplicitlyUnwrapped: Array<Int>!
    var arrayDouble: Array<Double> = []
    var arrayDoubleOptional: Array<Double>?
    var arrayDoubleImplicitlyUnwrapped: Array<Double>!
    var arrayFloat: Array<Float> = []
    var arrayFloatOptional: Array<Float>?
    var arrayFloatImplicitlyUnwrapped: Array<Float>!
    var arrayString: Array<String> = []
    var arrayStringOptional: Array<String>?
    var arrayStringImplicitlyUnwrapped: Array<String>!
    var arrayAnyObject: Array<Any> = []
    var arrayAnyObjectOptional: Array<Any>?
    var arrayAnyObjectImplicitlyUnwrapped: Array<Any>!

    var dictBool: Dictionary<String,Bool> = [:]
    var dictBoolOptional: Dictionary<String, Bool>?
    var dictBoolImplicitlyUnwrapped: Dictionary<String, Bool>!
    var dictInt: Dictionary<String,Int> = [:]
    var dictIntOptional: Dictionary<String,Int>?
    var dictIntImplicitlyUnwrapped: Dictionary<String,Int>!
    var dictDouble: Dictionary<String,Double> = [:]
    var dictDoubleOptional: Dictionary<String,Double>?
    var dictDoubleImplicitlyUnwrapped: Dictionary<String,Double>!
    var dictFloat: Dictionary<String,Float> = [:]
    var dictFloatOptional: Dictionary<String,Float>?
    var dictFloatImplicitlyUnwrapped: Dictionary<String,Float>!
    var dictString: Dictionary<String,String> = [:]
    var dictStringOptional: Dictionary<String,String>?
    var dictStringImplicitlyUnwrapped: Dictionary<String,String>!
    var dictAnyObject: Dictionary<String, Any> = [:]
    var dictAnyObjectOptional: Dictionary<String, Any>?
    var dictAnyObjectImplicitlyUnwrapped: Dictionary<String, Any>!

    var nsString: NSString = ""
    var nsStringOptional: NSString?
    var nsStringImplicitlyUnwrapped: NSString!

    var arrayNSString: Array<NSString> = []
    var arrayNSStringOptional: Array<NSString>?
    var arrayNSStringImplicitlyUnwrapped: Array<NSString>!

    var nsNumber: NSNumber = 0
    var nsNumberOptional: NSNumber?
    var nsNumberImplicitlyUnwrapped: NSNumber!

    var arrayNSNumber: Array<NSNumber> = []
    var arrayNSNumberOptional: Array<NSNumber>?
    var arrayNSNumberImplicitlyUnwrapped: Array<NSNumber>!

    var nsArray: NSArray = []
    var nsArrayOptional: NSArray?
    var nsArrayImplicitlyUnwrapped: NSArray!

    var nsDictionary: NSDictionary = [:]
    var nsDictionaryOptional: NSDictionary?
    var nsDictionaryImplicitlyUnwrapped: NSDictionary!

    enum EnumInt: Int, HandyJSONEnum {
        case Default
        case Another
    }
    var enumInt: EnumInt = .Default
    var enumIntOptional: EnumInt?
    var enumIntImplicitlyUnwrapped: EnumInt!

    enum EnumDouble: Double, HandyJSONEnum {
        case Default
        case Another
    }
    var enumDouble: EnumDouble = .Default
    var enumDoubleOptional: EnumDouble?
    var enumDoubleImplicitlyUnwrapped: EnumDouble!

    enum EnumFloat: Float, HandyJSONEnum {
        case Default
        case Another
    }
    var enumFloat: EnumFloat = .Default
    var enumFloatOptional: EnumFloat?
    var enumFloatImplicitlyUnwrapped: EnumFloat!

    enum EnumString: String, HandyJSONEnum {
        case Default = "Default"
        case Another = "Another"
    }
    var enumString: EnumString = .Default
    var enumStringOptional: EnumString?
    var enumStringImplicitlyUnwrapped: EnumString!

    var arrayEnumInt: [EnumInt] = []
    var arrayEnumIntOptional: [EnumInt]?
    var arrayEnumIntImplicitlyUnwrapped: [EnumInt]!

    var dictEnumInt: [String: EnumInt] = [:]
    var dictEnumIntOptional: [String: EnumInt]?
    var dictEnumIntImplicitlyUnwrapped: [String: EnumInt]!
}
