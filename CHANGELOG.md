# Change Log

## [Unreleased](https://github.com/alibaba/HandyJSON/tree/HEAD)

[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.7.2...HEAD)

**Closed issues:**

- Support automatic conversions between JSON keys and property names [\#158](https://github.com/alibaba/HandyJSON/issues/158)
- Model 转 Json  error [\#157](https://github.com/alibaba/HandyJSON/issues/157)
- Why "To conform to 'HandyJSON', a class need to implement an empty initializer."? [\#153](https://github.com/alibaba/HandyJSON/issues/153)
- Swift4 Support [\#149](https://github.com/alibaba/HandyJSON/issues/149)
- 这种复杂的数据格式怎么处理 [\#148](https://github.com/alibaba/HandyJSON/issues/148)
- 更新一下 pod 和 Carthage [\#146](https://github.com/alibaba/HandyJSON/issues/146)
- 请教大神一个关于toJSON的问题 [\#133](https://github.com/alibaba/HandyJSON/issues/133)
- 升级到1.7.1，String的null被解析成"\<null\>"传入属性中 [\#125](https://github.com/alibaba/HandyJSON/issues/125)

**Merged pull requests:**

- add aftermap\(\) for set special properties after mapping [\#176](https://github.com/alibaba/HandyJSON/pull/176) ([levanlongktmt](https://github.com/levanlongktmt))

## [1.7.2](https://github.com/alibaba/HandyJSON/tree/1.7.2) (2017-07-04)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.7.1...1.7.2)

**Implemented enhancements:**

- 多个json key映射同一个属性应该怎么做？ [\#103](https://github.com/alibaba/HandyJSON/issues/103)

**Closed issues:**

- 请教一下，static 修饰的属性默认是怎么处理的，是忽略了吗 [\#152](https://github.com/alibaba/HandyJSON/issues/152)
- 直接写内存是艺高胆大的艺术行为，有没有审核不过的风险？ [\#151](https://github.com/alibaba/HandyJSON/issues/151)
- 关于字符串解析出\<null\>的问题 [\#150](https://github.com/alibaba/HandyJSON/issues/150)
- 多层数据解析问题请教 [\#147](https://github.com/alibaba/HandyJSON/issues/147)
- 能否实现拼接子字典的元素给一个 [\#145](https://github.com/alibaba/HandyJSON/issues/145)
- 能否支持自动匹配JSON中大写字母开头的word [\#144](https://github.com/alibaba/HandyJSON/issues/144)
- mapping正向与反向的问题 [\#142](https://github.com/alibaba/HandyJSON/issues/142)
- 时间类型字符串能自动转成Date类型吗 [\#141](https://github.com/alibaba/HandyJSON/issues/141)
- String数组报错 [\#140](https://github.com/alibaba/HandyJSON/issues/140)
- 对于由不同的 Json 的转为同一类型的 Model 的 Mapping 问题 [\#139](https://github.com/alibaba/HandyJSON/issues/139)
- 请问大神，关于json转模型的问题 [\#137](https://github.com/alibaba/HandyJSON/issues/137)
- 如何自动序列化Model中的\[Model2\]数组 [\#135](https://github.com/alibaba/HandyJSON/issues/135)
- HandyJSON 如何在realmSwift 中使用？ [\#134](https://github.com/alibaba/HandyJSON/issues/134)
- 请教大神，反序列话的时候，无法自定义映射 [\#132](https://github.com/alibaba/HandyJSON/issues/132)
- 通过JSON对象转换model问题 [\#131](https://github.com/alibaba/HandyJSON/issues/131)
- 能不能解析Json数据而不是JsonString数据 [\#128](https://github.com/alibaba/HandyJSON/issues/128)
- Realm List类型不兼容 [\#127](https://github.com/alibaba/HandyJSON/issues/127)
- 乱码问题 [\#126](https://github.com/alibaba/HandyJSON/issues/126)
- 自定义映射和排除操作符提示未知,求解? [\#124](https://github.com/alibaba/HandyJSON/issues/124)
- 计算型属性不能toJSON? [\#122](https://github.com/alibaba/HandyJSON/issues/122)
- NSManagedObject 不能 toJSON\(\) [\#121](https://github.com/alibaba/HandyJSON/issues/121)
- 请问有没有description [\#120](https://github.com/alibaba/HandyJSON/issues/120)
- 关于实现原理和Swift版本兼容性问题 [\#116](https://github.com/alibaba/HandyJSON/issues/116)
- Nested Objects Lost In 1.6.1 Version [\#111](https://github.com/alibaba/HandyJSON/issues/111)
- HandyJson + Realm 冲突 [\#107](https://github.com/alibaba/HandyJSON/issues/107)

**Merged pull requests:**

- fixed null string as nil [\#136](https://github.com/alibaba/HandyJSON/pull/136) ([crwnet](https://github.com/crwnet))
- Add Swift Package Manager support. [\#130](https://github.com/alibaba/HandyJSON/pull/130) ([maintainer](https://github.com/maintainer))
- release 1.7.1 [\#119](https://github.com/alibaba/HandyJSON/pull/119) ([xuyecan](https://github.com/xuyecan))

## [1.7.1](https://github.com/alibaba/HandyJSON/tree/1.7.1) (2017-04-18)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.7.0...1.7.1)

**Closed issues:**

- 组合对象的时候，有个属性是个数组，如何转化成\[model\]类型的数组啊？ [\#118](https://github.com/alibaba/HandyJSON/issues/118)

## [1.7.0](https://github.com/alibaba/HandyJSON/tree/1.7.0) (2017-04-15)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.6.1...1.7.0)

**Closed issues:**

- 如何处理jsonArray？ [\#115](https://github.com/alibaba/HandyJSON/issues/115)
- Xcode更新到8.3之后报错 [\#114](https://github.com/alibaba/HandyJSON/issues/114)
- 泛型转换不成功 [\#113](https://github.com/alibaba/HandyJSON/issues/113)
- 提一个建议，望改进 [\#109](https://github.com/alibaba/HandyJSON/issues/109)
- 编译错误 [\#108](https://github.com/alibaba/HandyJSON/issues/108)
- 提一个1.6.1版本上的bug [\#106](https://github.com/alibaba/HandyJSON/issues/106)
- 請教如何在解析之時，去掉String屬性內容後的空格 [\#105](https://github.com/alibaba/HandyJSON/issues/105)
- mapping 无效 [\#104](https://github.com/alibaba/HandyJSON/issues/104)
- 将model类型转化为JSON的时候 出现了问题 [\#102](https://github.com/alibaba/HandyJSON/issues/102)
- 很奇怪的编译错误 [\#101](https://github.com/alibaba/HandyJSON/issues/101)
- 给属性赋值时didSet 和willSet 方法都不调用了，有方法让它俩都调用吗 [\#100](https://github.com/alibaba/HandyJSON/issues/100)
- 望新增接口支持 [\#96](https://github.com/alibaba/HandyJSON/issues/96)

**Merged pull requests:**

- add new features [\#117](https://github.com/alibaba/HandyJSON/pull/117) ([xuyecan](https://github.com/xuyecan))
- fix some issues when interact with objc-runtime [\#110](https://github.com/alibaba/HandyJSON/pull/110) ([xuyecan](https://github.com/xuyecan))

## [1.6.1](https://github.com/alibaba/HandyJSON/tree/1.6.1) (2017-03-08)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.6.0...1.6.1)

**Closed issues:**

- Xcode v.10.3 build error [\#94](https://github.com/alibaba/HandyJSON/issues/94)
- 含有特殊字符的数据序列化后不能再反序列化！ [\#93](https://github.com/alibaba/HandyJSON/issues/93)
- 序列化不支持嵌套对象 [\#92](https://github.com/alibaba/HandyJSON/issues/92)

**Merged pull requests:**

- fix serialize nsstring/nsnumber issue & improve tests [\#99](https://github.com/alibaba/HandyJSON/pull/99) ([xuyecan](https://github.com/xuyecan))
- Dev xyc [\#95](https://github.com/alibaba/HandyJSON/pull/95) ([xuyecan](https://github.com/xuyecan))

## [1.6.0](https://github.com/alibaba/HandyJSON/tree/1.6.0) (2017-02-27)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.5.2...1.6.0)

**Closed issues:**

- 序列化之后不能反序列化 [\#91](https://github.com/alibaba/HandyJSON/issues/91)
- Unable to find a specification for `HandyJSON \(~\> 0.4.0\)` [\#89](https://github.com/alibaba/HandyJSON/issues/89)
- 换行符的问题 \n [\#86](https://github.com/alibaba/HandyJSON/issues/86)
- 这种嵌套结构是否可以解析,我一直解析失败 [\#85](https://github.com/alibaba/HandyJSON/issues/85)
- 手动安装失败 [\#83](https://github.com/alibaba/HandyJSON/issues/83)
- Case insensitive deserialisation [\#80](https://github.com/alibaba/HandyJSON/issues/80)
- Would it be possible to not have objects inherit from HandyJSON? [\#79](https://github.com/alibaba/HandyJSON/issues/79)
- 关于 typealias Byte = Int8 的疑问 [\#78](https://github.com/alibaba/HandyJSON/issues/78)
- Array\<Object\> 这样得出来的json 是使用不了的 都变成了\[Any?,...\] 了...类型丢了.但是打印出来的json是正常的 [\#76](https://github.com/alibaba/HandyJSON/issues/76)
- 当类型中存在Date类型的字段时, 序列化失败 [\#74](https://github.com/alibaba/HandyJSON/issues/74)
- 1.5.0 的更新中存在一个bug [\#72](https://github.com/alibaba/HandyJSON/issues/72)
- 手动导入HandyJSON后，总会提示 you don't have permission to view it [\#71](https://github.com/alibaba/HandyJSON/issues/71)
- json 里的数字 不能转成model里的string吗 [\#57](https://github.com/alibaba/HandyJSON/issues/57)

**Merged pull requests:**

- 对  \_serializeToJSON  时增加json字符转义处理 [\#88](https://github.com/alibaba/HandyJSON/pull/88) ([xiezuan](https://github.com/xiezuan))
- format code style & logic optimization [\#87](https://github.com/alibaba/HandyJSON/pull/87) ([xuyecan](https://github.com/xuyecan))
- add missing "import Foundation" statement for serializer.swift file [\#84](https://github.com/alibaba/HandyJSON/pull/84) ([banxi1988](https://github.com/banxi1988))
- Simplify deserialize usage [\#82](https://github.com/alibaba/HandyJSON/pull/82) ([banxi1988](https://github.com/banxi1988))
- Simplify protocol [\#77](https://github.com/alibaba/HandyJSON/pull/77) ([banxi1988](https://github.com/banxi1988))

## [1.5.2](https://github.com/alibaba/HandyJSON/tree/1.5.2) (2017-01-09)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.5.1...1.5.2)

**Closed issues:**

- Problem when serializing to simple Dictionnary with Enum [\#67](https://github.com/alibaba/HandyJSON/issues/67)
- 如果我的model里有一个 var data: Any? any类型的可选属性，转换一直为nil [\#66](https://github.com/alibaba/HandyJSON/issues/66)
- How to specify mapper for serialization? [\#64](https://github.com/alibaba/HandyJSON/issues/64)

## [1.5.1](https://github.com/alibaba/HandyJSON/tree/1.5.1) (2017-01-09)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.5.0...1.5.1)

**Closed issues:**

- 添加HandyJSON后总是会提示 you don't have permission to view it [\#70](https://github.com/alibaba/HandyJSON/issues/70)
- 能否支持忽略大小写? [\#65](https://github.com/alibaba/HandyJSON/issues/65)

## [1.5.0](https://github.com/alibaba/HandyJSON/tree/1.5.0) (2017-01-08)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.4.0...1.5.0)

**Closed issues:**

- mapper.specify用法请教 [\#63](https://github.com/alibaba/HandyJSON/issues/63)
- mapper.specify\(property: &T, name: "String"\), name 参数能否支持路径解析 [\#62](https://github.com/alibaba/HandyJSON/issues/62)
- Swift3.0 如何使用T 定义我要声明的Data [\#61](https://github.com/alibaba/HandyJSON/issues/61)
- Each property should be handyjson-property type [\#59](https://github.com/alibaba/HandyJSON/issues/59)

**Merged pull requests:**

- support RawPresentable like a charm [\#69](https://github.com/alibaba/HandyJSON/pull/69) ([xuyecan](https://github.com/xuyecan))
- lots of refactor and new features [\#68](https://github.com/alibaba/HandyJSON/pull/68) ([xuyecan](https://github.com/xuyecan))
- support exclude property & release 1.4.0 [\#60](https://github.com/alibaba/HandyJSON/pull/60) ([xuyecan](https://github.com/xuyecan))

## [1.4.0](https://github.com/alibaba/HandyJSON/tree/1.4.0) (2016-12-10)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.3.0...1.4.0)

**Closed issues:**

- 类型自适应 无法完成 [\#58](https://github.com/alibaba/HandyJSON/issues/58)
- JSONSerializer能否支持mapping？ [\#56](https://github.com/alibaba/HandyJSON/issues/56)
- sub class object missed during deserialization [\#53](https://github.com/alibaba/HandyJSON/issues/53)
- pod 只找到0.1.0版本 [\#49](https://github.com/alibaba/HandyJSON/issues/49)

## [1.3.0](https://github.com/alibaba/HandyJSON/tree/1.3.0) (2016-11-22)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.2.1...1.3.0)

**Closed issues:**

- deserializeModelArrayFrom 为什么没有 designatedPath参数？ [\#48](https://github.com/alibaba/HandyJSON/issues/48)
- 对于JSON中某个String字段是一个JSON字符串有没有简便的转化方式 [\#45](https://github.com/alibaba/HandyJSON/issues/45)
- 能否实现Int到String的自动转换 [\#44](https://github.com/alibaba/HandyJSON/issues/44)
- 对枚举类型的实现效果不佳 [\#43](https://github.com/alibaba/HandyJSON/issues/43)
- Undefined symbols for architecture i386: [\#42](https://github.com/alibaba/HandyJSON/issues/42)
- deserializeModelArrayFrom\(\)返回 \[T\]? 使用起来是不是会更方便一些? [\#40](https://github.com/alibaba/HandyJSON/issues/40)
- 当model中某个String变量，存的是json字符格式解析不出来 [\#37](https://github.com/alibaba/HandyJSON/issues/37)
- crash  [\#36](https://github.com/alibaba/HandyJSON/issues/36)
- 如何应对服务端和前端命名不一致的问题？ [\#34](https://github.com/alibaba/HandyJSON/issues/34)
- Carthage warning [\#32](https://github.com/alibaba/HandyJSON/issues/32)

**Merged pull requests:**

- add testcases/deserialize array support designating path [\#52](https://github.com/alibaba/HandyJSON/pull/52) ([xuyecan](https://github.com/xuyecan))
- fix warnning [\#51](https://github.com/alibaba/HandyJSON/pull/51) ([cijianzy](https://github.com/cijianzy))
- support enum perfectly [\#50](https://github.com/alibaba/HandyJSON/pull/50) ([xuyecan](https://github.com/xuyecan))
- fix designated path issue & add cn readme [\#47](https://github.com/alibaba/HandyJSON/pull/47) ([xuyecan](https://github.com/xuyecan))
- do some optimization & add testcases [\#46](https://github.com/alibaba/HandyJSON/pull/46) ([xuyecan](https://github.com/xuyecan))
- Use Swift's Syntactic Sugar [\#41](https://github.com/alibaba/HandyJSON/pull/41) ([wongzigii](https://github.com/wongzigii))
- update README.md, use `require` instead of `need`. [\#39](https://github.com/alibaba/HandyJSON/pull/39) ([swwlqw](https://github.com/swwlqw))
- Syntax highlightion in README [\#38](https://github.com/alibaba/HandyJSON/pull/38) ([wongzigii](https://github.com/wongzigii))
- Add iOS test target [\#35](https://github.com/alibaba/HandyJSON/pull/35) ([cijianzy](https://github.com/cijianzy))

## [1.2.1](https://github.com/alibaba/HandyJSON/tree/1.2.1) (2016-11-04)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.2.0...1.2.1)

**Closed issues:**

- Xcode8.1编译报错 [\#28](https://github.com/alibaba/HandyJSON/issues/28)

## [1.2.0](https://github.com/alibaba/HandyJSON/tree/1.2.0) (2016-11-01)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.1.0...1.2.0)

**Closed issues:**

- 请问下一个版本大概什么时候能发布呢? [\#27](https://github.com/alibaba/HandyJSON/issues/27)
- 模型中有一个，模型数组属性。 [\#25](https://github.com/alibaba/HandyJSON/issues/25)
- How can I use this handsome library on Android platform  [\#24](https://github.com/alibaba/HandyJSON/issues/24)
- 请问有json数组转模型数组的方法么? [\#23](https://github.com/alibaba/HandyJSON/issues/23)
- Support Linux [\#22](https://github.com/alibaba/HandyJSON/issues/22)
- 为什么字典转模型时 传参数是 ObjectC 的 NSDictionary 类型 而不是 Swift 的 Collection 类型 [\#21](https://github.com/alibaba/HandyJSON/issues/21)
- 小问题 [\#20](https://github.com/alibaba/HandyJSON/issues/20)
- Manual Installation [\#13](https://github.com/alibaba/HandyJSON/issues/13)

**Merged pull requests:**

- ready for 1.2.0 [\#31](https://github.com/alibaba/HandyJSON/pull/31) ([xuyecan](https://github.com/xuyecan))
- support array formal json string [\#30](https://github.com/alibaba/HandyJSON/pull/30) ([xuyecan](https://github.com/xuyecan))
- fix compile error on xcode8 [\#29](https://github.com/alibaba/HandyJSON/pull/29) ([aixinyunchou](https://github.com/aixinyunchou))
- refactor serialization to support more features [\#26](https://github.com/alibaba/HandyJSON/pull/26) ([xuyecan](https://github.com/xuyecan))
- Fix docs link [\#19](https://github.com/alibaba/HandyJSON/pull/19) ([khasinski](https://github.com/khasinski))
- Add carthage badge [\#18](https://github.com/alibaba/HandyJSON/pull/18) ([cijianzy](https://github.com/cijianzy))
- add the manually installation section [\#17](https://github.com/alibaba/HandyJSON/pull/17) ([xuyecan](https://github.com/xuyecan))

## [1.1.0](https://github.com/alibaba/HandyJSON/tree/1.1.0) (2016-10-05)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/0.4.0...1.1.0)

**Merged pull requests:**

- Update file directory && Fix copy bundle [\#16](https://github.com/alibaba/HandyJSON/pull/16) ([cijianzy](https://github.com/cijianzy))
- Update file directory && Fix copy bundle [\#15](https://github.com/alibaba/HandyJSON/pull/15) ([cijianzy](https://github.com/cijianzy))

## [0.4.0](https://github.com/alibaba/HandyJSON/tree/0.4.0) (2016-10-04)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/1.0.0...0.4.0)

**Merged pull requests:**

- Support all platform [\#14](https://github.com/alibaba/HandyJSON/pull/14) ([cijianzy](https://github.com/cijianzy))
- code formatting [\#12](https://github.com/alibaba/HandyJSON/pull/12) ([xuyecan](https://github.com/xuyecan))
- add chinese doc link [\#11](https://github.com/alibaba/HandyJSON/pull/11) ([xuyecan](https://github.com/xuyecan))
- release 1.0.0 [\#10](https://github.com/alibaba/HandyJSON/pull/10) ([xuyecan](https://github.com/xuyecan))

## [1.0.0](https://github.com/alibaba/HandyJSON/tree/1.0.0) (2016-10-01)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/0.3.0...1.0.0)

## [0.3.0](https://github.com/alibaba/HandyJSON/tree/0.3.0) (2016-10-01)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/0.2.0...0.3.0)

**Closed issues:**

- good job! [\#6](https://github.com/alibaba/HandyJSON/issues/6)

**Merged pull requests:**

- Travis-ci support swift3.0 [\#9](https://github.com/alibaba/HandyJSON/pull/9) ([cijianzy](https://github.com/cijianzy))
- migrate to swift 3.0 [\#8](https://github.com/alibaba/HandyJSON/pull/8) ([xuyecan](https://github.com/xuyecan))
- reorganize source files and optimize naming [\#7](https://github.com/alibaba/HandyJSON/pull/7) ([xuyecan](https://github.com/xuyecan))

## [0.2.0](https://github.com/alibaba/HandyJSON/tree/0.2.0) (2016-09-27)
[Full Changelog](https://github.com/alibaba/HandyJSON/compare/0.1.0...0.2.0)

**Closed issues:**

- struct can't have designated initializer. [\#3](https://github.com/alibaba/HandyJSON/issues/3)

**Merged pull requests:**

- Dev xyc [\#5](https://github.com/alibaba/HandyJSON/pull/5) ([xuyecan](https://github.com/xuyecan))
- Add codecov badge to master. [\#4](https://github.com/alibaba/HandyJSON/pull/4) ([cijianzy](https://github.com/cijianzy))
- Add badge [\#2](https://github.com/alibaba/HandyJSON/pull/2) ([cijianzy](https://github.com/cijianzy))
- Add support for serializtion [\#1](https://github.com/alibaba/HandyJSON/pull/1) ([cijianzy](https://github.com/cijianzy))

## [0.1.0](https://github.com/alibaba/HandyJSON/tree/0.1.0) (2016-09-21)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*