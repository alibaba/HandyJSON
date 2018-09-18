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

struct _class_rw_t {
    var flags: Int32
    var version: Int32
    var ro: UInt
    // other fields we don't care

    func class_ro_t() -> UnsafePointer<_class_ro_t>? {
        return UnsafePointer<_class_ro_t>(bitPattern: self.ro)
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
// https://github.com/apple/swift/blob/swift-3.0-branch/include/swift/ABI/MetadataKind.def
extension Metadata {
    static let kind: Kind? = nil

    enum Kind {
        case `struct`
        case `enum`
        case optional
        case opaque
        case tuple
        case function
        case existential
        case metatype
        case objCClassWrapper
        case existentialMetatype
        case foreignClass
        case heapLocalVariable
        case heapGenericLocalVariable
        case errorObject
        case `class`
        init(flag: Int) {
            switch flag {
            case 1: self = .struct
            case 2: self = .enum
            case 3: self = .optional
            case 8: self = .opaque
            case 9: self = .tuple
            case 10: self = .function
            case 12: self = .existential
            case 13: self = .metatype
            case 14: self = .objCClassWrapper
            case 15: self = .existentialMetatype
            case 16: self = .foreignClass
            case 64: self = .heapLocalVariable
            case 65: self = .heapGenericLocalVariable
            case 128: self = .errorObject
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
                let lowbit = self.pointer.pointee.databits & 1
                return lowbit == 1
            }
        }

        var contextDescriptorOffsetLocation: Int {
            return is64BitPlatform ? 8 : 11
        }

        var superclass: Class? {
            guard let superclass = pointer.pointee.superclass else {
                return nil
            }

            // If the superclass doesn't conform to handyjson/handyjsonenum protocol,
            // we should ignore the properties inside
            if !(superclass is HandyJSON.Type) && !(superclass is HandyJSONEnum.Type) {
                return nil
            }

            // ignore objc-runtime layer
            guard let metaclass = Metadata.Class(anyType: superclass), metaclass.isSwiftClass else {
                return nil
            }

            return metaclass
        }

        func _propertyDescriptionsAndStartPoint() -> ([Property.Description], Int32?)? {
            let instanceStart = pointer.pointee.class_rw_t()?.pointee.class_ro_t()?.pointee.instanceStart
            var result: [Property.Description] = []
            let selfType = unsafeBitCast(self.pointer, to: Any.Type.self)
            if let offsets = self.fieldOffsets {
                class NameAndType {
                    var name: String?
                    var type: Any.Type?
                }
                for i in 0..<self.numberOfFields {
                    var nameAndType = NameAndType()
                    _getFieldAt(selfType, i, { (name, type, nameAndTypePtr) in
                        let name = String(cString: name)
                        let type = unsafeBitCast(type, to: Any.Type.self)
                        nameAndTypePtr.assumingMemoryBound(to: NameAndType.self).pointee.name = name
                        nameAndTypePtr.assumingMemoryBound(to: NameAndType.self).pointee.type = type
                    }, &nameAndType)
                    if let name = nameAndType.name, let type = nameAndType.type {
                        result.append(Property.Description(key: name, type: type, offset: offsets[i]))
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
        var databits: UInt
        // other fields we don't care

        func class_rw_t() -> UnsafePointer<_class_rw_t>? {
            if MemoryLayout<Int>.size == MemoryLayout<Int64>.size {
                let fast_data_mask: UInt64 = 0x00007ffffffffff8
                let databits_t: UInt64 = UInt64(self.databits)
                return UnsafePointer<_class_rw_t>(bitPattern: UInt(databits_t & fast_data_mask))
            } else {
                return UnsafePointer<_class_rw_t>(bitPattern: self.databits & 0xfffffffc)
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

        func propertyDescriptions() -> [Property.Description]? {
            guard let fieldOffsets = self.fieldOffsets else {
                return []
            }
            var result: [Property.Description] = []
            let selfType = unsafeBitCast(self.pointer, to: Any.Type.self)
            class NameAndType {
                var name: String?
                var type: Any.Type?
            }
            for i in 0..<self.numberOfFields {
                var nameAndType = NameAndType()
                _getFieldAt(selfType, i, { (name, type, nameAndTypePtr) in
                    let name = String(cString: name)
                    let type = unsafeBitCast(type, to: Any.Type.self)
                    let nameAndType = nameAndTypePtr.assumingMemoryBound(to: NameAndType.self).pointee
                    nameAndType.name = name
                    nameAndType.type = type
                }, &nameAndType)
                if let name = nameAndType.name, let type = nameAndType.type {
                    result.append(Property.Description(key: name, type: type, offset: fieldOffsets[i]))
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
