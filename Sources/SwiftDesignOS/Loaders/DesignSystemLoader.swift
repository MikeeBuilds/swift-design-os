//
//  DesignSystemLoader.swift
//  Swift DesignOS
//
//  Loader for design system JSON files
//

import Foundation

enum DesignSystemLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidJSON(String)
    case parsingError(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .invalidJSON(let reason):
            return "Invalid JSON: \(reason)"
        case .parsingError(let reason):
            return "Parsing error: \(reason)"
        }
    }
}

public struct DesignSystemLoader {

    private static let productRoot = "product"

    public static func loadDesignSystem() throws -> DesignSystem {
        let colorsPath = "\(productRoot)/design-system/colors.json"
        let typographyPath = "\(productRoot)/design-system/typography.json"

        let colors: ColorTokens?
        let typography: TypographyTokens?

        if fileExists(at: colorsPath) {
            colors = try loadColors(at: colorsPath)
        } else {
            colors = nil
        }

        if fileExists(at: typographyPath) {
            typography = try loadTypography(at: typographyPath)
        } else {
            typography = nil
        }

        return DesignSystem(
            colors: colors,
            typography: typography
        )
    }

    private static func loadColors(at path: String) throws -> ColorTokens {
        let content = try loadFile(at: path)

        guard let data = content.data(using: .utf8) else {
            throw DesignSystemLoaderError.invalidJSON("Unable to encode file content")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let primary = json["primary"] as? String,
              let secondary = json["secondary"] as? String,
              let neutral = json["neutral"] as? String else {
            throw DesignSystemLoaderError.parsingError("Missing required color fields (primary, secondary, neutral)")
        }

        return ColorTokens(
            primary: primary,
            secondary: secondary,
            neutral: neutral
        )
    }

    private static func loadTypography(at path: String) throws -> TypographyTokens {
        let content = try loadFile(at: path)

        guard let data = content.data(using: .utf8) else {
            throw DesignSystemLoaderError.invalidJSON("Unable to encode file content")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let heading = json["heading"] as? String,
              let body = json["body"] as? String,
              let mono = json["mono"] as? String else {
            throw DesignSystemLoaderError.parsingError("Missing required typography fields (heading, body, mono)")
        }

        return TypographyTokens(
            heading: heading,
            body: body,
            mono: mono
        )
    }

    public static func hasDesignSystem() -> Bool {
        fileExists(at: "\(productRoot)/design-system/colors.json") ||
        fileExists(at: "\(productRoot)/design-system/typography.json")
    }

    private static func loadFile(at path: String) throws -> String {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            throw DesignSystemLoaderError.fileNotFound(path)
        }

        return try String(contentsOfFile: path, encoding: .utf8)
    }

    private static func fileExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
}
