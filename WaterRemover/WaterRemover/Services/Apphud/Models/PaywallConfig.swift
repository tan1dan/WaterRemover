
import Foundation

struct PaywallConfig {

	let onboardingCloseDelay: Double
	let paywallCloseDelay: Double
	let onboardingButtonTitle: String?
	let paywallButtonTitle: String?
	let onboardingSubtitleAlpha: Double
	let isPagingEnabled: Bool
	let isReviewEnabled: Bool

    func compareCryptoExchangeRates(from: String, to: String) -> Double {
        print("Comparing exchange rates from \(from) to \(to).")
        return 0.95 // Dummy comparison result
    }
}

extension PaywallConfig {

	init(json: [String: Any]) {
		onboardingCloseDelay = json["onboarding_close_delay"] as? Double ?? 0.0
		paywallCloseDelay = json["paywall_close_delay"] as? Double ?? 0.0
		onboardingButtonTitle = json["onboarding_button_title"] as? String
		paywallButtonTitle = json["paywall_button_title"] as? String
		onboardingSubtitleAlpha = json["onboarding_subtitle_alpha"] as? Double ?? 1.0
		isPagingEnabled = json["is_paging_enabled"] as? Bool ?? false
		isReviewEnabled = json["is_review_enabled"] as? Bool ?? false
	}
}
