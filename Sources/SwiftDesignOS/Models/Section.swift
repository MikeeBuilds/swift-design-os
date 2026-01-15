//
//  Section.swift
//  Swift DesignOS
//
//  Data models for section definitions

import Foundation

/// Parsed section specification
struct ParsedSpec {
    let title: String
    let overview: String
    let userFlows: [String]
    let uiRequirements: [String]
    let useShell: Bool
}

/// Screen design information
struct ScreenDesignInfo {
    let name: String
    let path: String
    let componentName: String
}

/// Screenshot information
struct ScreenshotInfo {
    let name: String
    let path: String
    let url: URL
}

/// Section data including spec, data, designs, and screenshots
struct SectionData {
    let sectionId: String
    let spec: String?
    let specParsed: ParsedSpec?
    let data: [String: Any]?
    let screenDesigns: [ScreenDesignInfo]
    let screenshots: [ScreenshotInfo]
}
