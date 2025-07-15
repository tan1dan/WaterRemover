
import UIKit
import StoreKit

final class RateAppManager {
	
	// MARK: - Properties
	
	static let shared = RateAppManager()
	
	// MARK: - Init
	
    init() { }

	// MARK: - Public methods
	
	func requestReview() {
		if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			SKStoreReviewController.requestReview(in: scene)
		}
	}

	func openAppStore() {
		if
			let url = URL(string: "itms-apps://itunes.apple.com/app/" + "\(Constants.appleId)?mt=8&action=write-review"),
			UIApplication.shared.canOpenURL(url)
		{
			UIApplication.shared.open(url)
		} else {
			requestReview()
		}
	}

}
