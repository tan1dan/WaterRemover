
import Foundation
import Combine
import StoreKit

import ApphudSDK

final class ApphudManager: ObservableObject {

	// MARK: - Properties

	static let shared = ApphudManager()

	@Published private(set) var onboardingPaywall: Paywall?
	@Published private(set) var inAppPaywall: Paywall?
	@Published private(set) var isSubscribed: Bool = false
	@Published private(set) var onboardingPaywallDescription: String = ""

    private var cachedPaywalls: [ApphudPaywall] = []
    
    private var _isPaywallConfigEmpty: Bool {
        guard !cachedPaywalls.isEmpty else {
            return true
        }

        for paywall in cachedPaywalls {
            if paywall.json?.isEmpty != false {
                return true
            }
        }
        
        return false
    }
    
    var isPaywallConfigEmpty: Bool?
    
	// MARK: - Init

	init() {
        Task {
            await MainActor.run {
                Apphud.start(apiKey: Constants.apphudKey)
            }

            await updateSubscribedStatus()
			await fetchProducts()
            await updateSubscribedStatus()
		}
	}

	// MARK: - Public methods

	func restore() async {
		await Apphud.restorePurchases()
        await updateSubscribedStatus()
	}

	func purchase(apphudProduct: ApphudProduct) async -> Bool {
		// TODO - Return
//#if DEBUG
//		isSubscribed = true
//		return true
//#else
		let _ = await Apphud.purchase(apphudProduct)
        await updateSubscribedStatus()

		return isSubscribed
//#endif
	}

	func priceString(apphudProduct: ApphudProduct?) -> String? {
		guard
			let apphudProduct,
			let product = apphudProduct.skProduct
		else { return nil }

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .currency
		numberFormatter.locale = product.priceLocale
		return numberFormatter.string(from: product.price) ?? ""
	}

	func onboardingButtonTitle(
		apphudProduct: ApphudProduct?,
		config: PaywallConfig?
	) -> String? {
		if let text = config?.onboardingButtonTitle {
			text
		} else if let price = priceString(apphudProduct: apphudProduct) {
			if
				let apphudProduct,
				apphudProduct.isTrial
			{
				"Try free trial, then \(price)/week"
			} else {
				"Subscribe for \(price)/week"
			}
		} else { nil }
	}

	var onboardingPaywallDescriptionAlpha: Double {
		onboardingPaywall?.config.onboardingSubtitleAlpha ?? 1
	}

	func paywallButtonTitle(
		apphudProduct: ApphudProduct?,
		config: PaywallConfig?
	) -> String {
		if let text = config?.paywallButtonTitle {
			text
		} else if let apphudProduct {
            if apphudProduct.isTrial == true {
                "TRY TRIAL, THEN \(priceString(apphudProduct: apphudProduct) ?? "")/WEEK"
            } else {
                "CONTINUE FOR \(priceString(apphudProduct: apphudProduct) ?? "")/WEEK"
            }
        } else {
            "CONTINUE"
        }
	}

	func paywallTrialDescription(apphudProduct: ApphudProduct) -> String? {
		guard let trialDays = trialDays(apphudProduct: apphudProduct)
		else { return nil }

		return "\(trialDays)-day free trial"
	}

	func paywallButtonSubtitle(apphudProduct: ApphudProduct?) -> String? {
		guard
            let apphudProduct,
            let priceString = priceString(apphudProduct: apphudProduct),
            onboardingPaywall?.config == nil
        else {
            return ""
        }

		return apphudProduct.isTrial
			? "Try trial, then \(priceString)/week"
			: "Continue for \(priceString)/week"
	}

    func trialDays(apphudProduct: ApphudProduct) -> Int? {
        guard
            apphudProduct.isTrial,
            let period = apphudProduct.skProduct?.introductoryPrice?.subscriptionPeriod
        else {
            return nil
        }

        return period.numberOfUnits
    }

    func periodTitle(apphudProduct: ApphudProduct) -> String? {
        guard
            let period = apphudProduct.skProduct?.subscriptionPeriod
        else {
            return nil
        }

        return switch period.unit {
        case .day: period.numberOfUnits == 7 ? "weekly" : "\(period.numberOfUnits)-day"
        case .week: period.numberOfUnits == 1 ? "weekly" : "\(period.numberOfUnits)-week"
        case .month: period.numberOfUnits == 1 ? "monthly" : "\(period.numberOfUnits)-month"
        case .year: period.numberOfUnits == 1 ? "yearly" : "\(period.numberOfUnits)-year"
        @unknown default: nil
        }
    }

