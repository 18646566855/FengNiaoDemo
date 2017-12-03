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
        .package(url: "https://github.com/kylef/PathKit.git",
                 from: "0.8.0"),
        .package(url: "https://github.com/kylef/Spectre.git",
                 from: "0.7.2")
    ],
    targets: [
        .target(name: "FengniaoKit", dependencies: ["PathKit"]),
        .target(name: "Fengniao", dependencies: ["FengniaoKit",
                                                 "Rainbow",
                                                 "CommandLine"]),
        .testTarget(name: "FengNiaoKitTests",
                    dependencies: ["FengniaoKit",
                                   "Rainbow",
                                   "CommandLine"],
                    exclude: [ "Tests/Fixtures" ])
    ]
)
