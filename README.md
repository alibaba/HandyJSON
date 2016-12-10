# HandyJSON

HandyJSON is a framework written in Swift which to make converting model objects(classes/structs) to and from JSON easy on iOS.

Compared with others, the most significant feature of HandyJSON is that it does not require the objects inherit from NSObject(**not using KVC but reflection**), neither implements a 'mapping' function(**use pointer to achieve property assignment**).

**Notice that** , HandyJSON is totally depend on the memory layout rules of Swift which we haven’t found formal specification from Apple(And I'm looking forward to someone can help). The good new is that it has never changed in the past. Also We can adjust out strategy if it really change. So, I think “the potential crisis" is more likely oneday Swift make reflection more powerful, such as supporting assignment.

[![Build Status](https://travis-ci.org/alibaba/HandyJSON.svg?branch=master)](https://travis-ci.org/alibaba/HandyJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Version](https://img.shields.io/cocoapods/v/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Cocoapods Platform](https://img.shields.io/cocoapods/p/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Codecov branch](https://img.shields.io/codecov/c/github/alibaba/HandyJSON/master.svg?style=flat)](https://codecov.io/gh/alibaba/HandyJSON/branch/master)

## [中文文档](./README_cn.md)

## Sample Code

### Deserialization

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

### Serialization

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

# Content

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Carthage](#carthage)
    - [Manually](#manually)
- [Deserialization](#deserialization)
    - [The Basics](#the-basics)
    - [Support Struct](#support-struct)
    - [Support Enum Property](#support-enum-property)
    - [Optional, ImplicitlyUnwrappedOptional, Collections and so on](#optional-implicitlyunwrappedoptional-collections-and-so-on)
    - [Designated Path](#designated-path)
    - [Composition Object](#composition-object)
    - [Inheritance Object](#inheritance-object)
    - [Array In JSON](#array-in-json)
    - [Custom Mapping](#custom-mapping)
    - [Exclude Property](#exclude-property)
    - [Supported Property Type](#supported-property-type)
- [Serialization](#serialization)
    - [The Basics](#the-basics)
    - [Complex Object](#complex-object)
- [To Do](#to-do)

# Features

* Serialize/Deserialize Object/JSON to/From JSON/Object

* Naturally use object property name for mapping, no need to specify a mapping relationship

* Support almost all types in Swift, including enum

* Support struct

* Custom transformations for mapping

* Type-Adaption, such as string json field maps to int property, int json field maps to string property

# Requirements

* iOS 8.0+/OSX 10.9+/watchOS 2.0+/tvOS 9.0+

* Swift 2.3+ / Swift 3.0+

# Installation

**To use with Swift 2.x using == 0.4.0**

**To use with Swift 3.x using >= 1.4.0**

For Legacy Swift support, take a look at the [swift2 branch](https://github.com/alibaba/HandyJSON/tree/master_for_swift_2x).

## Cocoapods

Add the following line to your `Podfile`:

```
pod 'HandyJSON', '~> 1.4.0'
```

Then, run the following command:

```
$ pod install
```

## Carthage

You can add a dependency on `HandyJSON` by adding the following line to your `Cartfile`:

```
github "alibaba/HandyJSON" ~> 1.4.0
```

## Manually

You can integrate `HandyJSON` into your project manually by doing the following steps:

* Open up `Terminal`, `cd` into your top-level project directory, and add `HandyJSON` as a submodule:

```
git init && git submodule add https://github.com/alibaba/HandyJSON.git
```

* Open the new `HandyJSON` folder, drag the `HandyJSON.xcodeproj` into the `Project Navigator` of your project.

* Select your application project in the `Project Navigator`, open the `General` panel in the right window.

* Click on the `+` button under the `Embedded Binaries` section.

* You will see two different `HandyJSON.xcodeproj` folders each with four different versions of the HandyJSON.framework nested inside a Products folder.
> It does not matter which Products folder you choose from, but it does matter which HandyJSON.framework you choose.

* Select one of the four `HandyJSON.framework` which matches the platform your Application should run on.

* Congratulations!

# Deserialization

## The Basics

To support deserialization from JSON, a class/struct need to conform to 'HandyJSON' protocol. It's truly protocol, not some class inherited from NSObject.

To conform to 'HandyJSON', a class need to implement an empty initializer.

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

## Support Struct

For struct, since the compiler provide a default empty initializer, we use it for free.

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

But also notice that, if you have a designated initializer to override the default one in the struct, you should explicitly declare an empty one(no `required` modifier need).

## Support Enum Property

Limited by some type converting problems, supporting `enum` type is a little special here. To be convertable, An `enum` must conform to `HandyJSONEnum` protocol and implement a `makeInitWrapper` function.

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

It’s not that troublesome. Just wrap the `init` funcion of a `RawRepresentable` enum and return. You can even do this in an extension.

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

Now it’s totally non-intrusive.

## Optional, ImplicitlyUnwrappedOptional, Collections and so on

'HandyJSON' support classes/structs composed of `optional`, `implicitlyUnwrappedOptional`, `array`, `dictionary`, `objective-c base type`, `nested type` etc. properties.

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

## Designated Path

`HandyJSON` supports deserialization from designated path of JSON.

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

## Composition Object

Notice that all the properties of a class/struct need to deserialized should be type conformed to `HandyJSON`.

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

## Inheritance Object

A subclass need deserialization, it's superclass need to conform to `HandyJSON`.

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

## Array In JSON

If the first level of a JSON text is an array, we turn it to objects array.

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

## Custom Mapping

`HandyJSON` let you customize the key mapping to JSON fields, or parsing method of any property. All you need to do is implementing an optional `mapping` function, do things in it.

```swift
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper.specify(property: &id, name: "cat_id")

        // specify 'parent' field in json parse as following to 'parent' property in object
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

## Exclude Property

If any property of a class/struct could not conform to `HandyJSON` or you just do not want to do the deserialization with it, you should exclude it in the mapping function.

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
        mapper.exclude(property: &notHandyJSONTypeProperty)
        mapper.exclude(property: &basicTypeButNotWantedProperty)
    }
}

let jsonString = "{\"name\":\"cat\",\"id\":\"12345\"}"

if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString) {
    print(cat)
}
```

## Supported Property Type

* `Int`/`Bool`/`Double`/`Float`/`String`/`NSNumber`/`NSString`

* `RawRepresentable` enum

* `NSArray/NSDictionary`

* `Int8/Int16/Int32/Int64`/`UInt8/UInt16/UInt23/UInt64`

* `Optional<T>/ImplicitUnwrappedOptional<T>` // T is one of the above types

* `Array<T>` // T is one of the above types

* `Dictionary<String, T>` // T is one of the above types

* Nested of aboves

# Serialization

## The Basics

You need to do nothing special to support serialization. Define the class/struct, get the instances, then serialize it to json text, or simple dictionary.

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

## Complex Object

Still need no extra effort.

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

# To Do

* Improve testcases

* Improve error handling

* <del>Support non-object (such as basic type, array, dictionany) type deserializing directly</del> (will not support)

# License

HandyJSON is released under the Apache License, Version 2.0. See LICENSE for details.
