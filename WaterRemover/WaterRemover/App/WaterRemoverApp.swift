
import SwiftUI

@main
struct WaterRemoverApp: App {
    @StateObject private var actualView: AppState = AppState()

    private let userDefaults: UserDefaultsManager = .shared
    @StateObject private var apphud: ApphudManager = .shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    private var isOnboardingPassed: Bool {
        userDefaults.getValue(forKey: .onboardingCompleted) ?? false
    }
    
    var body: some Scene {
        WindowGroup {
            switch actualView.view {
            case .onboarding where !isOnboardingPassed:
                OnboardingView()
                    .environmentObject(actualView)

            case .main, .onboarding:
                MainView()
                    .environmentObject(actualView)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                ShortcutItemsManager.shared.start()
            case .inactive:
               break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
}
