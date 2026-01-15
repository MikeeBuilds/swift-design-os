// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TaskFlowExample",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [
        .package(name: "SwiftDesignOS", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "TaskFlowExample",
            dependencies: ["SwiftDesignOS"],
            path: "Sources",
            exclude: ["README.md"]
        )
    ]
)
