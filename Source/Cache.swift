//
//  Cache.swift
//  HandyJSON
//
//  Created by xuyecan on 2019/5/9.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation

internal var _propertyCache = [String:[Property.Description]]()

internal func getPropertiesFromCached(type: Any, computeIfAbsent: () -> [Property.Description]?) -> [Property.Description]? {
    let typeName = String(reflecting: type)
    if let props = _propertyCache[typeName] {
        return props
    }
    if let askFor = computeIfAbsent() {
        print("typeName: ", typeName)
        _propertyCache[typeName] = askFor
        return askFor
    }
    return nil
}
