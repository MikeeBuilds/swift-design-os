//
//  ShellLoader.swift
//  Swift DesignOS
//
//  Loader for shell specification markdown file
//

import Foundation

enum ShellLoaderError: Error, LocalizedError {
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

public struct ShellLoader {

    private static let productRoot = "product"

    public static func loadShellInfo() throws -> ShellInfo {
        let specPath = "\(productRoot)/shell/spec.md"

        let spec: ShellSpec?
        if fileExists(at: specPath) {
            spec = try loadShellSpec(at: specPath)
        } else {
            spec = nil
        }

        let hasComponents = directoryExists(at: "\(productRoot)/shell/components")

        return ShellInfo(
            spec: spec,
            hasComponents: hasComponents
        )
    }

    private static func loadShellSpec(at path: String) throws -> ShellSpec {
        let content = try loadFile(at: path)
        let raw = content

        let lines = content.components(separatedBy: .newlines)
        var currentSection: String?
        var overview: String?
        var navigationItems: [String] = []
        var layoutPattern: String?

        for line in lines {
            if line.hasPrefix("## ") {
                let section = line.dropFirst(3).lowercased()
                currentSection = section
            } else if line.hasPrefix("- ") {
                let content = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
                if currentSection == "navigation" {
                    navigationItems.append(content)
                } else if currentSection == "overview" {
                    overview = (overview ?? "") + " " + content
                }
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if currentSection == "overview" {
                    overview = (overview ?? "") + " " + trimmed
                } else if currentSection == "layout" {
                    layoutPattern = trimmed
                }
            }
        }

        return ShellSpec(
            raw: raw,
            overview: overview?.trimmingCharacters(in: .whitespaces) ?? "",
            navigationItems: navigationItems,
            layoutPattern: layoutPattern ?? ""
        )
    }

    public static func hasShellSpec() -> Bool {
        fileExists(at: "\(productRoot)/shell/spec.md")
    }

    private static func loadFile(at path: String) throws -> String {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            throw ShellLoaderError.fileNotFound(path)
        }

        return try String(contentsOfFile: path, encoding: .utf8)
    }

    private static func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    private static func directoryExists(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
