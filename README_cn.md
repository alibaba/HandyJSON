# HandyJSON

HandyJSON是一个用于Swift语言中的JSON序列化/反序列化库。

与其他流行的Swift JSON库相比，HandyJSON的特点是，它反序列化时(把JSON转换为Model)不要求Model从`NSObject`继承(因为它不是基于`KVC`机制)，也不要求你为Model定义一个`Mapping`函数。只要你定义好Model类，声明它服从`HandyJSON`协议，HandyJSON就能自行以各个属性的属性名为Key，从JSON串中解析值。

需要注意，HandyJSON在反序列化时是根据Model的内存布局来为各个属性赋值的，所以，它完全依赖于Swift的内存布局规则。这个库实现里涉及的规则是从一些三方资料中找到说明，加上自己反复验证总结得到。Swift从诞生到现在一直没有改变过这些规则，但毕竟不是苹果官方说明，所以仍然存在一定的风险。如果Swift日后更新改变这些规则，HandyJSON会第一时间跟进做好兼容工作。

[![Build Status](https://travis-ci.org/alibaba/HandyJSON.svg?branch=master)](https://travis-ci.org/alibaba/HandyJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Version](https://img.shields.io/cocoapods/v/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Cocoapods Platform](https://img.shields.io/cocoapods/p/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Codecov branch](https://img.shields.io/codecov/c/github/alibaba/HandyJSON/master.svg?style=flat)](https://codecov.io/gh/alibaba/HandyJSON/branch/master)

## 简单示例

### 反序列化

```swift
class Animal: HandyJSON {
    var name: String?
    var count: Int?

    required init() {}
}

let json = "{\"name\": \"Cat\", \"count\": 5}"

if let cat = JSONDeserializer<Animal>.deserializeFrom(json: json) {
    print(cat)
}
```

### 序列化

```swift
class Animal {
    var name: String?
    var count: Int?

    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}

let cat = Animal(name: "cat", count: 5)

print(JSONSerializer.serialize(model: cat).toJSON()!)
print(JSONSerializer.serialize(model: cat).toPrettifyJSON()!)
print(JSONSerializer.serialize(model: cat).toSimpleDictionary()!)
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
    - [支持的属性类型](#支持的属性类型)
- [序列化](#序列化-1)
    - [基本类型](#基本类型-1)
    - [复杂类型](#复杂类型)
- [待办](#待办)

# 特性

* 序列化Model到JSON、从JSON反序列化到Model

* 自然地以Model的属性名称作为解析JSON的Key，不需要额外指定

* 支持Swift中大部分类型

* 支持class、struct定义的Model

* 支持自定义解析规则

* 类型自适应，如JSON中是一个Int，但对应Model是String字段，会自动完成转化

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
class Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?

    required init() {}
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\",\"num\":180}"

if let animal = JSONDeserializer<Animal>.deserializeFrom(json: jsonString) {
    print(animal)
}
```

## 支持struct

对于声明为`struct`的Model，由于`struct`默认提供了空的`init`方法，所以不需要额外声明。

```swift
struct Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\",\"num\":180}"

if let animal = JSONDeserializer<Animal>.deserializeFrom(json: jsonString) {
    print(animal)
}
```

但需要注意，如果你为`struct`指定了别的构造函数，那就要显示声明一个空的`init`函数。

## 支持enum

由于受到类型转换的一些限制，对`enum`的支持需要一些特殊处理。要支持反序列化的`enum`类型需要服从`HandyJSONEnum`协议，并实现协议要求的`makeInitWrapper`函数。

```swift
enum AnimalType: String, HandyJSONEnum {
    case Cat = "cat"
    case Dog = "dog"
    case Bird = "bird"

    static func makeInitWrapper() -> InitWrapperProtocol? {
        return InitWrapper<String>(rawInit: AnimalType.init)
    }
}

class Animal: HandyJSON {
    var type: AnimalType?
    var name: String?

    required init() {}
}

let jsonString = "{\"type\":\"cat\",\"name\":\"Tom\"}"
if let animal = JSONDeserializer<Animal>.deserializeFrom(json: jsonString) {
    print(animal)
}
```

在`makeInitWrapper`函数中将`RawRepresentable`的`init`函数包装一下，返回就可以了。如果觉得对代码有侵入，可以考虑用扩展实现。

```swift
enum AnimalType: String {
    case Cat = "cat"
    case Dog = "dog"
    case Bird = "bird"
}

extension AnimalType: HandyJSONEnum {
    static func makeInitWrapper() -> InitWrapperProtocol? {
        return InitWrapper<String>(rawInit: AnimalType.init)
    }
}

...
```

这样对原来的`enum`类型就没有侵入了。

## 可选、隐式解包可选、集合等

HandyJSON支持这些非基础类型，包括嵌套结构。

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var friend: [String]?
    var weight: Double?
    var alive: Bool = true
    var color: NSString?

    required init() {}
}

let jsonString = "{\"id\":1234567,\"name\":\"Kitty\",\"friend\":[\"Tom\",\"Jack\",\"Lily\",\"Black\"],\"weight\":15.34,\"alive\":false,\"color\":\"white\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString) {
    print(cat)
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

## JSON中的数组

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
        if let _cat = cat {
            print(_cat.id ?? "", _cat.name ?? "")
        }
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
        // 指定 JSON中的`cat_id`字段映射到Model中的`id`字段
        mapper.specify(property: &id, name: "cat_id")

        // 指定JSON中的`parent`字段解析为Model中的`parent`字段
        // 因为(String, String)?是一个元组，既不是基本类型，也不服从`HandyJSON`协议，所以需要自己实现解析过程
        mapper.specify(property: &parent, converter: { (rawString) -> (String, String) in
            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
            return (parentNames[0], parentNames[1])
        })
    }
}

let jsonString = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\"}"

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

不需要为序列化做额外的工作。给出Model定义，构造出实例，就可以直接调用HandyJSON把它转化为JSON文本串，或者只有基础类型的简单字典。

```swift
class Animal {
    var name: String?
    var height: Int?

    init(name: String, height: Int) {
        self.name = name
        self.height = height
    }
}

let cat = Animal(name: "cat", height: 30)
if let jsonStr = JSONSerializer.serialize(model: cat).toJSON() {
    print("simple json string: ", jsonStr)
}
if let prettifyJSON = JSONSerializer.serialize(model: cat).toPrettifyJSON() {
    print("prettify json string: ", prettifyJSON)
}
if let dict = JSONSerializer.serialize(model: cat).toSimpleDictionary() {
    print("dictionary: ", dict)
}
```

## 复杂类型

仍然不需要额外的工作，直接调接口就可以。

```swift
enum Gender {
    case Male
    case Female
}

struct Subject {
    var id: Int64?
    var name: String?

    init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
}

class Student {
    var name: String?
    var gender: Gender?
    var subjects: [Subject]?
}

let student = Student()
student.name = "Jack"
student.gender = .Female
student.subjects = [Subject(id: 1, name: "math"), Subject(id: 2, name: "English"), Subject(id: 3, name: "Philosophy")]

if let jsonStr = JSONSerializer.serialize(model: student).toJSON() {
    print("simple json string: ", jsonStr)
}
if let prettifyJSON = JSONSerializer.serialize(model: student).toPrettifyJSON() {
    print("prettify json string: ", prettifyJSON)
}
if let dict = JSONSerializer.serialize(model: student).toSimpleDictionary() {
    print("dictionary: ", dict)
}
```

# 待办

* 完善测试

* 完善异常处理

# License

HandyJSON is released under the Apache License, Version 2.0. See LICENSE for details.
