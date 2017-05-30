//
//  TestUtils.swift
//  HandyJSON
//
//  Created by zhouzhuo on 10/12/2016.
//  Copyright © 2016 aliyun. All rights reserved.
//

import Foundation
import XCTest

func stringCompareHelper(_ actual: String?, _ expected: String?) {
    // print(actual ?? "")
    // print(expected ?? "")
    XCTAssertTrue(expected == actual, "expected value:\(expected ?? "nil") not equal to actual:\(actual ?? "nil")")
}

fileprivate func toJSONObject(_ string: String?) -> NSObject? {
    guard let _string = string else {
        return nil
    }
    if let rawData = (_string as NSString).data(using: String.Encoding.utf8.rawValue) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: rawData, options: []) as? NSObject {
            return jsonObject
        }
    }
    return nil
}

fileprivate func compareJSONObject(_ left: NSObject?, _ right: NSObject?) -> Bool {
    if left == nil {
        return right == nil
    }
    if let leftDict = left as? NSDictionary {
        if let rightDict = right as? NSDictionary {
            for key in leftDict.allKeys {
                if !compareJSONObject(leftDict[key] as? NSObject, rightDict[key] as? NSObject) {
                    return false
                }
            }
            for key in rightDict.allKeys {
                if !compareJSONObject(leftDict[key] as? NSObject, rightDict[key] as? NSObject) {
                    return false
                }
            }
            return true
        }
    } else if let leftArray = left as? NSArray {
        if let rightArray = right as? NSArray {
            for u in leftArray {
                var found = false
                for v in rightArray {
                    if compareJSONObject(u as? NSObject, v as? NSObject) {
                        found = true
                    }
                }
                if !found {
                    return false
                }
            }
            for v in rightArray {
                var found = false
                for u in leftArray {
                    if compareJSONObject(u as? NSObject, v as? NSObject) {
                        found = true
                    }
                }
                if !found {
                    return false
                }
            }
            return true
        }
    } else if let leftString = left as? NSString {
        if let rightString = right as? NSString {
            return leftString == rightString
        }
    } else if let leftNumber = left as? NSNumber {
        if let rightNumber = right as? NSNumber {
            return leftNumber == rightNumber
        }
    } else if let _ = left as? NSNull, let _ = right as? NSNull {
        return true
    }
    return false
}

func jsonStringCompareHelper(_ actual: String?, _ expected: String?) {
    let left = toJSONObject(actual)
    let right = toJSONObject(expected)
    // print("\(left)")
    // print("\(right)")
    XCTAssertTrue(compareJSONObject(left, right))
}
