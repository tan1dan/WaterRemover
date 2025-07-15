
import SwiftUI

extension Font {

	// MARK: - Properties

	static let baseFontGilroyName = "Gilroy-"

	static func gilroy(size: CGFloat, weight: Font.Weight) -> Font {
		Font.custom(gilroy(for: weight), size: size)
	}

	// MARK: - Private methdos
    
    private static func gilroy(for weight: Font.Weight) -> String {
        switch weight {
        case .bold: return "\(baseFontGilroyName)Bold"
        case .semibold: return "\(baseFontGilroyName)Semibold"
        case .medium: return "\(baseFontGilroyName)Medium"
        case .regular: return "\(baseFontGilroyName)Regular"
        default: return baseFontGilroyName
        }
    }

}

