# HandyJSON

HandyJSON is a framework written in Swift which to make converting model objects( **pure classes/structs** ) to and from JSON easy on iOS.

Compared with others, the most significant feature of HandyJSON is that it does not require the objects inherit from NSObject(**not using KVC but reflection**), neither implements a 'mapping' function(**write value to memory to achieve property assignment**).

HandyJSON is totally depend on the memory layout rules infered from Swift runtime code. We are watching it and will follow every bit if it change.

[![Build Status](https://travis-ci.org/alibaba/HandyJSON.svg?branch=master)](https://travis-ci.org/alibaba/HandyJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Version](https://img.shields.io/cocoapods/v/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Cocoapods Platform](https://img.shields.io/cocoapods/p/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Codecov branch](https://img.shields.io/codecov/c/github/alibaba/HandyJSON/master.svg?style=flat)](https://codecov.io/gh/alibaba/HandyJSON/branch/master)

## [中文文档](./README_cn.md)

## Sample Code

### Deserialization

```swift
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    print(object.int)
    print(object.doubleOptional!)
    print(object.stringImplicitlyUnwrapped)
}
```

### Serialization

```swift

let object = BasicTypes()
object.int = 1
object.doubleOptional = 1.1
object.stringImplicitlyUnwrapped = “hello"

print(object.toJSON()!) // serialize to dictionary
print(object.toJSONString()!) // serialize to JSON string
print(object.toJSONString(prettyPrint: true)!) // serialize to pretty JSON string
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
    - [JSON Array](#json-array)
    - [Custom Mapping](#custom-mapping)
    - [Exclude Property](#exclude-property)
    - [Supported Property Type](#supported-property-type)
- [Serialization](#serialization)
    - [The Basics](#the-basics)
    - [Mapping And Excluding](#mapping-and-excluding)
- [To Do](#to-do)

# Features

* Serialize/Deserialize Object/JSON to/From JSON/Object

* Naturally use object property name for mapping, no need to specify a mapping relationship

* Support almost all types in Swift, including enum

* Support struct

* Custom transformations for mapping

* Type-Adaption, such as string json field maps to int property, int json field maps to string property

An overview of types supported can be found at file: [BasicTypes.swift](./HandyJSONTest/BasicTypes.swift)

# Requirements

* iOS 8.0+/OSX 10.9+/watchOS 2.0+/tvOS 9.0+

* Swift 2.3+ / Swift 3.0+

# Installation

**To use with Swift 2.x using == 0.4.0**

**To use with Swift 3.x using >= 1.7.2**

For Legacy Swift support, take a look at the [swift2 branch](https://github.com/alibaba/HandyJSON/tree/master_for_swift_2x).

## Cocoapods

Add the following line to your `Podfile`:

```
pod 'HandyJSON', '~> 1.7.2'
```

Then, run the following command:

```
$ pod install
```

## Carthage

You can add a dependency on `HandyJSON` by adding the following line to your `Cartfile`:

```
github "alibaba/HandyJSON" ~> 1.7.2
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
class BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

    required init() {}
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    // …
}
```

## Support Struct

For struct, since the compiler provide a default empty initializer, we use it for free.

```swift
struct BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!
}

let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
if let object = BasicTypes.deserialize(from: jsonString) {
    // …
}
```

But also notice that, if you have a designated initializer to override the default one in the struct, you should explicitly declare an empty one(no `required` modifier need).

## Support Enum Property

To be convertable, An `enum` must conform to `HandyJSONEnum` protocol. Nothing special need to do now.

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
if let animal = Animal.deserialize(from: jsonString) {
    print(animal.type?.rawValue)
}
```

## Optional, ImplicitlyUnwrappedOptional, Collections and so on

'HandyJSON' support classes/structs composed of `optional`, `implicitlyUnwrappedOptional`, `array`, `dictionary`, `objective-c base type`, `nested type` etc. properties.

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

if let object = BasicTypes.deserialize(from: jsonString) {
    // ...
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

if let cat = Cat.deserialize(from: jsonString, designatedPath: "data.cat") {
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

if let composition = Composition.deserialize(from: jsonString) {
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

if let cat = Cat.deserialize(from: jsonString) {
    print(cat)
}
```

## JSON Array

If the first level of a JSON text is an array, we turn it to objects array.

```swift
class Cat: HandyJSON {
    var name: String?
    var id: String?

    required init() {}
}

let jsonArrayString: String? = "[{\"name\":\"Bob\",\"id\":\"1\"}, {\"name\":\"Lily\",\"id\":\"2\"}, {\"name\":\"Lucy\",\"id\":\"3\"}]"
if let cats = [Cat].deserialize(from: jsonArrayString) {
    cats.forEach({ (cat) in
        // ...
    })
}
```

## Custom Mapping

`HandyJSON` let you customize the key mapping to JSON fields, or parsing method of any property. All you need to do is implementing an optional `mapping` function, do things in it.

We bring the transformer from [`ObjectMapper`](https://github.com/Hearst-DD/ObjectMapper). If you are familiar with it, it’s almost the same here.

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

if let cat = Cat.deserialize(from: jsonString) {
    print(cat.id)
    print(cat.parent)
}
```

## Exclude Property

If any non-basic property of a class/struct could not conform to `HandyJSON`/`HandyJSONEnum` or you just do not want to do the deserialization with it, you should exclude it in the mapping function.

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

if let cat = Cat.deserialize(from: jsonString) {
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

Now, a class/model which need to serialize to JSON should also conform to `HandyJSON` protocol.

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

## Mapping And Excluding

It’s all like what we do on deserialization. A property which is excluded, it will not take part in neither deserialization nor serialization. And the mapper items define both the deserializing rules and serializing rules. Refer to the usage above.

# License

HandyJSON is released under the Apache License, Version 2.0. See LICENSE for details.
