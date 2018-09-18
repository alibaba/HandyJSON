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
}

protocol ContextDescriptorProtocol {
    var numberOfFields: Int { get }
    var fieldOffsetVector: Int { get }
}

struct ContextDescriptor<T: _ContextDescriptorProtocol>: ContextDescriptorProtocol, PointerType {

    var pointer: UnsafePointer<T>

    var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }

    var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }
}

protocol _ContextDescriptorProtocol {
    var mangledName: Int32 { get }
    var numberOfFields: Int32 { get }
    var fieldOffsetVector: Int32 { get }
    var fieldTypesAccessor: Int32 { get }
}

struct _StructContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledName: Int32
    var fieldTypesAccessor: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}

struct _ClassContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledName: Int32
    var fieldTypesAccessor: Int32
    var superClsRef: Int32
    var reservedWord1: Int32
    var reservedWord2: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}
