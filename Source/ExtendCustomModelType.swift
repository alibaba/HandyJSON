//
//  ExtendCustomType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 16/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol _ExtendCustomModelType: _Transformable {
    init()
    mutating func mapping(mapper: HelpingMapper)
    mutating func didFinishMapping()
}

extension _ExtendCustomModelType {

    public mutating func mapping(mapper: HelpingMapper) {}
    public mutating func didFinishMapping() {}
}

fileprivate func convertKeyIfNeeded(dict: [String: Any]) -> [String: Any] {
    if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
        var newDict = [String: Any]()
        dict.forEach({ (key, value) in
            newDict[key.lowercased()] = value
        })
        return newDict
    }
    return dict
}

fileprivate func getRawValueFrom(dict: [String: Any], property: PropertyInfo, mapper: HelpingMapper) -> Any? {
    if let mappingHandler = mapper.getMappingHandler(key: property.address.hashValue) {
        if let mappingPaths = mappingHandler.mappingPaths, mappingPaths.count > 0 {
            for mappingPath in mappingPaths {
                if let _value = dict.findValueBy(path: mappingPath) {
                    return _value
                }
            }
            return nil
        }
    }
    if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
        return dict[property.key.lowercased()]
    }
    return dict[property.key]
}

fileprivate func convertValue(rawValue: Any, property: PropertyInfo, mapper: HelpingMapper) -> Any? {
    if let mappingHandler = mapper.getMappingHandler(key: property.address.hashValue), let transformer = mappingHandler.assignmentClosure {
        return transformer(rawValue)
    }
    if let transformableType = property.type as? _Transformable.Type {
        return transformableType.transform(from: rawValue)
    } else {
        return extensions(of: property.type).takeValue(from: rawValue)
    }
}

fileprivate func assignProperty(convertedValue: Any, instance: _ExtendCustomModelType, property: PropertyInfo) {
    if property.bridged {
        (instance as! NSObject).setValue(convertedValue, forKey: property.key)
    } else {
        extensions(of: property.type).write(convertedValue, to: property.address)
    }
}

fileprivate func readAllChildrenFrom(mirror: Mirror) -> [(String, Any)] {
    var children = [(label: String?, value: Any)]()
    let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
    children += mirrorChildrenCollection

    var currentMirror = mirror
    while let superclassChildren = currentMirror.superclassMirror?.children {
        let randomCollection = AnyRandomAccessCollection(superclassChildren)!
        children += randomCollection
        currentMirror = currentMirror.superclassMirror!
    }
    var result = [(String, Any)]()
    children.forEach { (child) in
        if let _label = child.label {
            result.append((_label, child.value))
        }
    }
    return result
}

fileprivate func merge(children: [(String, Any)], propertyInfos: [PropertyInfo]) -> [String: (Any, PropertyInfo?)] {
    var infoDict = [String: PropertyInfo]()
    propertyInfos.forEach { (info) in
        infoDict[info.key] = info
    }

    var result = [String: (Any, PropertyInfo?)]()
    children.forEach { (child) in
        result[child.0] = (child.1, infoDict[child.0])
    }
    return result
}

extension _ExtendCustomModelType {

    static func _transform(from object: Any) -> Self? {
        if let dict = object as? [String: Any] {
            // nested object, transform recursively
            return self._transform(dict: dict) as? Self
        }
        return nil
    }

    static func _transform(dict: [String: Any]) -> _ExtendCustomModelType? {
        var instance = Self.init()
        _transform(dict: dict, to: &instance)
        instance.didFinishMapping()
        return instance
    }

