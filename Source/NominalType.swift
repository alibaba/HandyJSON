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


protocol NominalType : MetadataType {
    var nominalTypeDescriptorOffsetLocation: Int { get }
}

extension NominalType {
    var nominalTypeDescriptor: NominalTypeDescriptor? {
        let pointer = UnsafePointer<Int>(self.pointer)
        let base = pointer.advanced(by: nominalTypeDescriptorOffsetLocation)
        if base.pointee == 0 {
            // swift class created dynamically in objc-runtime didn't have valid nominalTypeDescriptor
            return nil
        }
        #if swift(>=4.1) || (swift(>=3.3) && !swift(>=4.0))
        return NominalTypeDescriptor(pointer: relativePointer(base: base, offset: base.pointee - base.hashValue))
        #else
        return NominalTypeDescriptor(pointer: relativePointer(base: base, offset: base.pointee))
        #endif
    }

    var fieldTypes: [Any.Type]? {
        guard let nominalTypeDescriptor = self.nominalTypeDescriptor else {
            return nil
        }
        guard let function = nominalTypeDescriptor.fieldTypesAccessor else { return nil }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return unsafeBitCast(function(UnsafePointer<Int>(pointer)).advanced(by: $0).pointee, to: Any.Type.self)
        }
    }

    var fieldOffsets: [Int]? {
        guard let nominalTypeDescriptor = self.nominalTypeDescriptor else {
            return nil
        }
        let vectorOffset = nominalTypeDescriptor.fieldOffsetVector
        guard vectorOffset != 0 else {
            return nil
        }
        return (0..<nominalTypeDescriptor.numberOfFields).map {
            return UnsafePointer<Int>(pointer)[vectorOffset + $0]
        }
    }
}

struct NominalTypeDescriptor : PointerType {
    public var pointer: UnsafePointer<_NominalTypeDescriptor>

    var mangledName: String {
        return String(cString: relativePointer(base: pointer, offset: pointer.pointee.mangledName) as UnsafePointer<CChar>)
    }

    var numberOfFields: Int {
        return Int(pointer.pointee.numberOfFields)
    }

    var fieldOffsetVector: Int {
        return Int(pointer.pointee.fieldOffsetVector)
    }

    var fieldNames: [String] {
        let p = UnsafePointer<Int32>(self.pointer)
        return Array(utf8Strings: relativePointer(base: p.advanced(by: 3), offset: self.pointer.pointee.fieldNames))
    }

    typealias FieldsTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<UnsafePointer<Int>>

    var fieldTypesAccessor: FieldsTypeAccessor? {
        let offset = pointer.pointee.fieldTypesAccessor
        guard offset != 0 else {
            return nil
        }
        let p = UnsafePointer<Int32>(self.pointer)
        let offsetPointer: UnsafePointer<Int> = relativePointer(base: p.advanced(by: 4), offset: offset)
        return unsafeBitCast(offsetPointer, to: FieldsTypeAccessor.self)
    }
}

struct _NominalTypeDescriptor {
    var mangledName: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
    var fieldNames: Int32
    var fieldTypesAccessor: Int32
}
