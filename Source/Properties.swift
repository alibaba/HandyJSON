/*
 * Copyright 1999-2101 Alibaba Group.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  Created by zhouzhuo on 07/01/2017.
//


/// An instance property
struct Property {
    let key: String
    let value: Any

    /// An instance property description
    struct Description {
        public let key: String
        public let type: Any.Type
        public let offset: Int
        public func write(_ value: Any, to storage: UnsafeMutableRawPointer) {
            return extensions(of: type).write(value, to: storage.advanced(by: offset))
        }
    }

    struct Context {
        public var name: String?
        public var type: Any.Type?
        public func isSuccess() -> Bool {
            if name == nil || type == nil {
                return false
            } else {
                return true
            }
        }
    }
}

/// Retrieve properties for `instance`
func getProperties(forInstance instance: Any) -> [Property]? {
    if let props = getProperties(forType: type(of: instance)) {
        var copy = extensions(of: instance)
        let storage = copy.storage()
        return props.map {
            nextProperty(description: $0, storage: storage)
        }
    }
    return nil
}

private func nextProperty(description: Property.Description, storage: UnsafeRawPointer) -> Property {
    return Property(
        key: description.key,
        value: extensions(of: description.type).value(from: storage.advanced(by: description.offset))
    )
}

/// Retrieve property descriptions for `type`
func getProperties(forType type: Any.Type) -> [Property.Description]? {
    if let contextDescriptorType = Metadata.Struct(anyType: type) {
        if let fieldOffsets = getFieldOffsets(contextDescriptorType: contextDescriptorType) {
            return getPropertyDescriptions(from: fieldOffsets, instanceType: type)
        } else {
            return nil
        }
    } else if let contextDescriptorType = Metadata.Class(anyType: type) {
        if let fieldOffsets = contextDescriptorType.fieldOffsets() {
            return getPropertyDescriptions(from: fieldOffsets, instanceType: type)
        } else {
            return nil
        }
    } else if let contextDescriptorType = Metadata.ObjcClassWrapper(anyType: type),
        let targetType = contextDescriptorType.targetType {
        return getProperties(forType: targetType)
    } else {
        return nil
    }
}

func getPropertyDescriptions(from fieldOffsets: [Int], instanceType type: Any.Type) -> [Property.Description]? {
    var propertyDescriptions = [Property.Description]()
    for i in 0..<fieldOffsets.count {
        var propertyContext = Property.Context()
        _getFieldAt(type, i, { name, type, ctx in
            let fieldName = String(cString: name)
            let type = unsafeBitCast(type, to: Any.Type.self)
            ctx.assumingMemoryBound(to: Property.Context.self).pointee.name = fieldName
            ctx.assumingMemoryBound(to: Property.Context.self).pointee.type = type
        }, &propertyContext)
        guard propertyContext.isSuccess() else {
            return nil
        }
        let propertyDescription = Property.Description(key: propertyContext.name!, type: propertyContext.type!, offset: fieldOffsets[i])
        propertyDescriptions.append(propertyDescription)
    }
    return propertyDescriptions
}

func getFieldOffsets<T: ContextDescriptorType>(contextDescriptorType type: T) -> [Int]? {
    guard type.numberOfFields != 0 else {
        return []
    }
    guard let fieldOffsets = type.fieldOffsets else {
        return nil
    }
    return (0..<type.numberOfFields).map { i in
        return fieldOffsets[i]
    }
}
