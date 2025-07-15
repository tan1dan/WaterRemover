
import SwiftUI

struct HapticButton<Label>: View where Label: View {

	// MARK: - Properties

	private let action: @MainActor @Sendable () -> Void
	private let label: () -> Label

	@preconcurrency init(
		action: @MainActor @escaping () -> Void,
		@ViewBuilder label: @escaping () -> Label
	) {
		self.action = action
		self.label = label
	}

	// MARK: - Body

	var body: some View {
		Button(
			action: {
				HapticManager.shared.impact()

				action()
			},
			label: label
		)
	}

}
