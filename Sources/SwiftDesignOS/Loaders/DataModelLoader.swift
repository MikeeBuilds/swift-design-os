//
//  DataModelLoader.swift
//  Swift DesignOS
//
//  Loader for data model markdown file
//

import Foundation

enum DataModelLoaderError: Error, LocalizedError {
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

public struct DataModelLoader {

    private static let productRoot = "product"

    public static func loadDataModel() throws -> DataModel {
        let path = "\(productRoot)/data-model/data-model.md"
        guard let content = try? loadFile(at: path) else {
            throw DataModelLoaderError.fileNotFound(path)
        }

        let lines = content.components(separatedBy: .newlines)
        var currentSection: String?
        var entities: [Entity] = []
        var relationships: [String] = []
        var currentEntity: String?
        var currentDescription: [String] = []

        for line in lines {
            if line.hasPrefix("## ") {
                let section = line.dropFirst(3).lowercased()
                currentSection = section
            } else if line.hasPrefix("### ") {
                if currentSection == "entities", let entityName = currentEntity {
                    let entity = Entity(
                        name: entityName,
                        description: currentDescription.joined(separator: " ").trimmingCharacters(in: .whitespaces)
                    )
                    entities.append(entity)
                    currentDescription = []
                }

                currentEntity = line.dropFirst(4).trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("- ") {
                let content = line.dropFirst(2).trimmingCharacters(in: .whitespaces)
                if currentSection == "relationships" {
                    relationships.append(content)
                } else if currentSection == "entities" {
                    currentDescription.append(content)
                }
            } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if currentSection == "entities" && currentEntity != nil {
                    currentDescription.append(trimmed)
                }
            }
        }

        if let entityName = currentEntity {
            let entity = Entity(
                name: entityName,
                description: currentDescription.joined(separator: " ").trimmingCharacters(in: .whitespaces)
            )
            entities.append(entity)
        }

        return DataModel(
            entities: entities,
            relationships: relationships
        )
    }

    public static func hasDataModel() -> Bool {
        fileExists(at: "\(productRoot)/data-model/data-model.md")
    }

    private static func loadFile(at path: String) throws -> String {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            throw DataModelLoaderError.fileNotFound(path)
        }

        return try String(contentsOfFile: path, encoding: .utf8)
    }

    private static func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
}
