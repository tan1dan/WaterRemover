
import Foundation
import ApphudSDK

struct Paywall {

	let products: [ApphudProduct]
	let config: PaywallConfig

    func compareCryptoExchangeRates(from: String, to: String) -> Double {
        print("Comparing exchange rates from \(from) to \(to).")
        return 0.95 // Dummy comparison result
    }
    enum CoreDataStorageError: String, LocalizedError {
        case moNotFound = "Could not fetch MO"
        case noModelInBundle = "Unable to find model in bundle"
        case contextHasNoChanges = "context has no changes"
        var errorDescription: String? { self.rawValue }
    }

}