    static func _transform(dict: [String: Any], to instance: inout Self) {
        guard let properties = getProperties(forType: Self.self) else {
            InternalLogger.logDebug("Failed when try to get properties from type: \(type(of: Self.self))")
            return
        }

        // do user-specified mapping first
        let mapper = HelpingMapper()
        instance.mapping(mapper: mapper)

        // get head addr
        let rawPointer = instance.headPointer()
        InternalLogger.logVerbose("instance start at: ", rawPointer.hashValue)

        // process dictionary
        let _dict = convertKeyIfNeeded(dict: dict)

        let instanceIsNsObject = instance.isNSObjectType()
        let bridgedPropertyList = instance.getBridgedPropertyList()

        properties.forEach { (property) in
            let isBridgedProperty = instanceIsNsObject && bridgedPropertyList.contains(property.key)

            let propAddr = rawPointer.advanced(by: property.offset)
            InternalLogger.logVerbose(property.key, "address at: ", propAddr.hashValue)
            if mapper.propertyExcluded(key: propAddr.hashValue) {
                InternalLogger.logDebug("Exclude property: \(property.key)")
                return
            }

            let propertyDetail = PropertyInfo(key: property.key, type: property.type, address: propAddr, bridged: isBridgedProperty)
            InternalLogger.logVerbose("field: ", property.key, "  offset: ", property.offset, "  isBridgeProperty: ", isBridgedProperty)

            if let rawValue = getRawValueFrom(dict: _dict, property: propertyDetail, mapper: mapper) {
                if let convertedValue = convertValue(rawValue: rawValue, property: propertyDetail, mapper: mapper) {
                    assignProperty(convertedValue: convertedValue, instance: instance, property: propertyDetail)
                    return
                }
            }
            InternalLogger.logDebug("Property: \(property.key) hasn't been written in")
        }
    }
}

extension _ExtendCustomModelType {

    func _plainValue() -> Any? {
        return Self._serializeAny(object: self)
    }

    static func _serializeAny(object: _Transformable) -> Any? {

        let mirror = Mirror(reflecting: object)

        guard let displayStyle = mirror.displayStyle else {
            return object.plainValue()
        }

        // after filtered by protocols above, now we expect the type is pure struct/class
        switch displayStyle {
        case .class, .struct:
            let mapper = HelpingMapper()
            // do user-specified mapping first
            if !(object is _ExtendCustomModelType) {
                InternalLogger.logDebug("This model of type: \(type(of: object)) is not mappable but is class/struct type")
                return object
            }

            let children = readAllChildrenFrom(mirror: mirror)

            guard let properties = getProperties(forType: type(of: object)) else {
                InternalLogger.logError("Can not get properties info for type: \(type(of: object))")
                return nil
            }

            var mutableObject = object as! _ExtendCustomModelType
            let instanceIsNsObject = mutableObject.isNSObjectType()
            let head = mutableObject.headPointer()
            let bridgedProperty = mutableObject.getBridgedPropertyList()
            let propertyInfos = properties.map({ (desc) -> PropertyInfo in
                return PropertyInfo(key: desc.key, type: desc.type, address: head.advanced(by: desc.offset),
                                        bridged: instanceIsNsObject && bridgedProperty.contains(desc.key))
            })

            mutableObject.mapping(mapper: mapper)

            let requiredInfo = merge(children: children, propertyInfos: propertyInfos)

            return _serializeModelObject(instance: mutableObject, properties: requiredInfo, mapper: mapper) as Any
        default:
            return object.plainValue()
        }
    }

    static func _serializeModelObject(instance: _ExtendCustomModelType, properties: [String: (Any, PropertyInfo?)], mapper: HelpingMapper) -> [String: Any] {

        var dict = [String: Any]()
        for (key, property) in properties {
            var realKey = key
            var realValue = property.0

            if let info = property.1 {
                if info.bridged, let _value = (instance as! NSObject).value(forKey: key) {
                    realValue = _value
                }

                if mapper.propertyExcluded(key: info.address.hashValue) {
                    continue
                }

                if let mappingHandler = mapper.getMappingHandler(key: info.address.hashValue) {
                    // if specific key is set, replace the label
                    if let mappingPaths = mappingHandler.mappingPaths, mappingPaths.count > 0 {
                        // take the first path, last segment if more than one
                        realKey = mappingPaths[0].segments.last!
                    }

                    if let transformer = mappingHandler.takeValueClosure {
                        if let _transformedValue = transformer(realValue) {
                            dict[realKey] = _transformedValue
                        }
                        continue
                    }
                }
            }

            if let typedValue = realValue as? _Transformable {
                if let result = self._serializeAny(object: typedValue) {
                    dict[realKey] = result
                    continue
                }
            }

            InternalLogger.logDebug("The value for key: \(key) is not transformable type")
        }
        return dict
    }
}

