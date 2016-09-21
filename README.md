# HandyJSON

HandyJSON是一个Swift编写的`JSON-对象间`序列化、反序列化库，用法简单，类型支持完善。

## Feature

* 支持`struct`和`class`;

* 支持大部分基本类型、组合类型、嵌套类型、可选类型;

* 自动使用对象的字段名称在JSON中取值，而不需要手动指定Mapping方法;

* 支持自定义映射关系和解析函数;

* 支持指定从JSON的某个节点开始反序列化;

* 支持字段类型自适应，如String到Int、Int到String等的转换;

## The Basics

Swift类实现`HandyJSON`协议(要求实现一个`init()`方法)后，就能从JSON文本进行反序列化了:

```
class Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?

    required init() {}
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\",\"num\":180}"

if let animal = JSONDeserializer<Animal>.deserializeFrom(jsonString) {
    print(animal)
}
```

如果是`struct`，则不需要实现`init()`方法：

```
struct Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\",\"num\":180}"

if let animal = JSONDeserializer<Animal>.deserializeFrom(jsonString) {
    print(animal)
}
```

## Optional/ImplicitWrappedOptional/Collection

`HandyJSON`支持属性为隐式可选、可选、数组类型、嵌套集合类型、Objective-C基本类型等的类：

```
struct Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var friend: [String]?
    var weight: Double?
    var alive: Bool = true
    var color: NSString?
}

let jsonString = "{\"id\":1234567,\"name\":\"Kitty\",\"friend\":[\"Tom\",\"Jack\",\"Lily\",\"Black\"],\"weight\":15.34,\"alive\":false,\"color\":\"white\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(jsonString) {
    print(cat)
}
```

## Designated Path

可以为`HandyJSON`指定从JSON的某个节点开始反序列化:

```
struct Cat: HandyJSON {
    var id: Int64!
    var name: String!
}

let jsonString = "{\"code\":200,\"msg\":\"success\",\"data\":{\"cat\":{\"id\":12345,\"name\":\"Kitty\"}}}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(jsonString, designatedPath: "data.cat") {
    print(cat.name)
}
```

## Composition Object

类中非基本类型的属性，也需要实现`HandyJSON`协议，才能进行反序列化:

```
struct Component: HandyJSON {
    var aInt: Int?
    var aString: String?
}

struct Composition: HandyJSON {
    var aInt: Int?
    var comp1: Component?
    var comp2: Component?
}

let jsonString = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"

if let composition = JSONDeserializer<Composition>.deserializeFrom(jsonString) {
    print(composition)
}
```

## Inheritance Object

有继承关系的类，需要继承链上的类都实现`HandyJSON`协议:

```
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

if let cat = JSONDeserializer<Cat>.deserializeFrom(jsonString) {
    print(cat)
}
```

## Customize Mapping

`HandyJSON`允许你自行定义映射到类属性的`Key`，和解析的方法，只需要在实现`HandyJSON`协议时，实现一个可选函数mapping，在其中指定`Key`和解析方法:

```
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?

    required init() {}

    func mapping(mapper: Mapper) {
        // 指定JSON中"cat_id"的值反序列化到"id"字段
        mapper.specify(&id, name: "cat_id")

        // 指定"parent"对应的JSON字段采用如下方式解析
        mapper.specify(&parent) {
            let parentName = $0.characters.split{$0 == "/"}.map(String.init)
            return (parentName[0], parentName[1])
        }
    }
}

let jsonString = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(jsonString) {
    print(cat)
}
```

## Supported Property Type

* `Int`

* `Bool`

* `Double`

* `Float`

* `String`

* `NSString`

* `NSNumber`

* `NSArray/NSDictionary`

* `Int8/Int16/Int32/Int64`

* `UInt8/UInt16/UInt23/UInt64`

* `Array<T>` // T是已经支持的类型

* `Dictionary<String, T>` // T是已经支持的类型

* `Optional<T>` // T是已经支持的类型

* `ImplicitlyUnwrappedOption<T>` // T是已经支持的类型

* 嵌套对象

* 自定义解析类型

* 有继承关系的类

## Compatibility

已经在32位、64位、iOS 8.0+/9.0+/10.0+ 机器测试通过。

已经在Swift 2.3， Swift 3.0 beta上测试通过；

## To Do

* 支持直接到基本类型、集合类型(即非对象类型)的反序列化；

* 支持对象到JSON的序列化;

* 支持Swift 3.0;
