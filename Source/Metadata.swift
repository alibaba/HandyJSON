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

import Foundation

struct _class_rw_t {
    var flags: Int32
    var version: Int32
    var ro: UInt
    // other fields we don't care

    // reference: include/swift/Remote/MetadataReader.h/readObjcRODataPtr
    func class_ro_t() -> UnsafePointer<_class_ro_t>? {
        var addr: UInt = self.ro
        if (self.ro & UInt(1)) != 0 {
            if let ptr = UnsafePointer<UInt>(bitPattern: self.ro ^ 1) {
                addr = ptr.pointee
            }
        }
        return UnsafePointer<_class_ro_t>(bitPattern: addr)
    }
}

struct _class_ro_t {
    var flags: Int32
    var instanceStart: Int32
    var instanceSize: Int32
    // other fields we don't care
}

// MARK: MetadataType
protocol MetadataType : PointerType {
    static var kind: Metadata.Kind? { get }
}

extension MetadataType {

    var kind: Metadata.Kind {
        return Metadata.Kind(flag: UnsafePointer<Int>(pointer).pointee)
    }

    init?(anyType: Any.Type) {
        self.init(pointer: unsafeBitCast(anyType, to: UnsafePointer<Int>.self))
        if let kind = type(of: self).kind, kind != self.kind {
            return nil
        }
    }
}

// MARK: Metadata
struct Metadata : MetadataType {
    var pointer: UnsafePointer<Int>

    init(type: Any.Type) {
        self.init(pointer: unsafeBitCast(type, to: UnsafePointer<Int>.self))
    }
}

struct _Metadata {}

var is64BitPlatform: Bool {
    return MemoryLayout<Int>.size == MemoryLayout<Int64>.size
}

// MARK: Metadata + Kind
// include/swift/ABI/MetadataKind.def
let MetadataKindIsNonHeap = 0x200
let MetadataKindIsRuntimePrivate = 0x100
let MetadataKindIsNonType = 0x400
extension Metadata {
    static let kind: Kind? = nil

