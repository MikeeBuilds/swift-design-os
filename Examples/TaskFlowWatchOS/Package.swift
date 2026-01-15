// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskFlowWatchOS",
    platforms: [
        .watchOS(.v10)
    ],
    dependencies: [
        .package(name: "SwiftDesignOS", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "TaskFlowWatchOS",
            dependencies: ["SwiftDesignOS"],
            path: "Sources",
            exclude: ["README.md"]
        )
    ]
)
