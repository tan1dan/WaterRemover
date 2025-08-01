

import SwiftUI

struct SettingCell: View {
    let image: Image
    let title: String
    let subtitle: String
    let buttonType: SettingsButtonType
    var body: some View {
        HStack(spacing: 14) {
            image
                .resizable()
                .frame(width: 42, height: 42)
                .padding(.leading, 10)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .foregroundStyle(Color.text)
                    .font(.gilroy(size: 16, weight: .bold))
                Text(subtitle)
                    .foregroundStyle(Color.text.opacity(0.5))
                    .font(.gilroy(size: 14, weight: .medium))
            }
            
            Spacer()
            Image(.arrow)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 10)
        }
        .frame(height: 62)
        .background(.white)
        .clipShape(.rect(cornerRadius: 20))
    }
}
