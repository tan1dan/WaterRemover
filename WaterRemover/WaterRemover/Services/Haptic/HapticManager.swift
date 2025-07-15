
import UIKit

final class HapticManager {

	// MARK: - Properties

	static let shared = HapticManager()

	// MARK: - Public methods

	func impact(
		impactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light,
		notificationType: UINotificationFeedbackGenerator.FeedbackType? = nil
	) {
		if let type = notificationType {
			let notificationGenerator = UINotificationFeedbackGenerator()
			notificationGenerator.notificationOccurred(type)
		} else {
			let impactGenerator = UIImpactFeedbackGenerator(style: impactStyle)
			impactGenerator.prepare()
			impactGenerator.impactOccurred()
		}
	}

}
