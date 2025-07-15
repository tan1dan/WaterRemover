
import SwiftUI
import StoreKit

class SettingsActionsManager {
    
    static let share = SettingsActionsManager()
    
    func openEmail(recipient: String, subject: String, body: String) {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let emailURL = URL(string: "mailto:\(recipient)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let url = emailURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Can't open Mail app")
        }
    }
    
    func openLink(_ urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            print("Invalid or unsupported URL")
            return
        }
        UIApplication.shared.open(url)
    }
    
    func rate_us() {
        RateAppManager.shared.openAppStore()
    }
}
