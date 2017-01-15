# HandyJSON

HandyJSON是一个用于Swift语言中的JSON序列化/反序列化库。

与其他流行的Swift JSON库相比，HandyJSON的特点是，它支持纯swift类，使用也简单。它反序列化时(把JSON转换为Model)不要求Model从`NSObject`继承(因为它不是基于`KVC`机制)，也不要求你为Model定义一个`Mapping`函数。只要你定义好Model类，声明它服从`HandyJSON`协议，HandyJSON就能自行以各个属性的属性名为Key，从JSON串中解析值。

HandyJSON目前依赖于从Swift Runtime源码中推断的内存规则，任何变动我们将随时跟进。

[![Build Status](https://travis-ci.org/alibaba/HandyJSON.svg?branch=master)](https://travis-ci.org/alibaba/HandyJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Version](https://img.shields.io/cocoapods/v/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Cocoapods Platform](https://img.shields.io/cocoapods/p/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Codecov branch](https://img.shields.io/codecov/c/github/alibaba/HandyJSON/master.svg?style=flat)](https://codecov.io/gh/alibaba/HandyJSON/branch/master)

## 简单示例

### 反序列化

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = JSONDeserializer<BasicTypes>.deserializeFrom(json: jsonString) {
    print(object.int)
    print(object.doubleOptional!)
    print(object.stringImplicitlyUnwrapped)
}
```

### 序列化

```swift
let object = BasicTypes()
object.int = 1
object.doubleOptional = 1.1
object.stringImplicitlyUnwrapped = “hello"

print(object.toJSON()!) // serialize to dictionary
print(object.toJSONString()!) // serialize to JSON string
print(object.toJSONString(prettyPrint: true)!) // serialize to pretty JSON string
```

# 文档目录

- [特性](#特性)
- [环境要求](#环境要求)
- [安装](#安装)
- [反序列化](#反序列化-1)
    - [基本类型](#基本类型)
    - [支持struct](#支持struct)
    - [支持enum](#支持enum)
    - [可选、隐式解包可选、集合等](#可选隐式解包可选集合等)
    - [指定解析路径](#指定解析路径)
    - [组合对象](#组合对象)
    - [继承自父类的子类](#继承自父类的子类)
    - [JSON中的数组](#json中的数组)
    - [自定义解析规则](#自定义解析规则)
    - [排除指定属性](#排除指定属性)
    - [支持的属性类型](#支持的属性类型)
- [序列化](#序列化-1)
    - [基本类型](#基本类型-1)
    - [自定义映射和排除型](#自定义映射和排除)
- [待办](#待办)

# 特性

* 序列化Model到JSON、从JSON反序列化到Model

* 自然地以Model的属性名称作为解析JSON的Key，不需要额外指定

* 支持Swift中大部分类型

* 支持class、struct定义的Model

* 支持自定义解析规则

* 类型自适应，如JSON中是一个Int，但对应Model是String字段，会自动完成转化

具体支持的类型，可以参考代码文件: [BasicTypes](./HandyJSONTests/BasicTypes.swift)。

# 环境要求

* iOS 8.0+/OSX 10.9+/watchOS 2.0+/tvOS 9.0+

* Swift 2.3+ / Swift 3.0+

# 安装

HandyJSON只在Swift3.x版本上(master分支)开发新特性，在Swift2.x中使用，参见: [swift2 branch](https://github.com/alibaba/HandyJSON/tree/master_for_swift_2x)

具体操作指引参考 [英文版README](./README.md) 的 `Installation` 章节。

# 反序列化

## 基本类型

要支持从JSON串反序列化，Model定义时要声明服从`HandyJSON`协议。确实是一个协议，而不是继承自`NSObject`。

服从`HandyJSON`协议，需要实现一个空的`init`方法。

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = JSONDeserializer<BasicTypes>.deserializeFrom(json: jsonString) {
    // …
}
```

## 支持struct

对于声明为`struct`的Model，由于`struct`默认提供了空的`init`方法，所以不需要额外声明。

```swift
struct BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = JSONDeserializer<BasicTypes>.deserializeFrom(json: jsonString) {
    // …
}
```

但需要注意，如果你为`struct`指定了别的构造函数，那就要显示声明一个空的`init`函数。

## 支持enum

支持值类型的enum，且需要声明服从`HandyJSONEnum`协议。不再需要其他特殊处理了。

```swift
enum AnimalType: String, HandyJSONEnum {
    case Cat = "cat"
    case Dog = "dog"
    case Bird = "bird"
}

struct Animal: HandyJSON {
    var name: String?
    var type: AnimalType?
}

let jsonString = "{\"type\":\"cat\",\"name\":\"Tom\"}"
if let animal = JSONDeserializer<Animal>.deserializeFrom(json: jsonString) {
    print(animal.type?.rawValue)
}
```

## 可选、隐式解包可选、集合等

HandyJSON支持这些非基础类型，包括嵌套结构。

```swift
class BasicTypes: HandyJSON {
    var bool: Bool = true
    var intOptional: Int?
    var doubleImplicitlyUnwrapped: Double!
    var anyObjectOptional: Any?

    var arrayInt: Array<Int> = []
    var arrayStringOptional: Array<String>?
    var setInt: Set<Int>?
    var dictAnyObject: Dictionary<String, Any> = [:]

    var nsNumber = 2
    var nsString: NSString?

    required init() {}
}

let object = BasicTypes()
object.intOptional = 1
object.doubleImplicitlyUnwrapped = 1.1
object.anyObjectOptional = "StringValue"
object.arrayInt = [1, 2]
object.arrayStringOptional = ["a", "b"]
object.setInt = [1, 2]
object.dictAnyObject = ["key1": 1, "key2": "stringValue"]
object.nsNumber = 2
object.nsString = "nsStringValue"

let jsonString = object.toJSONString()!

if let object = JSONDeserializer<BasicTypes>.deserializeFrom(json: jsonString) {
    // ...
}
```

## 指定解析路径

HandyJSON支持指定从哪个具体路径开始解析，反序列化到Model。

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!

    required init() {}
}

let jsonString = "{\"code\":200,\"msg\":\"success\",\"data\":{\"cat\":{\"id\":12345,\"name\":\"Kitty\"}}}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString, designatedPath: "data.cat") {
    print(cat.name)
}
```

## 组合对象

注意，如果Model的属性不是基本类型或集合类型，那么它必须是一个服从`HandyJSON`协议的类型。

如果是泛型集合类型，那么要求泛型实参是基本类型或者服从`HandyJSON`协议的类型。

```swift
class Component: HandyJSON {
    var aInt: Int?
    var aString: String?

