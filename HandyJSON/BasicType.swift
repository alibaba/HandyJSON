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

//  Created by zhouzhuo on 7/7/16.
//

import Foundation

/*

 Int,
 Int8,
 Int16,
 Int32,
 Int64,
 UInt,
 UInt8,
 UInt16,
 UInt32,
 UInt64,
 Bool,
 Float,
 Double,
 String,
 */
protocol IntegerPropertyProtocol: Integer, BasePropertyProtocol{
  init?(_ text:String, radix: Int)
  init(_ number: NSNumber)
}

extension IntegerPropertyProtocol{
  public static func valueFrom(object:NSObject) -> Self?{
    if let str = object as? NSString{
      let text:String = str as String
      return Self(text, radix: 10)
    }else if let num = object as? NSNumber{
        return Self(num)
    } else{
      return nil
    }
    
  }
}

extension Int: IntegerPropertyProtocol{}
extension Int8: IntegerPropertyProtocol{}
extension Int16: IntegerPropertyProtocol{}
extension Int32: IntegerPropertyProtocol{}
extension Int64: IntegerPropertyProtocol{}
extension UInt8: IntegerPropertyProtocol{}
extension UInt16: IntegerPropertyProtocol{}
extension UInt32: IntegerPropertyProtocol{}
extension UInt64: IntegerPropertyProtocol{}

extension Bool: BasePropertyProtocol {
  public static func valueFrom(object:NSObject) -> Bool?{
    if let str = object as? NSString {
      let lowerCase = str.lowercased
      if ["0", "false", "no"].contains(lowerCase) {
        return false
      }
      if ["1", "true", "yes"].contains(lowerCase) {
        return true
      }
    }else if let num = object as? NSNumber{
      return num.boolValue
    }
    return nil
  }
}


protocol FloatPropertyProtocol:LosslessStringConvertible,BasePropertyProtocol {
    init(_ number: NSNumber)
}
extension FloatPropertyProtocol{
  public static func valueFrom(object:NSObject) -> Self?{
    if let str = object as? NSString{
      let text = str as String
      return Self(text)
    }else if let num = object as? NSNumber{
      return Self(num)
    }else{
      return nil
    }
  }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

extension String: BasePropertyProtocol {
  public static func valueFrom(object:NSObject) -> String?{
    if let str = object  as? NSString {
      return str as String
    } else if let  num = object as? NSNumber {
      // Boolean Type Inside
      if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
        if num.boolValue{
          return "true"
        } else {
          return "false"
        }
      }
      return num.stringValue
    } else if let arr = object as? NSArray{
      return "\(arr)"
    }else if let dict = object as? NSDictionary{
       return "\(dict)"
    }
    return nil
  }
  
}

//extension NSString: BasePropertyProtocol {
//  public static func valueFrom(object: NSObject) -> Self? {
//    if let str = String.valueFrom(object: object){
//      let nsstr = str as NSString
//      return nsstr as? NSString as! Self? as! Self?
//    }
//    return nil
//  }
//}
//
//extension NSNumber: BasePropertyProtocol {
//  static func valueFrom(object:NSObject) -> Self?{
//    if let num = object  as? NSNumber {
//      return num
//    }else if let str = object as? NSString{
//      // true/false
//      let lowerCase = str.lowercased
//      if lowerCase == "true" {
//        return NSNumber(booleanLiteral: true)
//      }
//      if lowerCase == "false" {
//        return NSNumber(booleanLiteral: false)
//      }
//      
//      // normal number
//      let formatter = NumberFormatter()
//      formatter.numberStyle = .decimal
//      return formatter.number(from: str as String)
//    }
//    return nil
//  }
//
//}

