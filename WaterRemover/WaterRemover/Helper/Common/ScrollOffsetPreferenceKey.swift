
import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey, Sendable, Hashable, Equatable {

	static let defaultValue: CGRect = .zero

	static func reduce(
		value: inout CGRect,
		nextValue: () -> CGRect
	) { }

}