    func pricePerWeekString(apphudProduct: ApphudProduct?) -> String? {
        guard
            let product = apphudProduct?.skProduct,
            let subscriptionPeriod = product.subscriptionPeriod
        else {
            return nil
        }

        let totalPrice = product.price.decimalValue

        let weeks: Decimal
        switch subscriptionPeriod.unit {
        case .day:
            weeks = Decimal(subscriptionPeriod.numberOfUnits) / 7
        case .week:
            weeks = Decimal(subscriptionPeriod.numberOfUnits)
        case .month:
            weeks = Decimal(subscriptionPeriod.numberOfUnits) * 4.348
        case .year:
            weeks = Decimal(subscriptionPeriod.numberOfUnits) * 52
        @unknown default:
            return nil
        }

        guard weeks > 0 else { return nil }

        let pricePerWeek = totalPrice / weeks as NSDecimalNumber

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale

        let formatted = formatter.string(from: pricePerWeek as NSDecimalNumber)
        return formatted.map { "\($0)/week" }
    }

    func subscriptionButtonTitle(apphudProduct: ApphudProduct?) -> String? {
        guard let product = apphudProduct?.skProduct else { return nil }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        let priceString = formatter.string(from: product.price) ?? ""

        guard let period = product.subscriptionPeriod else { return nil }

        let periodString: String
        switch period.unit {
        case .day:
            periodString = period.numberOfUnits == 7 ? "week" : "\(period.numberOfUnits)-day"
        case .week:
            periodString = period.numberOfUnits == 1 ? "week" : "\(period.numberOfUnits)-week"
        case .month:
            periodString = period.numberOfUnits == 1 ? "month" : "\(period.numberOfUnits)-month"
        case .year:
            periodString = period.numberOfUnits == 1 ? "year" : "\(period.numberOfUnits)-year"
        @unknown default:
            return nil
        }

        return "Subscribe for \(priceString)/\(periodString)"
    }

	// MARK: - Private methods
    @MainActor
	private func updateSubscribedStatus() {
		isSubscribed = Apphud.hasActiveSubscription()
		print(">>> isSubscribed \(isSubscribed)")
	}

	private func fetchProducts() async {
		await Apphud.paywallsDidLoadCallback { [weak self] paywalls, _ in
            guard let self else {
                return
            }
            
            self.cachedPaywalls = paywalls
            
			for paywall in paywalls {
				guard !paywall.products.isEmpty else {
                    continue
                }

				let paywallConfig = if let json = paywall.json {
					PaywallConfig(json: json)
				} else {
					PaywallConfig(json: [:])
				}

				let paywallValue = Paywall(
					products: paywall.products,
					config: paywallConfig
				)

				switch paywall.identifier {
				case "onboarding_paywall": onboardingPaywall = paywallValue
				case "inapp_paywall": inAppPaywall = paywallValue
				default: break
				}
			}

			updateOnboardingPaywallDescription()
            isPaywallConfigEmpty = _isPaywallConfigEmpty
		}
	}

	private func updateOnboardingPaywallDescription() {
        guard let apphudProduct = onboardingPaywall?.products.first else {
            return
        }

		var description = "Take care about your speakers with"
		if
			let trialDays = trialDays(apphudProduct: apphudProduct),
			let price = priceString(apphudProduct: apphudProduct)
		{
            description += "\n"
			description += "\(trialDays)-days free trial and \(price) per week"
		}

		onboardingPaywallDescription = description
	}

}

// MARK: - ApplicationObserver

extension ApphudManager {

	@MainActor func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
	) {
		Apphud.start(apiKey: Constants.apphudKey)
	}

}

extension ApphudProduct {

	var isTrial: Bool {
		productId.contains("trial")
	}

}

extension UIColor {

	// MARK: - Helper Functions
	/// Returns the hex string for this `UIColor`. For example: `#FFFFFF` or `#222222AB` if the alpha value is included.
	///
	/// - Parameter includeAlpha: A boolean indicating if the alpha value should be included in the returned hex string.
	///
	/// - Returns: The hex string for this `UIColor`. For example: `#FFFFFF` or
	///            `#222222AB` if the alpha value is included.
	///
	func hexString(includeAlpha: Bool = false) -> String {
		let components = cgColor.components
		let red: CGFloat = components?[0] ?? 0.0
		let green: CGFloat = components?[1] ?? 0.0
		let blue: CGFloat = components?[2] ?? 0.0
		let alpha: CGFloat = components?[3] ?? 0.0
		let hexString = String.init(
			format: "#%02lX%02lX%02lX%02lX",
			lroundf(Float(red * 255)),
			lroundf(Float(green * 255)),
			lroundf(Float(blue * 255)),
			lroundf(Float(alpha * 255))
		)
		return includeAlpha ? hexString : String(hexString.dropLast(2))
	}

}
