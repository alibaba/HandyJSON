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
//  BasicTypes.swift
//  HandyJSON
//
//  Created by zhouzhuo on 05/01/2017.
//

import HandyJSON

class BasicTypes: HandyJSON {
    var bool: Bool = true
    var boolOptional: Bool?
    var boolImplicityUnwrapped: Bool!
    var int: Int = 0
    var intOptional: Int?
    var intImplicityUnwrapped: Int!
    var double: Double = 1.1
    var doubleOptional: Double?
    var doubleImplicityUnwrapped: Double!
    var float: Float = 1.11
    var floatOptional: Float?
    var floatImplicityUnwrapped: Float!
    var string: String = ""
    var stringOptional: String?
    var stringImplicityUnwrapped: String!
    var anyObject: Any = true
    var anyObjectOptional: Any?
    var anyObjectImplicitlyUnwrapped: Any!

    var arrayBool: Array<Bool> = []
    var arrayBoolOptional: Array<Bool>?
    var arrayBoolImplicityUnwrapped: Array<Bool>!
    var arrayInt: Array<Int> = []
    var arrayIntOptional: Array<Int>?
    var arrayIntImplicityUnwrapped: Array<Int>!
    var arrayDouble: Array<Double> = []
    var arrayDoubleOptional: Array<Double>?
    var arrayDoubleImplicityUnwrapped: Array<Double>!
    var arrayFloat: Array<Float> = []
    var arrayFloatOptional: Array<Float>?
    var arrayFloatImplicityUnwrapped: Array<Float>!
    var arrayString: Array<String> = []
    var arrayStringOptional: Array<String>?
    var arrayStringImplicityUnwrapped: Array<String>!
    var arrayAnyObject: Array<Any> = []
    var arrayAnyObjectOptional: Array<Any>?
    var arrayAnyObjectImplicitlyUnwrapped: Array<Any>!

    var dictBool: Dictionary<String,Bool> = [:]
    var dictBoolOptional: Dictionary<String, Bool>?
    var dictBoolImplicityUnwrapped: Dictionary<String, Bool>!
    var dictInt: Dictionary<String,Int> = [:]
    var dictIntOptional: Dictionary<String,Int>?
    var dictIntImplicityUnwrapped: Dictionary<String,Int>!
    var dictDouble: Dictionary<String,Double> = [:]
    var dictDoubleOptional: Dictionary<String,Double>?
    var dictDoubleImplicityUnwrapped: Dictionary<String,Double>!
    var dictFloat: Dictionary<String,Float> = [:]
    var dictFloatOptional: Dictionary<String,Float>?
    var dictFloatImplicityUnwrapped: Dictionary<String,Float>!
    var dictString: Dictionary<String,String> = [:]
    var dictStringOptional: Dictionary<String,String>?
    var dictStringImplicityUnwrapped: Dictionary<String,String>!
    var dictAnyObject: Dictionary<String, Any> = [:]
    var dictAnyObjectOptional: Dictionary<String, Any>?
    var dictAnyObjectImplicitlyUnwrapped: Dictionary<String, Any>!

    enum EnumInt: Int, HandyJSONEnum {
        case Default
        case Another

        static func makeInitWrapper() -> InitWrapperProtocol {
            return InitWrapper<Int>(rawInit: self.init)
        }

        static func takeValueWrapper() -> TakeValueProtocol {
            return TakeValueWrapper<EnumInt>(takeValue: { $0.rawValue })
        }
    }
    var enumInt: EnumInt = .Default
    var enumIntOptional: EnumInt?
    var enumIntImplicitlyUnwrapped: EnumInt!

    enum EnumDouble: Double, HandyJSONEnum {
        case Default
        case Another

        static func makeInitWrapper() -> InitWrapperProtocol {
            return InitWrapper<Double>(rawInit: self.init)
        }

        static func takeValueWrapper() -> TakeValueProtocol {
            return TakeValueWrapper<EnumDouble>(takeValue: { $0.rawValue })
        }
    }
    var enumDouble: EnumDouble = .Default
    var enumDoubleOptional: EnumDouble?
    var enumDoubleImplicitlyUnwrapped: EnumDouble!

    enum EnumFloat: Float, HandyJSONEnum {
        case Default
        case Another

        static func makeInitWrapper() -> InitWrapperProtocol {
            return InitWrapper<Float>(rawInit: self.init)
        }

        static func takeValueWrapper() -> TakeValueProtocol {
            return TakeValueWrapper<EnumFloat>(takeValue: { $0.rawValue })
        }
    }
    var enumFloat: EnumFloat = .Default
    var enumFloatOptional: EnumFloat?
    var enumFloatImplicitlyUnwrapped: EnumFloat!

    enum EnumString: String, HandyJSONEnum {
        case Default = "Default"
        case Another = "Another"

        static func makeInitWrapper() -> InitWrapperProtocol {
            return InitWrapper<String>(rawInit: self.init)
        }

        static func takeValueWrapper() -> TakeValueProtocol {
            return TakeValueWrapper<EnumString>(takeValue: { $0.rawValue })
        }
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

    required init() {}
}

class TestCollectionOfPrimitives: HandyJSON {
    var dictStringString: [String: String] = [:]
    var dictStringInt: [String: Int] = [:]
    var dictStringBool: [String: Bool] = [:]
    var dictStringDouble: [String: Double] = [:]
    var dictStringFloat: [String: Float] = [:]

    var arrayString: [String] = []
    var arrayInt: [Int] = []
    var arrayBool: [Bool] = []
    var arrayDouble: [Double] = []
    var arrayFloat: [Float] = []

    required init() {}
}
