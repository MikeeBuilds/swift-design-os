//
//  SwiftDesignOS.h
//  Swift DesignOS
//
//  Public API for the Swift DesignOS library

import Foundation

@_exported import struct ProductOverview
@_exported import struct Problem
@_exported import struct Section
@_exported import struct ProductRoadmap
@_exported import struct Entity
@_exported import struct DataModel
@_exported import struct ColorTokens
@_exported import struct TypographyTokens
@_exported import struct DesignSystem
@_exported import struct ShellSpec
@_exported import struct ShellInfo
@_exported import struct ProductData
@_exported import struct ParsedSpec
@_exported import struct ScreenDesignInfo
@_exported import struct ScreenshotInfo
@_exported import struct SectionData

// MARK: - Product Loading

/// Loads all product data from markdown and JSON files
public func loadProductData() -> ProductData {
    // TODO: Implement markdown and JSON file loading
    return ProductData(
        overview: nil,
        roadmap: nil,
        dataModel: nil,
        designSystem: nil,
        shell: nil
    )
}

/// Checks if product overview exists
public func hasProductOverview() -> Bool {
    // TODO: Implement file checking
    return false
}

/// Checks if product roadmap exists
public func hasProductRoadmap() -> Bool {
    // TODO: Implement file checking
    return false
}

// MARK: - Section Loading

/// Loads data for a specific section
public func loadSectionData(sectionId: String) -> SectionData {
    // TODO: Implement section data loading
    return SectionData(
        sectionId: sectionId,
        spec: nil,
        specParsed: nil,
        data: nil,
        screenDesigns: [],
        screenshots: []
    )
}

/// Gets all section IDs
public func getAllSectionIds() -> [String] {
    // TODO: Implement section discovery
    return []
}
