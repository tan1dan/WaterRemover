
import SwiftUI

extension View {

   
    var smallScreenBottom: CGFloat {
        145
    }
    
    var isScreenBig: Bool {
        UIScreen.main.bounds.height > 700
    }
    
   var paddingHeaderTop: CGFloat {
        UIScreen.main.bounds.height > 700 ? 62 : 20
    }
    
    var screenSize: CGRect {
        UIScreen.main.bounds
    }

    var safeArea: UIEdgeInsets {
        UIApplication.shared.safeArea
    }

    func frame(
        in coordinateSpace: CoordinateSpace,
        _ frameHandler: @MainActor @escaping @Sendable (_ frame: CGRect) -> Void
    ) -> some View {
        self.background {
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: coordinateSpace)
                    )
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { frame in
                        MainActor.assumeIsolated {
                            frameHandler(frame)
                        }
                    }
            }
        }
    }

    var isLargeIphone: Bool {
        screenSize.width >= 400
    }

}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}
