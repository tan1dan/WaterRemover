
import SwiftUI

extension Font {

    // MARK: - Properties

    static let baseFontLufgaName = "Lufga-"

    static func lufga(size: CGFloat, weight: Font.Weight) -> Font {
        Font.custom(lufga(for: weight), size: size)
    }

    // MARK: - Private methdos

    private static func lufga(for weight: Font.Weight) -> String {
        switch weight {
        case .bold: return "\(baseFontLufgaName)Bold"
        case .semibold: return "\(baseFontLufgaName)Semibold"
        case .medium: return "\(baseFontLufgaName)Medium"
        case .regular: return "\(baseFontLufgaName)Regular"
        default: return baseFontLufgaName
        }
    }

}
