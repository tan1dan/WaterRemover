import SwiftUI

final class AppState: ObservableObject {

    @Published public var view: ActualView = .onboarding

    init() {
        self.view = view
    }
}
