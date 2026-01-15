//
//  SwiftDesignOS.swift
//  Swift DesignOS
//
//  Public API for the Swift DesignOS library
//

import Foundation

public func loadProductData() -> ProductData {
    let overview: ProductOverview?
    let roadmap: ProductRoadmap?

    if ProductLoader.hasProductOverview() {
        do {
            overview = try ProductLoader.loadProductOverview()
        } catch {
            overview = nil
        }
    } else {
        overview = nil
    }

    if ProductLoader.hasProductRoadmap() {
        do {
            roadmap = try ProductLoader.loadProductRoadmap()
        } catch {
            roadmap = nil
        }
    } else {
        roadmap = nil
    }

    let dataModel: DataModel?
    if DataModelLoader.hasDataModel() {
        do {
            dataModel = try DataModelLoader.loadDataModel()
        } catch {
            dataModel = nil
        }
    } else {
        dataModel = nil
    }

    let designSystem: DesignSystem?
    if DesignSystemLoader.hasDesignSystem() {
        do {
            designSystem = try DesignSystemLoader.loadDesignSystem()
        } catch {
            designSystem = nil
        }
    } else {
        designSystem = nil
    }

    let shell: ShellInfo?
    do {
        shell = try ShellLoader.loadShellInfo()
    } catch {
        shell = nil
    }

    return ProductData(
        overview: overview,
        roadmap: roadmap,
        dataModel: dataModel,
        designSystem: designSystem,
        shell: shell
    )
}

public func hasProductOverview() -> Bool {
    ProductLoader.hasProductOverview()
}

public func hasProductRoadmap() -> Bool {
    ProductLoader.hasProductRoadmap()
}

public func hasDataModel() -> Bool {
    DataModelLoader.hasDataModel()
}

public func hasDesignSystem() -> Bool {
    DesignSystemLoader.hasDesignSystem()
}

public func hasShellSpec() -> Bool {
    ShellLoader.hasShellSpec()
}

public func loadSectionData(sectionId: String) -> SectionData {
    SectionLoader.loadSectionData(sectionId: sectionId)
}

public func getAllSectionIds() -> [String] {
    SectionLoader.getAllSectionIds()
}
