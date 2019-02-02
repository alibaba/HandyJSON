//
//  FieldDescriptor.swift
//  HandyJSON
//
//  Created by chantu on 2019/1/31.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation

enum FieldDescriptorKind : UInt16 {
    // Swift nominal types.
    case Struct = 0
    case Class
    case Enum

    // Fixed-size multi-payload enums have a special descriptor format that
    // encodes spare bits.
    //
    // FIXME: Actually implement this. For now, a descriptor with this kind
    // just means we also have a builtin descriptor from which we get the
    // size and alignment.
    case MultiPayloadEnum

    // A Swift opaque protocol. There are no fields, just a record for the
    // type itself.
    case `Protocol`

    // A Swift class-bound protocol.
    case ClassProtocol

    // An Objective-C protocol, which may be imported or defined in Swift.
    case ObjCProtocol

    // An Objective-C class, which may be imported or defined in Swift.
    // In the former case, field type metadata is not emitted, and
    // must be obtained from the Objective-C runtime.
    case ObjCClass
}

struct FieldDescriptor: PointerType {

    var pointer: UnsafePointer<_FieldDescriptor>

    var fieldRecordSize: Int {
        return Int(pointer.pointee.fieldRecordSize)
    }

    var numFields: Int {
        return Int(pointer.pointee.numFields)
    }

    var fieldRecords: [FieldRecord] {
        return (0..<numFields).map({ (i) -> FieldRecord in
            return FieldRecord(pointer: UnsafePointer<_FieldRecord>(pointer + 1) + i)
        })
    }
}

struct _FieldDescriptor {
    var mangledTypeNameOffset: Int32
    var superClassOffset: Int32
    var fieldDescriptorKind: FieldDescriptorKind
    var fieldRecordSize: Int16
    var numFields: Int32
}

struct FieldRecord: PointerType {

    var pointer: UnsafePointer<_FieldRecord>

    var fieldRecordFlags: Int {
        return Int(pointer.pointee.fieldRecordFlags)
    }

    var mangledTypeName: UnsafePointer<UInt8>? {
        let address = Int(bitPattern: pointer) + 1 * 4
        let offset = Int(pointer.pointee.mangledTypeNameOffset)
        let cString = UnsafePointer<UInt8>(bitPattern: address + offset)
        return cString
    }

    var fieldName: String {
        let address = Int(bitPattern: pointer) + 2 * 4
        let offset = Int(pointer.pointee.fieldNameOffset)
        if let cString = UnsafePointer<UInt8>(bitPattern: address + offset) {
            return String(cString: cString)
        }
        return ""
    }
}

struct _FieldRecord {
    var fieldRecordFlags: Int32
    var mangledTypeNameOffset: Int32
    var fieldNameOffset: Int32
}
