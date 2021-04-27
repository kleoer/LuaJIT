// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LuaJIT",
    platforms: [
        .iOS("8.0")
    ],
    products: [
        .library(
            name: "LuaJIT",
            targets: ["libluajit"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(name: "libluajit",
                      path: "lib/libluajit.xcframework")
    ]
)
