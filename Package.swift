// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [
        .iOS(.v15),
        .watchOS(.v8),
        .tvOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]),
    ],
    targets: [
        .target(
            name: "NetworkKit",
            dependencies: []),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"],
            resources: [
                .process("Resources/test_image.jpeg")
            ]),
    ]
)
