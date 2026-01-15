// swift-tools-version: 6.0
// Package.swift
//
// The missing design process between your product idea and your Swift/SwiftUI codebase.
// Swift DesignOS helps you define your product vision, structure your data model,
// design your UI, and export production-ready components for implementation.
//
// Repository: https://github.com/YOUR_ORG/swift-design-os
// Documentation: https://github.com/YOUR_ORG/swift-design-os/blob/main/README.md
// License: MIT
// Authors: Swift DesignOS Contributors
//
// Swift Package Index keywords: swift, swiftui, design-system, product-planning, ui-design, ai-assisted
//
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
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "SwiftDesignOS",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ]
        )
    ]
)
