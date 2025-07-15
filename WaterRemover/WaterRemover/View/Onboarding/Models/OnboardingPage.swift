
import SwiftUI

enum OnboardingPage: String, CaseIterable, Hashable, Identifiable {

    case first, second, third, fourth, fifth

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .first: "Choose Countries\n& Radio Stations"
        case .second: "Identify the Song\nPlaying Now"
        case .third: "Set Widgets\nof Radio Stations"
        case .fourth: "Use Dark Theme\nfor Your Comfort"
        case .fifth: "Start to Continue\nRadio App"
        }
    }
    
    var description: String {
        switch self {
        case .first: "Find the stations you like, listen\nand add to your favorites"
        case .second: "Use Shazam to recognise the\nsong from radio cast"
        case .third: "Listen to music and get quick\naccess to app with widgets"
        case .fourth: "Try light and dark modes to\nchoose more convenient option"
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
