//
//  Transformable.swift
//  HandyJSON
//
//  Created by zhouzhuo on 15/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol _Transformable: _Measurable {}

extension _Transformable {

    public static func transform(from object: Any, transformer: _Transformer?) -> Self? {
        if let typedObject = object as? Self {
            return typedObject
        }
        switch self {
        case let type as _ExtendCustomBasicType.Type:
            return type._transform(from: object, transformer: transformer) as? Self
        case let type as _BuiltInBridgeType.Type:
            return type._transform(from: object, transformer: transformer) as? Self
        case let type as _BuiltInBasicType.Type:
            return type._transform(from: object, transformer: transformer) as? Self
        case let type as _RawEnumProtocol.Type:
            return type._transform(from: object, transformer: transformer) as? Self
        case let type as _ExtendCustomModelType.Type:
            return type._transform(from: object, transformer: transformer) as? Self
        default:
            return nil
        }
    }

    public func plainValue(transformer: _Transformer?) -> Any? {
        switch self {
        case let rawValue as _ExtendCustomBasicType:
            return rawValue._plainValue(transformer: transformer)
        case let rawValue as _BuiltInBridgeType:
            return rawValue._plainValue(transformer: transformer)
        case let rawValue as _BuiltInBasicType:
            return rawValue._plainValue(transformer: transformer)
        case let rawValue as _RawEnumProtocol:
            return rawValue._plainValue(transformer: transformer)
        case let rawValue as _ExtendCustomModelType:
            return rawValue._plainValue(transformer: transformer)
        default:
            return nil
        }
    }
}

