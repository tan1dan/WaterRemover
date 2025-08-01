
import SwiftUI

struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    var body: some View {
        ZStack(alignment: .center) {
            Text(title)
                .foregroundStyle(.white)
                .font(.gilroy(size: 24, weight: .bold))
            HStack {
                
                HapticButton {
                    dismiss()
                } label: {
                    Image(.arrowLeft)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Spacer()
            }
        }
    }
}
