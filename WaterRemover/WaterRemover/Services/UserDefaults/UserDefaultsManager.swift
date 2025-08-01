
import Foundation
import WidgetKit

struct UserDefaultsManager {

    static let shared = UserDefaultsManager()

	// MARK: - Properties

    private let userDefaults: UserDefaults = .standard
    
	// MARK: - Public methods

    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
	}

    func deleteValue(forKey key: UserDefaultsKey) {
		userDefaults.removeObject(forKey: key.rawValue)
	}

    func getValue<T>(forKey key: UserDefaultsKey) -> T? {
		userDefaults.value(forKey: key.rawValue) as? T
	}

}

enum UserDefaultsKey: String {
    case onboardingCompleted
    case freeTranlationsCompleted
    case vibrationLevel
    case vibrationType
    case topSpeaker
    case bottomSpeaker
    case selectedHZ
}
