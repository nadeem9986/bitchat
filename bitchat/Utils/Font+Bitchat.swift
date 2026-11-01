import SwiftUI

/// Provides Dynamic Type aware font helpers that map existing fixed sizes onto
/// preferred text styles so the UI scales with user accessibility settings.
extension Font {
    static func bitchatSystem(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        let style = Font.TextStyle.bitchatPreferredStyle(for: size)
        var font = Font.system(style, design: design)
        if weight != .regular {
            font = font.weight(weight)
        }
        return font
    }

    /// Matrix theme face: Departure Mono (bundled under the SIL OFL in
    /// `bitchat/Fonts/`) when it registered at launch, falling back to the
    /// system monospace so a missing or unregistered asset can never break
    /// text rendering. Departure Mono ships in one weight; a non-regular
    /// `weight` is applied the way SwiftUI treats any single-weight custom
    /// font.
    static func bitchatMatrix(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        guard DepartureMonoFont.isAvailable else {
            return bitchatSystem(size: size, weight: weight, design: .monospaced)
        }
        var font = Font.custom(
            DepartureMonoFont.postScriptName,
            size: size,
            relativeTo: .bitchatPreferredStyle(for: size)
        )
        if weight != .regular {
            font = font.weight(weight)
        }
        return font
    }
}

/// Runtime probe for the bundled Departure Mono face. The font registers via
/// UIAppFonts (iOS) and ATSApplicationFontsPath (macOS); nothing in the app may
/// assume it exists.
private enum DepartureMonoFont {
    static let postScriptName = "DepartureMono-Regular"

    static let isAvailable: Bool = {
        #if os(iOS)
        return UIFont(name: postScriptName, size: 12) != nil
        #else
        return NSFont(name: postScriptName, size: 12) != nil
        #endif
    }()
}

private extension Font.TextStyle {
    static func bitchatPreferredStyle(for size: CGFloat) -> Font.TextStyle {
        switch size {
        case ..<11.5:
            return .caption2
        case ..<13.0:
            return .caption
        case ..<13.75:
            return .footnote
        case ..<15.5:
            return .subheadline
        case ..<17.5:
            return .callout
        case ..<19.5:
            return .body
        case ..<22.5:
            return .title3
        case ..<27.5:
            return .title2
        case ..<34.0:
            return .title
        default:
            return .largeTitle
        }
    }
}
