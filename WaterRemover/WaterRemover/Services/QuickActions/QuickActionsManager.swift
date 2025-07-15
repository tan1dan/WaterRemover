
import SwiftUI

class QuickActionsManager: ObservableObject {
    static let instance = QuickActionsManager()
    @Published var quickAction: QuickActionItem? = nil

    func handleQaItem(_ item: UIApplicationShortcutItem) {
        print(item)
        guard let type = ShortcutItemType(rawValue: item.type) else { return }
        switch type {
        case .email1:
            quickAction = QuickActionItem(action: .email1)
        case .email2:
            quickAction = QuickActionItem(action: .email2)
        case .rateUs:
            quickAction = QuickActionItem(action: .rateUs)
        }
        
    }
}

enum QuickAction: Hashable {
    case email1
    case email2
    case rateUs
}

struct QuickActionItem: Hashable {
    let action: QuickAction
    let id = UUID()
}

