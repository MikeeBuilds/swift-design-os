//
//  Section.swift
//  Swift DesignOS
//
//  Data models for section definitions
//
//  SPDX-License-Identifier: MIT
//  Copyright (c) 2025 CasJam Media LLC (Builder Methods)
//

import Foundation

public struct ParsedSpec {
    public let title: String
    public let overview: String
    public let userFlows: [String]
    public let uiRequirements: [String]
    public let useShell: Bool

    public init(title: String, overview: String, userFlows: [String], uiRequirements: [String], useShell: Bool) {
        self.title = title
        self.overview = overview
        self.userFlows = userFlows
        self.uiRequirements = uiRequirements
        self.useShell = useShell
    }
}

public struct ScreenDesignInfo {
    public let name: String
    public let path: String
    public let componentName: String

    public init(name: String, path: String, componentName: String) {
        self.name = name
        self.path = path
        self.componentName = componentName
    }
}

public struct ScreenshotInfo {
    public let name: String
    public let path: String
    public let url: URL

    public init(name: String, path: String, url: URL) {
        self.name = name
        self.path = path
        self.url = url
    }
}

public struct SectionData {
    public let sectionId: String
    public let spec: String?
    public let specParsed: ParsedSpec?
    public let data: [String: Any]?
    public let screenDesigns: [ScreenDesignInfo]
    public let screenshots: [ScreenshotInfo]

    public init(sectionId: String, spec: String?, specParsed: ParsedSpec?, data: [String: Any]?, screenDesigns: [ScreenDesignInfo], screenshots: [ScreenshotInfo]) {
        self.sectionId = sectionId
        self.spec = spec
        self.specParsed = specParsed
        self.data = data
        self.screenDesigns = screenDesigns
        self.screenshots = screenshots
    }
}
