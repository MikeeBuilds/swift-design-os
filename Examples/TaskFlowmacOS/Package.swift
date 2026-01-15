// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskFlowmacOS",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(name: "SwiftDesignOS", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "TaskFlowmacOS",
            dependencies: ["SwiftDesignOS"],
            path: "Sources",
            exclude: ["README.md"]
        )
    ]
)
