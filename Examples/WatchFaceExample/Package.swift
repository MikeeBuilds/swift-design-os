// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WatchFaceExample",
    platforms: [
        .watchOS(.v10)
    ],
    dependencies: [
        .package(name: "SwiftDesignOS", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "WatchFaceExample",
            dependencies: ["SwiftDesignOS"],
            path: "Sources",
            exclude: ["README.md"]
        )
    ]
)
