//
//  Product.swift
//  Swift DesignOS
//
//  Core data models for product definition

import Foundation

/// Product overview containing vision, problems, and features
struct ProductOverview {
    let name: String
    let description: String
    let problems: [Problem]
    let features: [String]
}

/// A problem the product solves and how it solves it
struct Problem {
    let title: String
    let solution: String
}

/// A section in the product roadmap
struct Section {
    let id: String
    let title: String
    let description: String
    let order: Int
}

/// Product roadmap with ordered sections
struct ProductRoadmap {
    let sections: [Section]
}

/// Core entity in the data model
struct Entity {
    let name: String
    let description: String
}

/// Data model with entities and relationships
struct DataModel {
    let entities: [Entity]
    let relationships: [String]
}

/// Color tokens for design system
struct ColorTokens {
    let primary: String
    let secondary: String
    let neutral: String
}

/// Typography tokens for design system
struct TypographyTokens {
    let heading: String
    let body: String
    let mono: String
}

/// Design system configuration
struct DesignSystem {
    let colors: ColorTokens?
    let typography: TypographyTokens?
}

/// Shell specification for application shell
struct ShellSpec {
    let raw: String
    let overview: String
    let navigationItems: [String]
    let layoutPattern: String
}

/// Shell information including spec and components
struct ShellInfo {
    let spec: ShellSpec?
    let hasComponents: Bool
}

/// Complete product data
struct ProductData {
    let overview: ProductOverview?
    let roadmap: ProductRoadmap?
    let dataModel: DataModel?
    let designSystem: DesignSystem?
    let shell: ShellInfo?
}
