
import SwiftUI

extension Font {

	// MARK: - Properties

	static let baseFontAnekLatinName = "AnekLatin-"

	static func anekLatin(size: CGFloat, weight: Font.Weight) -> Font {
		Font.custom(anekLatin(for: weight), size: size)
	}

	// MARK: - Private methdos

	private static func anekLatin(for weight: Font.Weight) -> String {
		switch weight {
        case .bold: return "\(baseFontGilroyName)Bold"
        case .semibold: return "\(baseFontGilroyName)Semibold"
        case .medium: return "\(baseFontGilroyName)Medium"
        case .regular: return "\(baseFontGilroyName)Regular"
		default: return baseFontAnekLatinName
		}
	}

}
