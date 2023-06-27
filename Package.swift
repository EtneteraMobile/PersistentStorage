// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersistentStorage",
    platforms: [
        .iOS(.v15), .macOS(.v10_15), .tvOS(.v11), .watchOS(.v4)
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