    required init() {}
}

class Composition: HandyJSON {
    var aInt: Int?
    var comp1: Component?
    var comp2: Component?

    required init() {}
}

let jsonString = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"

if let composition = JSONDeserializer<Composition>.deserializeFrom(json: jsonString) {
    print(composition)
}
```

## 继承自父类的子类

如果子类要支持反序列化，那么要求父类也服从`HandyJSON`协议。

```swift
class Animal: HandyJSON {
    var id: Int?
    var color: String?

    required init() {}
}

class Cat: Animal {
    var name: String?

    required init() {}
}

let jsonString = "{\"id\":12345,\"color\":\"black\",\"name\":\"cat\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString) {
    print(cat)
}
```

## JSON数组

如果JSON的第一层表达的是数组，可以转化它到一个Model数组。

```swift
class Cat: HandyJSON {
    var name: String?
    var id: String?

    required init() {}
}

let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\"}, {\"name\":\"Lily\",\"id\":\"2\"}, {\"name\":\"Lucy\",\"id\":\"3\"}]"
if let cats = JSONDeserializer<Cat>.deserializeModelArrayFrom(json: jsonArrayString) {
    cats.forEach({ (cat) in
        // ...
    })
}
```

## 自定义解析规则

HandyJSON支持自定义映射关系，或者自定义解析过程。你需要实现一个可选的`mapping`函数，在里边实现`NSString`值(HandyJSON会把对应的JSON字段转换为NSString)转换为你需要的字段类型。

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper <<<
            self.id <-- "cat_id"

        // specify 'parent' field in json parse as following to 'parent' property in object
        mapper <<<
            self.parent <-- TransformOf<(String, String), String>(fromJSON: { (rawString) -> (String, String)? in
                if let parentNames = rawString?.characters.split(separator: "/").map(String.init) {
                    return (parentNames[0], parentNames[1])
                }
                return nil
            }, toJSON: { (tuple) -> String? in
                if let _tuple = tuple {
                    return "\(_tuple.0)/\(_tuple.1)"
                }
                return nil
            })
    }
}

let jsonString = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString) {
    print(cat.id)
    print(cat.parent)
}
```

## 排除指定属性

如果在Model中存在因为某些原因不能实现`HandyJSON`协议的非基本字段，或者不能实现`HandyJSONEnum`协议的枚举字段，又或者说不希望反序列化影响某个字段，可以在`mapping`函数中将它排除。如果不这么做，可能会出现未定义的行为。

```swift
class NotHandyJSONType {
    var dummy: String?
}

class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var notHandyJSONTypeProperty: NotHandyJSONType?
    var basicTypeButNotWantedProperty: String?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper >>> self.notHandyJSONTypeProperty
        mapper >>> self.basicTypeButNotWantedProperty
    }
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString) {
    print(cat)
}
```

## 支持的属性类型

* `Int`/`Bool`/`Double`/`Float`/`String`/`NSNumber`/`NSString`

* `NSArray/NSDictionary`

* `Int8/Int16/Int32/Int64`/`UInt8/UInt16/UInt23/UInt64`

* `Optional<T>/ImplicitUnwrappedOptional<T>` // T is one of the above types

* `Array<T>` // T is one of the above types

* `Dictionary<String, T>` // T is one of the above types

* 以上类型的嵌套

# 序列化

## 基本类型

现在，序列化也要求Model声明服从`HandyJSON`协议。

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let object = BasicTypes()
object.int = 1
object.doubleOptional = 1.1
object.stringImplicitlyUnwrapped = “hello"

print(object.toJSON()!) // serialize to dictionary
print(object.toJSONString()!) // serialize to JSON string
print(object.toJSONString(prettyPrint: true)!) // serialize to pretty JSON string
```

## 自定义映射和排除

和反序列化一样，只要定义`mapping`和`exclude`就可以了。被排除的属性，序列化和反序列化都不再影响到它。而在`mapping`中定义的`Transformer`，同时定义了序列化和反序列的规则，所以只要为属性指明一个`Transformer`关系就可以了。

# 待办

* 完善测试

* 完善异常处理

* 简化API风格

# License

HandyJSON is released under the Apache License, Version 2.0. See LICENSE for details.
