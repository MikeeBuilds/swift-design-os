// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskFlowiOS",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [
        .package(name: "SwiftDesignOS", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "TaskFlowiOS",
            dependencies: ["SwiftDesignOS"],
            path: "Sources",
            exclude: ["README.md"]
        )
    ]
)
