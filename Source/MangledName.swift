//
//  MangledName.swift
//  HandyJSON
//
//  Created by chantu on 2019/2/2.
//  Copyright © 2019 aliyun. All rights reserved.
//

import Foundation

 // mangled name might contain 0 but it is not the end, do not just use strlen
func getMangledTypeNameSize(_ mangledName: UnsafePointer<UInt8>) -> Int {
    // TODO: should find the actually size 
    return 256
}
