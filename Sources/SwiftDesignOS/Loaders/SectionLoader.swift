//
//  SectionLoader.swift
//  Swift DesignOS
//
//  Loader for section specification markdown files
//
//  SPDX-License-Identifier: MIT
//  Copyright (c) 2025 CasJam Media LLC (Builder Methods)
//

import Foundation

enum SectionLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidMarkdown(String)
    case parsingError(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .invalidMarkdown(let reason):
            return "Invalid markdown: \(reason)"
        case .parsingError(let reason):
            return "Parsing error: \(reason)"
        }
    }
}

public struct SectionLoader {

    private static let productRoot = "product"

    public static func loadSectionData(sectionId: String) -> SectionData {
        let sectionPath = "\(productRoot)/sections/\(sectionId)"

        let spec = loadSpec(at: sectionPath)
        let specParsed = parseSpec(spec)
        let data = loadData(at: sectionPath)
        let screenDesigns = loadScreenDesigns(at: sectionPath, sectionId: sectionId)
        let screenshots = loadScreenshots(at: sectionPath, sectionId: sectionId)

        return SectionData(
            sectionId: sectionId,
            spec: spec,
            specParsed: specParsed,
            data: data,
            screenDesigns: screenDesigns,
            screenshots: screenshots
        )
    }

    private static func loadSpec(at path: String) -> String? {
        let specPath = "\(path)/spec.md"
        return try? String(contentsOfFile: specPath, encoding: .utf8)
    }

    private static func parseSpec(_ spec: String?) -> ParsedSpec? {
        guard let spec = spec else { return nil }

        let lines = spec.components(separatedBy: .newlines)
        var currentSection: String?
        var title: String?
        var overview: String?
        var userFlows: [String] = []
        var uiRequirements: [String] = []

        for line in lines {
            if line.hasPrefix("# ") {
                title = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("## ") {
                let section = line.dropFirst(3).lowercased()
                currentSection = section
            } else if line.hasPrefix("- ") {
                let content = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
                if currentSection == "user flows" {
                    userFlows.append(content)
                } else if currentSection == "ui requirements" {
                    uiRequirements.append(content)
                }
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if currentSection == "overview" {
                    overview = (overview ?? "") + " " + trimmed
                }
            }
        }

        let useShell = spec.lowercased().contains("shell") && spec.lowercased().contains("use")

        return ParsedSpec(
            title: title ?? "",
            overview: overview?.trimmingCharacters(in: .whitespaces) ?? "",
            userFlows: userFlows,
            uiRequirements: uiRequirements,
            useShell: useShell
        )
    }

    private static func loadData(at path: String) -> [String: Any]? {
        let dataPath = "\(path)/data.json"
        guard let content = try? String(contentsOfFile: dataPath, encoding: .utf8),
              let data = content.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }

        return json
    }

    private static func loadScreenDesigns(at path: String, sectionId: String) -> [ScreenDesignInfo] {
        let designsPath = "\(path)/designs"

        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: designsPath) else {
            return []
        }

        return contents.compactMap { filename in
            guard filename.hasSuffix(".swift") || filename.hasSuffix(".json") else { return nil }

            let name = filename.replacingOccurrences(of: ".swift", with: "").replacingOccurrences(of: ".json", with: "")
            let fullPath = "\(designsPath)/\(filename)"
            let componentName = filename.hasSuffix(".swift") ? name : ""

            return ScreenDesignInfo(
                name: name,
                path: fullPath,
                componentName: componentName
            )
        }
    }

    private static func loadScreenshots(at path: String, sectionId: String) -> [ScreenshotInfo] {
        let screenshotsPath = "\(path)/screenshots"

        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: screenshotsPath) else {
            return []
        }

        let imageExtensions = ["png", "jpg", "jpeg", "gif", "webp", "tiff"]

        return contents.compactMap { filename in
            let ext = (filename as NSString).pathExtension.lowercased()
            guard imageExtensions.contains(ext) else { return nil }

            let name = filename.replacingOccurrences(of: ".\(ext)", with: "")
            let fullPath = "\(screenshotsPath)/\(filename)"

            guard let url = URL(string: fullPath) else { return nil }

            return ScreenshotInfo(
                name: name,
                path: fullPath,
                url: url
            )
        }
    }

    public static func getAllSectionIds() -> [String] {
        let sectionsPath = "\(productRoot)/sections"

        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: sectionsPath) else {
            return []
        }

        var sectionIds: [String] = []
        var isDirectory: ObjCBool = false

        for item in contents {
            let fullPath = "\(sectionsPath)/\(item)"
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory),
               isDirectory.boolValue {
                sectionIds.append(item)
            }
        }

        return sectionIds.sorted()
    }
}
