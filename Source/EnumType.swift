//
//  EnumType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 16/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol _RawEnumProtocol: _Transformable {

    static func _transform(from object: Any, transformer: _Transformer?) -> Self?
    func _plainValue(transformer: _Transformer?) -> Any?
}

extension RawRepresentable where Self: _RawEnumProtocol {

    public static func _transform(from object: Any, transformer: _Transformer?) -> Self? {
        if let result = transformer?.transform(from: object, type: self) {
            return result
        }
        if let transformableType = RawValue.self as? _Transformable.Type {
            if let typedValue = transformableType.transform(from: object, transformer: transformer) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }

    public func _plainValue(transformer: _Transformer?) -> Any? {
        if let result = transformer?.plainValue(from: self) {
            return result
        }
        return self.rawValue
    }
}