    enum Kind {
        case `struct`
        case `enum`
        case optional
        case opaque
        case foreignClass
        case tuple
        case function
        case existential
        case metatype
        case objCClassWrapper
        case existentialMetatype
        case heapLocalVariable
        case heapGenericLocalVariable
        case errorObject
        case `class` // The kind only valid for non-class metadata
        init(flag: Int) {
            switch flag {
            case (0 | MetadataKindIsNonHeap): self = .struct
            case (1 | MetadataKindIsNonHeap): self = .enum
            case (2 | MetadataKindIsNonHeap): self = .optional
            case (3 | MetadataKindIsNonHeap): self = .foreignClass
            case (0 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .opaque
            case (1 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .tuple
            case (2 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .function
            case (3 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .existential
            case (4 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .metatype
            case (5 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .objCClassWrapper
            case (6 | MetadataKindIsRuntimePrivate | MetadataKindIsNonHeap): self = .existentialMetatype
            case (0 | MetadataKindIsNonType): self = .heapLocalVariable
            case (0 | MetadataKindIsNonType | MetadataKindIsRuntimePrivate): self = .heapGenericLocalVariable
            case (1 | MetadataKindIsNonType | MetadataKindIsRuntimePrivate): self = .errorObject
            default: self = .class
            }
        }
    }
}

// MARK: Metadata + Class
extension Metadata {
    struct Class : ContextDescriptorType {

        static let kind: Kind? = .class
        var pointer: UnsafePointer<_Metadata._Class>

        var isSwiftClass: Bool {
            get {
                // see include/swift/Runtime/Config.h macro SWIFT_CLASS_IS_SWIFT_MASK
                // it can be 1 or 2 depending on environment
                let lowbit = self.pointer.pointee.rodataPointer & 3
                return lowbit != 0
            }
        }

        var contextDescriptorOffsetLocation: Int {
            return is64BitPlatform ? 8 : 11
        }

        var superclass: Class? {
            guard let superclass = pointer.pointee.superclass else {
                return nil
            }
            
            // ignore objc-runtime layer
            guard let metaclass = Metadata.Class(anyType: superclass) else {
                return nil
            }

            // If the superclass doesn't conform to handyjson/handyjsonenum protocol,
            // we should ignore the properties inside
            // Use metaclass.isSwiftClass to test if it is a swift class, if it is not return nil directly, or `superclass is HandyJSON.Type` wil crash.
            if !metaclass.isSwiftClass
                || (!(superclass is HandyJSON.Type) && !(superclass is HandyJSONEnum.Type)) {
                return nil
            }

            return metaclass
        }

        var vTableSize: Int {
            // memory size after ivar destroyer
            return Int(pointer.pointee.classObjectSize - pointer.pointee.classObjectAddressPoint) - (contextDescriptorOffsetLocation + 2) * MemoryLayout<Int>.size
        }

        // reference: https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#generic-argument-vector
        var genericArgumentVector: UnsafeRawPointer? {
            let pointer = UnsafePointer<Int>(self.pointer)
            var superVTableSize = 0
            if let _superclass = self.superclass {
                superVTableSize = _superclass.vTableSize / MemoryLayout<Int>.size
            }
            let base = pointer.advanced(by: contextDescriptorOffsetLocation + 2 + superVTableSize)
            if base.pointee == 0 {
                return nil
            }
            return UnsafeRawPointer(base)
        }

        func _propertyDescriptionsAndStartPoint() -> ([Property.Description], Int32?)? {
            let instanceStart = pointer.pointee.class_rw_t()?.pointee.class_ro_t()?.pointee.instanceStart
            var result: [Property.Description] = []
            if let fieldOffsets = self.fieldOffsets, let fieldRecords = self.reflectionFieldDescriptor?.fieldRecords {
                class NameAndType {
                    var name: String?
                    var type: Any.Type?
                }
                
                for i in 0..<self.numberOfFields {
                    let name = fieldRecords[i].fieldName
                    if let cMangledTypeName = fieldRecords[i].mangledTypeName,
                        let fieldType = _getTypeByMangledNameInContext(cMangledTypeName, getMangledTypeNameSize(cMangledTypeName), genericContext: self.contextDescriptorPointer, genericArguments: self.genericArgumentVector) {

                        result.append(Property.Description(key: name, type: fieldType, offset: fieldOffsets[i]))
                    }
                }
            }

            if let superclass = superclass,
                String(describing: unsafeBitCast(superclass.pointer, to: Any.Type.self)) != "SwiftObject",  // ignore the root swift object
                let superclassProperties = superclass._propertyDescriptionsAndStartPoint(),
                superclassProperties.0.count > 0 {

                return (superclassProperties.0 + result, superclassProperties.1)
            }
            return (result, instanceStart)
        }

        func propertyDescriptions() -> [Property.Description]? {
            let propsAndStp = _propertyDescriptionsAndStartPoint()
            if let firstInstanceStart = propsAndStp?.1,
                let firstProperty = propsAndStp?.0.first?.offset {
                    return propsAndStp?.0.map({ (propertyDesc) -> Property.Description in
                        let offset = propertyDesc.offset - firstProperty + Int(firstInstanceStart)
                        return Property.Description(key: propertyDesc.key, type: propertyDesc.type, offset: offset)
                    })
            } else {
                return propsAndStp?.0
            }
        }
    }
}

extension _Metadata {
    struct _Class {
        var kind: Int
        var superclass: Any.Type?
        var reserveword1: Int
        var reserveword2: Int
        var rodataPointer: UInt
        var classFlags: UInt32
        var instanceAddressPoint: UInt32
        var instanceSize: UInt32
        var instanceAlignmentMask: UInt16
        var runtimeReservedField: UInt16
        var classObjectSize: UInt32
        var classObjectAddressPoint: UInt32
        var nominalTypeDescriptor: Int
        var ivarDestroyer: Int
        // other fields we don't care

        func class_rw_t() -> UnsafePointer<_class_rw_t>? {
            if MemoryLayout<Int>.size == MemoryLayout<Int64>.size {
                let fast_data_mask: UInt64 = 0x00007ffffffffff8
                let databits_t: UInt64 = UInt64(self.rodataPointer)
                return UnsafePointer<_class_rw_t>(bitPattern: UInt(databits_t & fast_data_mask))
            } else {
                return UnsafePointer<_class_rw_t>(bitPattern: self.rodataPointer & 0xfffffffc)
            }
        }
    }
}

// MARK: Metadata + Struct
extension Metadata {
    struct Struct : ContextDescriptorType {
        static let kind: Kind? = .struct
        var pointer: UnsafePointer<_Metadata._Struct>
        var contextDescriptorOffsetLocation: Int {
            return 1
        }

        var genericArgumentOffsetLocation: Int {
            return 2
        }

        var genericArgumentVector: UnsafeRawPointer? {
            let pointer = UnsafePointer<Int>(self.pointer)
            let base = pointer.advanced(by: genericArgumentOffsetLocation)
            if base.pointee == 0 {
                return nil
            }
            return UnsafeRawPointer(base)
        }

        func propertyDescriptions() -> [Property.Description]? {
            guard let fieldOffsets = self.fieldOffsets, let fieldRecords = self.reflectionFieldDescriptor?.fieldRecords else {
                return []
            }
            var result: [Property.Description] = []
            class NameAndType {
                var name: String?
                var type: Any.Type?
            }
            for i in 0..<self.numberOfFields {
                let name = fieldRecords[i].fieldName
                if let cMangledTypeName = fieldRecords[i].mangledTypeName,
                    let fieldType = _getTypeByMangledNameInContext(cMangledTypeName, getMangledTypeNameSize(cMangledTypeName), genericContext: self.contextDescriptorPointer, genericArguments: self.genericArgumentVector) {

                    result.append(Property.Description(key: name, type: fieldType, offset: fieldOffsets[i]))
                }
            }
            return result
        }
    }
}

extension _Metadata {
    struct _Struct {
        var kind: Int
        var contextDescriptorOffset: Int
        var parent: Metadata?
    }
}

// MARK: Metadata + ObjcClassWrapper
extension Metadata {
    struct ObjcClassWrapper: ContextDescriptorType {
        static let kind: Kind? = .objCClassWrapper
        var pointer: UnsafePointer<_Metadata._ObjcClassWrapper>
        var contextDescriptorOffsetLocation: Int {
            return is64BitPlatform ? 8 : 11
        }

        var targetType: Any.Type? {
            get {
                return pointer.pointee.targetType
            }
        }
    }
}

extension _Metadata {
    struct _ObjcClassWrapper {
        var kind: Int
        var targetType: Any.Type?
    }
}
