# HandyJSON

HandyJSON is a framework written in Swift which to make converting model objects(classes/structs) to and from JSON easy on iOS.

Compared with others, the most significant feature of HandyJSON is that it does not need the objects inherit from NSObject(not using KVC but reflection), neither implements a 'mapping' function.

[![Build Status](https://travis-ci.org/alibaba/HandyJSON.svg?branch=master)](https://travis-ci.org/alibaba/HandyJSON)
[![Cocoapods Version](https://img.shields.io/cocoapods/v/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Cocoapods Platform](https://img.shields.io/cocoapods/p/HandyJSON.svg?style=flat)](http://cocoadocs.org/docsets/HandyJSON)
[![Codecov branch](https://img.shields.io/codecov/c/github/alibaba/HandyJSON/master.svg?style=flat)](https://codecov.io/gh/alibaba/HandyJSON/branch/master)

## Sample Code

### Deserialization

```
struct Animal: HandyJSON {
    var name: String?
    var height: Int?
}

if let cat = JSONDeserializer<Animal>.deserializeFrom(json) {
    print(cat)
}
```

### Serialization

```
class Animal {
    var name: String?
    var height: Int?

    init(name: String, height: Int) {
        self.name = name
        self.height = height
    }
}

let cat = Animal(name: "cat", height: 30)

print(JSONSerializer.serializeToJSON(cat)!)
print(JSONSerializer.serializeToJSON(cat, prettify: true)!)
```

# Content

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
    - [Cocoapods](#cocoapods)
- [Deserialization](#deserialization)
    - [The Basics](#the-basics)
    - [Optional, ImplicitlyUnwrappedOptional, Collectiones and so on](optional-implicitlyunwrappedoptional-collectiones-and-so-on)
    - [Designated Path](#designated-path)
    - [Composition Object](#composition-object)
    - [Inheritance Object](#inheritance-object)
    - [Custom Mapping](#custom-mapping)
    - [Supported Property Type](#supported-property-type)
- [Serialization](#serialization)
    - [The Basics](#the-basics)
    - [Complex Object](#complex-object)
- [Compatibility](#compatibility)
- [To Do](#to-do)

# Features

* Serialize/Deserialize Object/JSON to/From JSON/Object (classes and structs)

* Support almost all types in Swift

* Naturally use object property name for mapping, no need to specify a mapping relationship

* Custom transformations for mapping

* Type-Adaption, such as string json field maps to int property, int json field maps to string property

# Requirements

* iOS 8.0+

* Swift 2.3+

# Installation

## Cocoapods

Add the following lines to your podfile:

```
pod 'HandyJSON', '~> 0.1.0'
```

Then, run the following command:

```
$ pod install
```

# Deserialization

## The Basics

To support deserialization from JSON, a class/struct need to comform to 'HandyJSON' protocol. It's truly protocol, not some class inherited from NSObject.

To comform to 'HandyJSON', a class need to implement an empty initializer.

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

For struct, since the compiler privide a default empty initializer, we use if for free.

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

## Optional, ImplicitlyUnwrappedOptional, Collections and so on

'HandyJSON' support classes/structs composed of `optional`, `implicitlyUnwrappedOptional`, `array`, `dictionary`, `objective-c base type`, `nested type` etc. properties.

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

`HandyJSON` supports deserialization from designated path of JSON.

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

Notice that all the properties of a class/struct need to deserialized should be type comformed to `HandyJSON`.

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

A subclass need deserialization, it's superclass need to comform to `HandyJSON`.

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

## Custom Mapping

`HandyJSON` let you customize the key mapping to JSON fields, or parsing method of any property. All you need to do is implementing an optional `mapping` function, do things in it.

```
class Cat: HandyJSON {
    var id: Int64!
    var name: String!
    var parent: (String, String)?

    required init() {}

    func mapping(mapper: CustomMapper) {
        // specify 'cat_id' field in json map to 'id' property in object
        mapper.specify(&id, name: "cat_id")

        // specify 'parent' field in json parse as following to 'parent' property in object
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

* `Int`/`Bool`/`Double`/`Float`/`String`/`NSNumber`/`NSString`

* `NSArray/NSDictionary`

* `Int8/Int16/Int32/Int64`/`UInt8/UInt16/UInt23/UInt64`

* `Optional<T>/ImplicitUnwrappedOptional<T>` // T is one of the above types

* `Array<T>` // T is one of the above types

* `Dictionary<String, T>` // T is one of the above types

* Nested of aboves

# Serialization

## The Basics

You need to do nothing special to support serialization. Define the class/struct, get the instances, then serialize it.

```
class Animal {
    var name: String?
    var height: Int?

    init(name: String, height: Int) {
        self.name = name
        self.height = height
    }
}

let cat = Animal(name: "cat", height: 30)
print(JSONSerializer.serializeToJSON(cat)!)
print(JSONSerializer.serializeToJSON(cat, prettify: true)!)
```

## Complex Object

Still need no extra effort.

```
enum Gender: String {
    case Male = "male"
    case Female = "Female"
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

print(JSONSerializer.serializeToJSON(student)!)
print(JSONSerializer.serializeToJSON(student, prettify: true)!)
```

# Compatibility

* Pass test on 32-bit/64bit simulator/real device

* Pass test on iOS 8.0+/9.0+/10.0+

* Pass test while compiled with Swift 2.2、2.3、3.0 beta

# To Do

* Support non-object (such as basic type, array, dictionany) type deserializing directly

* A branch for Swift 3.0

* Support macOS
