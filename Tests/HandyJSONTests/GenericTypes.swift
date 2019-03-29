//
//  GenericTypes.swift
//  HandyJSON
//
//  Created by chantu on 2019/3/27.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation
import HandyJSON

struct GenericStruct<T: HandyJSON>: HandyJSON {
    var t: T?
}

class BaseGenericClass<T: HandyJSON>: HandyJSON {
    var base: T?
    required init() {}
}

class SuperGenericClass<T: HandyJSON>: BaseGenericClass<BasicTypesInClass> {
    var str: String?
    var t: T?

    required init() {}
}

class ComplecatedGenericClass<T: HandyJSON, U: InheritanceBasicType, V: HandyJSON, W: HandyJSON>: SuperGenericClass<BasicTypesInClass> {
    var handyJSON: HandyJSON!
    var oneProtocol: T?
    var inheritanceBasicType: U?
    var basicTypesInClass: V?
    var basicTypesInStruct: BasicTypesInStruct?
    var genericStruct: W?

    required init() {}
}
