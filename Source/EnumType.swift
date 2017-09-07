//
//  EnumType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 16/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol _RawEnumProtocol: _Transformable {

    static func _transform(from object: Any) -> Self?
    func _plainValue() -> Any?
}

extension RawRepresentable where Self: _RawEnumProtocol {

    public static func _transform(from object: Any) -> Self? {
        if let transformableType = RawValue.self as? _Transformable.Type {
            if let typedValue = transformableType.transform(from: object) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }

    public func _plainValue() -> Any? {
        return self.rawValue
    }
}
