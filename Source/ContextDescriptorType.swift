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

protocol ContextDescriptorType : MetadataType {
    var contextDescriptorOffsetLocation: Int { get }
}

extension ContextDescriptorType {

    var contextDescriptor: ContextDescriptorProtocol? {
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: contextDescriptorOffsetLocation)
        if base.pointee == 0 {
            // swift class created dynamically in objc-runtime didn't have valid contextDescriptor
            return nil
        }
        if self.kind == .class {
            return ContextDescriptor<_ClassContextDescriptor>(pointer: relativePointer(base: base, offset: base.pointee - Int(bitPattern: base)))
        } else {
            return ContextDescriptor<_StructContextDescriptor>(pointer: relativePointer(base: base, offset: base.pointee - Int(bitPattern: base)))
        }
    }

    var contextDescriptorPointer: UnsafeRawPointer? {
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: contextDescriptorOffsetLocation)
        if base.pointee == 0 {
            return nil
        }
        return UnsafeRawPointer(bitPattern: base.pointee)
    }

//    var genericArgumentVector: UnsafeRawPointer? {
//        let pointer = UnsafePointer<Int>(self.pointer)
//        let base = pointer.advanced(by: 19)
//        if base.pointee == 0 {
//            return nil
//        }
//        return UnsafeRawPointer(base)
//    }

    var mangledName: String {
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: contextDescriptorOffsetLocation)
        let mangledNameAddress = base.pointee + 2 * 4 // 2 properties in front
        if let offset = contextDescriptor?.mangledName,
            let cString = UnsafePointer<UInt8>(bitPattern: mangledNameAddress + offset) {
            return String(cString: cString)
        }
        return ""
    }

    var numberOfFields: Int {
        return contextDescriptor?.numberOfFields ?? 0
    }

    var fieldOffsets: [Int]? {
        guard let contextDescriptor = self.contextDescriptor else {
            return nil
        }
        let vectorOffset = contextDescriptor.fieldOffsetVector
        guard vectorOffset != 0 else {
            return nil
        }
        if self.kind == .class {
            return (0..<contextDescriptor.numberOfFields).map {
                return UnsafePointer<Int>(pointer)[vectorOffset + $0]
            }
        } else {
            return (0..<contextDescriptor.numberOfFields).map {
                return Int(UnsafePointer<Int32>(pointer)[vectorOffset * (is64BitPlatform ? 2 : 1) + $0])
            }
        }
    }

    var reflectionFieldDescriptor: FieldDescriptor? {
        guard let contextDescriptor = self.contextDescriptor else {
            return nil
        }
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: contextDescriptorOffsetLocation)
        let offset = contextDescriptor.reflectionFieldDescriptor
        let address = base.pointee + 4 * 4 // (4 properties in front) * (sizeof Int32)
        guard let fieldDescriptorPtr = UnsafePointer<_FieldDescriptor>(bitPattern: address + offset) else {
            return nil
        }
        return FieldDescriptor(pointer: fieldDescriptorPtr)
    }
}

protocol ContextDescriptorProtocol {
    var mangledName: Int { get }
    var numberOfFields: Int { get }
    var fieldOffsetVector: Int { get }
    var reflectionFieldDescriptor: Int { get }
}

struct ContextDescriptor<T: _ContextDescriptorProtocol>: ContextDescriptorProtocol, PointerType {

    var pointer: UnsafePointer<T>

    var mangledName: Int {
        return Int(pointer.pointee.mangledNameOffset)
    }

    var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }

    var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }

    var fieldTypesAccessor: Int {
        return Int(pointer.pointee.fieldTypesAccessor)
    }

    var reflectionFieldDescriptor: Int {
        return Int(pointer.pointee.reflectionFieldDescriptor)
    }
}

protocol _ContextDescriptorProtocol {
    var mangledNameOffset: Int32 { get }
    var numberOfFields: Int32 { get }
    var fieldOffsetVector: Int32 { get }
    var fieldTypesAccessor: Int32 { get }
    var reflectionFieldDescriptor: Int32 { get }
}

struct _StructContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledNameOffset: Int32
    var fieldTypesAccessor: Int32
    var reflectionFieldDescriptor: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}

struct _ClassContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledNameOffset: Int32
    var fieldTypesAccessor: Int32
    var reflectionFieldDescriptor: Int32
    var superClsRef: Int32
    var metadataNegativeSizeInWords: Int32
    var metadataPositiveSizeInWords: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}
