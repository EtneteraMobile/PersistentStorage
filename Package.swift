// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersistentStorage",
    platforms: [
        .iOS(.v15), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "PersistentStorage",
            targets: ["PersistentStorage"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PersistentStorage",
            dependencies: [],
            path: "PersistentStorage/Sources"
        )
    ]
)
