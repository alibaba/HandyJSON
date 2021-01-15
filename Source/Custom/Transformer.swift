//
//  Transformer.swift
//  HandyJSON
//
//  Created by 熊朝伟 on 2021/1/15.
//

import Foundation

public protocol _Transformer {
    func transform<K,V>(from object: Any, type: [K:V].Type) -> [K:V]?
    func transform<T>(from object: Any, type: [T].Type) -> [T]?
    func transform<T>(from object: Any, type: T.Type) -> T?
    func plainValue<T>(from object: T) -> Any?
}

extension _Transformer {
    public func transform<K,V>(from object: Any, type: [K:V].Type) -> [K:V]? { nil }
    public func transform<T>(from object: Any, type: [T].Type) -> [T]? { nil }
    public func transform<T>(from object: Any, type: T.Type) -> T? { nil }
    public func plainValue<T>(from object: T) -> Any? { nil }
}
