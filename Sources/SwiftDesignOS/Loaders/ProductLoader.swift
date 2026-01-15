//
//  ProductLoader.swift
//  Swift DesignOS
//
//  Loader for product overview and roadmap markdown files
//

import Foundation

enum ProductLoaderError: Error, LocalizedError {
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

public struct ProductLoader {

    private static let productRoot = "product"

    public static func loadProductOverview() throws -> ProductOverview {
        let path = "\(productRoot)/product-overview.md"
        guard let content = try? loadFile(at: path) else {
            throw ProductLoaderError.fileNotFound(path)
        }

        let lines = content.components(separatedBy: .newlines)
        var currentSection: String?
        var name: String?
        var description: String?
        var problems: [Problem] = []
        var features: [String] = []
        var currentProblem: String?

        for line in lines {
            if line.hasPrefix("# ") {
                name = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("## ") {
                let section = line.dropFirst(3).lowercased()
                currentSection = section
            } else if line.hasPrefix("### ") {
                if currentSection == "problems" {
                    currentProblem = line.dropFirst(4).trimmingCharacters(in: .whitespaces)
                }
            } else if line.hasPrefix("- ") {
                let content = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
                if currentSection == "features" {
                    features.append(content)
                }
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if currentSection == "overview" {
                    description = (description ?? "") + " " + trimmed
                } else if currentSection == "problems", let problemTitle = currentProblem {
                    let newProblem = Problem(title: problemTitle, solution: trimmed)
                    problems.append(newProblem)
                    currentProblem = nil
                }
            }
        }

        guard let productName = name else {
            throw ProductLoaderError.invalidMarkdown("Missing product name")
        }

        return ProductOverview(
            name: productName,
            description: description?.trimmingCharacters(in: .whitespaces) ?? "",
            problems: problems,
            features: features
        )
    }

    public static func loadProductRoadmap() throws -> ProductRoadmap {
        let path = "\(productRoot)/product-roadmap.md"
        guard let content = try? loadFile(at: path) else {
            throw ProductLoaderError.fileNotFound(path)
        }

        let lines = content.components(separatedBy: .newlines)
        var sections: [Section] = []
        var currentSectionId: String?
        var currentTitle: String?
        var currentDescription: String?
        var currentOrder = 0

        for line in lines {
            if line.hasPrefix("## ") {
                if let id = currentSectionId, let title = currentTitle {
                    sections.append(Section(
                        id: id,
                        title: title,
                        description: currentDescription?.trimmingCharacters(in: .whitespaces) ?? "",
                        order: currentOrder
                    ))
                    currentOrder += 1
                }

                let heading = line.dropFirst(3).trimmingCharacters(in: .whitespaces)
                if let idMatch = heading.range(of: "\\{([^}]+)\\}", options: .regularExpression) {
                    currentSectionId = String(heading[idMatch].dropFirst().dropLast())
                    currentTitle = heading.replacingOccurrences(of: "{\(currentSectionId!)}", with: "").trimmingCharacters(in: .whitespaces)
                } else {
                    currentSectionId = heading.lowercased().replacingOccurrences(of: " ", with: "-")
                    currentTitle = heading
                }
                currentDescription = nil
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                currentDescription = (currentDescription ?? "") + " " + line.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        if let id = currentSectionId, let title = currentTitle {
            sections.append(Section(
                id: id,
                title: title,
                description: currentDescription?.trimmingCharacters(in: .whitespaces) ?? "",
                order: currentOrder
            ))
        }

        return ProductRoadmap(sections: sections)
    }

    public static func hasProductOverview() -> Bool {
        fileExists(at: "\(productRoot)/product-overview.md")
    }

    public static func hasProductRoadmap() -> Bool {
        fileExists(at: "\(productRoot)/product-roadmap.md")
    }

    private static func loadFile(at path: String) throws -> String {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            throw ProductLoaderError.fileNotFound(path)
        }

        return try String(contentsOfFile: path, encoding: .utf8)
    }

    private static func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
}
