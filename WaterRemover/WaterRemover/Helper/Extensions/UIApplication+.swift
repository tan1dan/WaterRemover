
import UIKit

extension UIApplication {

	var safeArea: UIEdgeInsets {
		guard
			let window = connectedScenes
				.compactMap({ $0 as? UIWindowScene })
				.flatMap({ $0.windows })
				.first(where: { $0.isKeyWindow })
		else {
			return .zero
		}
		return window.safeAreaInsets
	}
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
