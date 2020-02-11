// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HandyJSON",
    products: [
        .library(name: "HandyJSON", targets: ["HandyJSON"]),
    ],
    targets: [
        .target(
            name: "HandyJSON",
	    dependencies: [],
	    path: "Source"
        )
    ]
)

