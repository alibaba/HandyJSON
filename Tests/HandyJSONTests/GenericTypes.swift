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

class SuperGenericClassInheritGeneric<T: HandyJSON>: BaseGenericClass<BasicTypesInClass> {
    var str: String?
    var t: T?

    required init() {}
}

class SuperGenericClass<T: HandyJSON>: BasicTypesInClass {
    var str: String?
    var t: T?

    required init() {}
}

class SubGenericClassInheritGeneric<T: HandyJSON>: SuperGenericClassInheritGeneric<BasicTypesInClass> {
    var sub: T?

    required init() {}
}

class SubGenericClass<T: HandyJSON>: InheritanceBasicType {
    var sub: T?

    required init() {}
}

class GenericWithNormalClass<T: BasicTypesInClass>: HandyJSON {
    var t: T?

    required init() {}
}

class SubGenericClassInheritGenericWithNormalClass<T: BasicTypesInClass>: SuperGenericClassInheritGeneric<BasicTypesInClass> {
    var sub: T?

    required init() {}
}

class ComplicatedGenericClass<T: BasicTypesInClass, U: InheritanceBasicType, V: HandyJSON, W: HandyJSON>: SubGenericClassInheritGeneric<BasicTypesInClass> {
    var handyJSONProtocol1: V?
    var handyJSON: HandyJSON!
    var basicTypesInClass: T?
    var inheritanceBasicType: U?
    var basicTypesInStruct: BasicTypesInStruct?
    var handyJSONProtocol2: W?

    required init() {}
}
