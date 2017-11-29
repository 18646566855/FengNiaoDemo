// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Fengniao",
    dependencies: [
        .package(url: "https://github.com/jatoben/CommandLine",
                 from: "3.0.0-pre1"),
        .package(url: "https://github.com/onevcat/Rainbow",
                 from: "3.0.0"),
        .package(url: "https://github.com/kylef/PathKit",
                 from: "0.8.0")
    ],
    targets: [
        .target(name: "FengniaoKit", dependencies: ["PathKit"]),
        .target(name: "Fengniao", dependencies: [ "CommandLine",
                                                  "FengniaoKit",
                                                  "Rainbow",
                                                  "PathKit"])
    ]
)
