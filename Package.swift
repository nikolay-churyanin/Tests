// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Test3",
    platforms: [ .macOS(.v10_15)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Test3",
            dependencies: ["Helpers"]),
        .target(
            name: "Helpers",
            dependencies: ["Services"]),
        .target(
            name: "Services",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "Test3Tests",
            dependencies: ["Test3"])
    ]
)
