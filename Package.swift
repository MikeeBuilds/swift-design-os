import PackageDescription

let package = Package(
    name: "SwiftDesignOS",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftDesignOS",
            targets: ["SwiftDesignOS"]
        )
    ],
    targets: [
        .target(
            name: "SwiftDesignOS",
            dependencies: [
                .product(name: "SwiftMarkdown", package: "SwiftMarkdown")
            ]
        )
    ]
)
