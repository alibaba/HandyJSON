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

typealias Byte = Int8

public protocol PropertiesMetrizable {}

extension PropertiesMetrizable {

    // locate the head of a struct type object in memory
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Byte> {

        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        }
    }

    // locating the head of a class type object in memory
    mutating func headPointerOfClass() -> UnsafeMutablePointer<Byte> {

        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        return UnsafeMutablePointer<Byte>(mutableTypedPointer)
    }

    // memory size occupy by self object
    static func size() -> Int {
        return MemoryLayout<Self>.size
    }

    // align
    static func align() -> Int {
        return MemoryLayout<Self>.alignment
    }

    // Returns the offset to the next integer that is greater than
    // or equal to Value and is a multiple of Align. Align must be
    // non-zero.
    static func offsetToAlignment(value: Int, align: Int) -> Int {
        let m = value % align
        return m == 0 ? 0 : (align - m)
    }
}

fileprivate func calculateMemoryDistanceShouldMove(currentOffset: Int, layoutInfo: (Int, Int)) -> Int {
    let m = currentOffset % layoutInfo.1
    let offset =  (m == 0 ? 0 : (layoutInfo.1 - m))
    let size = layoutInfo.0
    return size + offset
}

public protocol RawEnumProtocol: StandardPropertyType {
    func takeRawValue() -> Any?
}

extension RawEnumProtocol{
  public func _serialize() -> Any? {
      return takeRawValue()
  }
}

public extension RawRepresentable where Self: RawEnumProtocol {

    func takeRawValue() -> Any? {
        return self.rawValue
    }

    static func valueFrom(object: NSObject) -> Self? {
        if let transformableType = RawValue.self as? PropertiesTransformable.Type {
            if let typedValue = transformableType.valueFrom(object: object) {
                return Self(rawValue: typedValue as! RawValue)
            }
        }
        return nil
    }
}


protocol BasePropertyProtocol: StandardPropertyType {
}

extension BasePropertyProtocol{
  public func _serialize() -> Any? {
    return self
  }
}


extension Optional: StandardPropertyType {
    public init() {
        self = nil
    }
    public static func valueFrom(object: NSObject) -> Optional? {
        if let value = (Wrapped.self as? PropertiesTransformable.Type)?.valueFrom(object: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        return self.map({ (wrapped) -> Any in
            return wrapped as Any
        })
    }
  
  public func _serialize() -> Any? {
    if let value = getWrappedValue(){
      if let transformable = value as? PropertiesTransformable{
       return transformable._serialize()
      }else{
        return value
      }
    }
    return nil
  }
}

extension ImplicitlyUnwrappedOptional: StandardPropertyType {
    public static func valueFrom(object: NSObject) -> ImplicitlyUnwrappedOptional? {
        if let value = (Wrapped.self as? PropertiesTransformable.Type)?.valueFrom(object: object) as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        } else if let value = object as? Wrapped {
            return ImplicitlyUnwrappedOptional(value)
        }
        return nil
    }

    func getWrappedValue() -> Any? {
        if case let .some(x) = self {
            return x
        }
        return nil
    }
  
  public func _serialize() -> Any? {
    if let value = getWrappedValue(){
      if let transformable = value as? PropertiesTransformable{
        return transformable._serialize()
      }else{
        return value
      }
    }
    return nil
  }
}


extension Collection{
    static func _valueFrom(object: NSObject) -> [Iterator.Element]?{
        guard let nsArray = object as? NSArray else {
            ClosureExecutor.executeWhenDebug {
                print("Expect object to be an NSArray but it's not")
            }
            return nil
        }
        typealias Element =  Iterator.Element
        var result: [Element] = [Element]()
        nsArray.forEach { (each) in
            if let nsObject = each as? NSObject {
                if let element = (Element.self as? PropertiesTransformable.Type)?.valueFrom(object: nsObject) as? Element {
                    result.append(element)
                } else if let element = nsObject as? Element {
                    result.append(element)
                }
            }
        }
        return result
    }

  
    func _seq_serialize() -> [Any?]{
      return self.map{ (each) -> (Any?) in
        if let tranformable = each as? PropertiesTransformable{
          return tranformable._serialize()
        }else{
          return each
        }
      }
    }
}

extension Array: StandardPropertyType{
  public static func valueFrom(object:NSObject) -> [Element]?{
    return _valueFrom(object: object)
  }
  
  public func _serialize() -> Any?{
    return self._seq_serialize()
  }
}

extension Set: StandardPropertyType{
  public static func valueFrom(object:NSObject) -> [Element]?{
    return _valueFrom(object: object)
  }
  
  public func _serialize() -> Any?{
    return self._seq_serialize()
  }
}


extension Dictionary: StandardPropertyType {
  public static func valueFrom(object:NSObject) -> Dictionary?{
    guard let nsDict = object as? NSDictionary else {
      ClosureExecutor.executeWhenDebug {
        print("Expect object to be an NSDictionary but it's not")
      }
      return nil
    }
    var result: [Key: Value] = [Key: Value]()
    for (key,value) in nsDict{
      if let sKey = key as? Key, let nsValue = value as? NSObject {
        if let nValue = (Value.self as? PropertiesTransformable.Type)?.valueFrom(object: nsValue) as? Value {
          result[sKey] = nValue
        } else if let nValue = nsValue as? Value {
          result[sKey] = nValue
        }
      }
    }
    return result
  }
  
  public func _serialize() -> Any? {
      var result = [String: Any]()
      for (key, value) in self{
        if let key = key as? String{
          if let transformable = value as? PropertiesTransformable{
            if let transValue = transformable._serialize(){
              result[key] = transValue
            }
          }
        }
        
      }
    
      return result
    }
}

public protocol PropertiesTransformable: PropertiesMetrizable {
}

public protocol StandardPropertyType:PropertiesTransformable{
  static func valueFrom(object:NSObject) -> Self?
  func _serialize() -> Any?
//  func _deserialize() -> String
}

extension PropertiesTransformable{
  public static func valueFrom(object:NSObject) -> Self? {
    if self is StandardPropertyType.Type{
      return (self as! StandardPropertyType.Type).valueFrom(object: object) as? Self
    }else if self is PropertiesMappable.Type{
      return (self as! PropertiesMappable.Type).valueFrom(object: object) as? Self
    }
    return nil
  }
  
  public func _serialize() -> Any?{
    if let this = self as? StandardPropertyType{
      return this._serialize()
    }else{
      return  self
    }
  }
}


public protocol PropertiesMappable: PropertiesTransformable {
    init()
    mutating func mapping(mapper: HelpingMapper)
}

extension PropertiesMappable {
    public mutating func mapping(mapper: HelpingMapper) {}
}


extension PropertiesMappable {
    public static func valueFrom(object: NSObject) -> Self? {
        if let dict = object as? NSDictionary {
            // nested object, transform recursively
            return self._transform(dict: dict, toType: self) as? Self
        }
        return nil
    }
}



// expose HandyJSON protocol
public protocol HandyJSON: PropertiesMappable {}

public protocol HandyJSONEnum: RawEnumProtocol {}

