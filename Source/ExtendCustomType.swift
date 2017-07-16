//
//  ExtendCustomType.swift
//  HandyJSON
//
//  Created by zhouzhuo on 16/07/2017.
//  Copyright © 2017 aliyun. All rights reserved.
//

import Foundation

public protocol _ExtendCustomType: _Transformable {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

extension _ExtendCustomType {

    public mutating func mapping(mapper: HelpingMapper) {}
}

extension _ExtendCustomType {

    static func _transform(from object: NSObject) -> Self? {
        if let dict = object as? NSDictionary {
            // nested object, transform recursively
            return self._transform(dict: dict, toType: self) as? Self
        }
        return nil
    }

    static func _transform(dict: NSDictionary, toType: _ExtendCustomType.Type) -> _ExtendCustomType? {
        var instance = toType.init()

        guard let properties = getProperties(forType: toType) else {
            InternalLogger.logDebug("Failed when try to get properties from type: \(type(of: toType))")
            return nil
        }

        let mapper = HelpingMapper()
        // do user-specified mapping first
        instance.mapping(mapper: mapper)

        let rawPointer: UnsafeMutableRawPointer
        if toType is AnyClass {
            rawPointer = UnsafeMutableRawPointer(instance.headPointerOfClass())
        } else {
            rawPointer = UnsafeMutableRawPointer(instance.headPointerOfStruct())
        }

        InternalLogger.logVerbose("instance start at: ", rawPointer.hashValue)

        var _dict = dict
        if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
            let newDict = NSMutableDictionary()
            dict.allKeys.forEach({ (key) in
                if let sKey = key as? String {
                    newDict[sKey.lowercased()] = dict[key]
                } else {
                    newDict[key] = dict[key]
                }
            })
            _dict = newDict
        }

        properties.forEach { (property) in
            _transform(rawPointer: rawPointer, property: property, dict: _dict, mapper: mapper)
            InternalLogger.logVerbose("field: ", property.key, "  offset: ", property.offset)
        }

        return instance
    }

    static func _transform(rawPointer: UnsafeMutableRawPointer, property: Property.Description, dict: NSDictionary, mapper: HelpingMapper) {
        var key = property.key

        if HandyJSONConfiguration.deserializeOptions.contains(.caseInsensitive) {
            key = key.lowercased()
        }

        let mutablePointer = rawPointer.advanced(by: property.offset)

        InternalLogger.logVerbose(key, "address at: ", mutablePointer.hashValue)
        if mapper.propertyExcluded(key: mutablePointer.hashValue) {
            InternalLogger.logDebug("Exclude property: \(key)")
            return
        }

        var maybeValue: Any? = nil

        if let mappingHandler = mapper.getMappingHandler(key: mutablePointer.hashValue) {
            if let mappingNames = mappingHandler.mappingNames, mappingNames.count > 0 {
                for mappingName in mappingNames {
                    if let _value = dict[mappingName] {
                        maybeValue = _value
                        break
                    }
                }
            } else {
                maybeValue = dict[key]
            }

            if let transformer = mappingHandler.assignmentClosure {
                // execute the transform closure
                transformer(maybeValue)
                return
            }
        } else {
            maybeValue = dict[key]
        }

        guard let rawValue = maybeValue as? NSObject else {
            InternalLogger.logDebug("Can not find a value from dictionary for property: \(key)")
            return
        }

        if let transformableType = property.type as? _Transformable.Type {
            if let sv = transformableType.transform(from: rawValue) {
                extensions(of: transformableType).write(sv, to: mutablePointer)
                return
            }
        } else {
            if let sv = extensions(of: property.type).takeValue(from: rawValue) {
                extensions(of: property.type).write(sv, to: mutablePointer)
                return
            }
        }
        InternalLogger.logDebug("Property: \(property.key) hasn't been written in")
    }
}

extension _ExtendCustomType {

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
            if !(object is _ExtendCustomType) {
                InternalLogger.logDebug("This model of type: \(type(of: object)) is not mappable but is class/struct type")
                return object
            }
            var mutableObject = object as! _ExtendCustomType
            mutableObject.mapping(mapper: mapper)

            let rawPointer: UnsafeMutableRawPointer
            if type(of: object) is AnyClass {
                rawPointer = UnsafeMutableRawPointer(mutableObject.headPointerOfClass())
            } else {
                rawPointer = UnsafeMutableRawPointer(mutableObject.headPointerOfStruct())
            }

            var children = [(label: String?, value: Any)]()
            let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children)!
            children += mirrorChildrenCollection

            var currentMirror = mirror
            while let superclassChildren = currentMirror.superclassMirror?.children {
                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
                children += randomCollection
                currentMirror = currentMirror.superclassMirror!
            }

            var offsetInfo = [String: Int]()
            guard let properties = getProperties(forType: type(of: object)) else {
                InternalLogger.logError("Can not get properties info for type: \(type(of: object))")
                return nil
            }

            properties.forEach({ (desc) in
                offsetInfo[desc.key] = desc.offset
            })

            return _serializeModelObject(propertys: children, headPointer: rawPointer, offsetInfo: offsetInfo, mapper: mapper) as Any
        default:
            return object.plainValue()
        }
    }

    static func _serializeModelObject(propertys: [(String?, Any)], headPointer: UnsafeMutableRawPointer, offsetInfo: [String: Int] , mapper: HelpingMapper) -> [String: Any] {

        var dict = [String: Any]()
        for (label, value) in propertys {

            var key = label ?? ""

            guard let offset = offsetInfo[key] else {
                InternalLogger.logDebug("Can not find offset info for property: \(key)")
                continue
            }

            let mutablePointer = headPointer.advanced(by: offset)

            if mapper.propertyExcluded(key: mutablePointer.hashValue) {
                continue
            }

            if let mappingHandler = mapper.getMappingHandler(key: mutablePointer.hashValue) {
                // if specific key is set, replace the label
                if let mappingNames = mappingHandler.mappingNames, mappingNames.count > 0 {
                    // take the first if more than one
                    key = mappingNames[0]
                }

                if let transformer = mappingHandler.takeValueClosure {
                    if let _transformedValue = transformer(value) {
                        dict[key] = _transformedValue
                    }
                    continue
                }
            }

            if let typedValue = value as? _Transformable {
                if let result = self._serializeAny(object: typedValue) {
                    dict[key] = result
                    continue
                }
            }

            InternalLogger.logDebug("The value for key: \(key) is not transformable type")
        }
        return dict
    }
}

