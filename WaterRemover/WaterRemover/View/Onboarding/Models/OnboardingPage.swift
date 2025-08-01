
import SwiftUI

enum OnboardingPage: String, CaseIterable, Hashable, Identifiable {

    case first, second, third, fourth, fifth

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .first: "Vibration Modes\n& Intensity Control"
        case .second: "Separate Speaker\nEasy Testing"
        case .third: "Noise Level\nSmart Controller"
        case .fourth: "Tone Generator\nwith Ready Options"
        case .fifth: "Start to Continue\nWater Remover"
        }
    }
    
    var description: String {
        switch self {
        case .first: "Сhange the power and frequency of\nvibration to better clean the device"
        case .second: "Check top and bottom speakers to\nunderstand if them work correctly"
        case .third: "Measure the noise around you to find\nout if it is dangerous for your health"
        case .fourth: "Use the tone generator to clean your\ndevice or repel rodents and insects"
        case .fifth: paywallSubtitle()
        }
    }
    
    var image: ImageResource {
        switch self {
        case .first: .ob1
        case .second: .ob2
        case .third: .ob3
        case .fourth: .ob4
        case .fifth: .ob5
        }
    }

    private func paywallSubtitle() -> String {
        guard let product = ApphudManager.shared.onboardingPaywall?.products.first else {
            return "Product subtitle missed"
        }

        return ApphudManager.shared.onboardingPaywallDescription
    }
}
