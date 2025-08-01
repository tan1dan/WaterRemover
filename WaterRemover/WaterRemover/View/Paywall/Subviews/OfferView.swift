
import SwiftUI
import ApphudSDK

struct OfferView: View {

    // MARK: - Properties

    let badgeTitle: String
    let product: ApphudProduct
    let isChoosing: Bool

    private let apphud = ApphudManager.shared

    // MARK: - Body

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Text(badgeTitle)
                    .foregroundStyle(isChoosing ? Color.customBlack : Color.text)
                    .font(.lufga(size: 13, weight: .semibold))
                
                Spacer()
            }
            .frame(height: 33)
            .background(isChoosing ? Color.white : Color.text.opacity(0.15))
            .clipShape(.rect(cornerRadius: 37))
            .padding(.horizontal, 6)
            .padding(.top, 6)
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text(apphud.periodTitle(apphudProduct: product)?.capitalized ?? "")
                        .foregroundStyle(isChoosing ? Color.white : Color.offerViewBlack)
                        .font(.lufga(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)

                    Text(apphud.priceString(apphudProduct: product) ?? "")
                        .foregroundStyle(isChoosing ? Color.white : Color.offerViewBlack)
                        .font(.lufga(size: 15, weight: .semibold))
                        .multilineTextAlignment(.center)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(isChoosing ? LinearGradient(colors: [.clear, .white, .clear], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.clear, .offerViewBlack.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing)
                    )
                
                Text(apphud.pricePerWeekString(apphudProduct: product) ?? "")
                    .foregroundStyle(isChoosing ? .white : .black)
                    .font(isChoosing ? .lufga(size: 13, weight: .semibold) : .gilroy(size: 13, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(height: 132)
        .background(isChoosing ? Color.customBlue : Color.text.opacity(0.05))
        .clipShape(.rect(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isChoosing ? Color.clear : Color.text.opacity(0.15), lineWidth: 2.5)
        )
        
    }
}
