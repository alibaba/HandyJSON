//
//  GenericTypes.swift
//  HandyJSON
//
//  Created by chantu on 2019/3/27.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation
import HandyJSON

protocol OneProtocol: HandyJSON {
    func aFunc()
}

extension OneProtocol {
    func aFunc() {}
}

class AConformToOneProtocolClass: InheritEmptyOCClass, OneProtocol {
    var a1: Int?
    var a2: String?
    var a3: NSDictionary?
    var a4: TestCollectionOfPrimitives?
}

struct BConformToOneProtocolStruct: OneProtocol {
    var b1: Int64?
    var b2: Double?
}

struct GenericStruct<T: OneProtocol>: HandyJSON {
    var a: T?
}

class SuperGenericClass: OneProtocol {
    var s: String?

    required init() {}
}

class GenericClass<T: OneProtocol, U: InheritanceBasicType, V: HandyJSON, W: HandyJSON>: SuperGenericClass {
    var handyJSON: HandyJSON!
    var oneProtocol: T?
    var inheritanceBasicType: U?
    var basicTypesInClass: V?
    var basicTypesInStruct: BasicTypesInStruct?
    var genericStruct: W?
}
