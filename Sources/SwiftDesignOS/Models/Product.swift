//
//  Product.swift
//  Swift DesignOS
//
//  Core data models for product definition

import Foundation

public struct ProductOverview {
    public let name: String
    public let description: String
    public let problems: [Problem]
    public let features: [String]

    public init(name: String, description: String, problems: [Problem], features: [String]) {
        self.name = name
        self.description = description
        self.problems = problems
        self.features = features
    }
}

public struct Problem {
    public let title: String
    public let solution: String

    public init(title: String, solution: String) {
        self.title = title
        self.solution = solution
    }
}

public struct Section {
    public let id: String
    public let title: String
    public let description: String
    public let order: Int

    public init(id: String, title: String, description: String, order: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.order = order
    }
}

public struct ProductRoadmap {
    public let sections: [Section]

    public init(sections: [Section]) {
        self.sections = sections
    }
}

public struct Entity {
    public let name: String
    public let description: String

    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public struct DataModel {
    public let entities: [Entity]
    public let relationships: [String]

    public init(entities: [Entity], relationships: [String]) {
        self.entities = entities
        self.relationships = relationships
    }
}

public struct ColorTokens {
    public let primary: String
    public let secondary: String
    public let neutral: String

    public init(primary: String, secondary: String, neutral: String) {
        self.primary = primary
        self.secondary = secondary
        self.neutral = neutral
    }
}

public struct TypographyTokens {
    public let heading: String
    public let body: String
    public let mono: String

    public init(heading: String, body: String, mono: String) {
        self.heading = heading
        self.body = body
        self.mono = mono
    }
}

public struct DesignSystem {
    public let colors: ColorTokens?
    public let typography: TypographyTokens?

    public init(colors: ColorTokens?, typography: TypographyTokens?) {
        self.colors = colors
        self.typography = typography
    }
}

public struct ShellSpec {
    public let raw: String
    public let overview: String
    public let navigationItems: [String]
    public let layoutPattern: String

    public init(raw: String, overview: String, navigationItems: [String], layoutPattern: String) {
        self.raw = raw
        self.overview = overview
        self.navigationItems = navigationItems
        self.layoutPattern = layoutPattern
    }
}

public struct ShellInfo {
    public let spec: ShellSpec?
    public let hasComponents: Bool

    public init(spec: ShellSpec?, hasComponents: Bool) {
        self.spec = spec
        self.hasComponents = hasComponents
    }
}

public struct ProductData {
    public let overview: ProductOverview?
    public let roadmap: ProductRoadmap?
    public let dataModel: DataModel?
    public let designSystem: DesignSystem?
    public let shell: ShellInfo?

    public init(overview: ProductOverview?, roadmap: ProductRoadmap?, dataModel: DataModel?, designSystem: DesignSystem?, shell: ShellInfo?) {
        self.overview = overview
        self.roadmap = roadmap
        self.dataModel = dataModel
        self.designSystem = designSystem
        self.shell = shell
    }
}
