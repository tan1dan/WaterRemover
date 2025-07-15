
import SwiftUI

struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    var body: some View {
        ZStack(alignment: .center) {
            Text(title)
//                .foregroundStyle(.settingsTitle)
                .font(.lufga(size: 24, weight: .semibold))
            HStack {
                Spacer()
                HapticButton {
                    dismiss()
                } label: {
//                    Image(.close)
//                        .resizable()
//                        .frame(width: 14, height: 14)
                }

            }
        }
    }
}
