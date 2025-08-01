
import SwiftUI
import ApphudSDK

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    
    enum Choice {
        case first, second, third, none
    }
    
    private let apphud: ApphudManager = .shared
    
    @State private var selectedChoice: Choice = .first
    @State private var selectedProduct: ApphudProduct?
    @State private var showOverlay = false
    @State private var showBottomLinks = false
    @State private var isCloseVisible: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            //Image background paywall
            Image(.paywallBG)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                content()
                    .frame(height: 522)
                    .ignoresSafeArea()
                    .background(Color.background)
                    .clipShape(DipShape(dipRadius: 100, dipWidth: UIScreen.main.bounds.width, isInverted: false))
                    .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
        }
        .overlay(alignment: .topTrailing) {
            ZStack(alignment: .topTrailing) {
                Color.clear

                if isCloseVisible {
                    HapticButton(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(.closeButton)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    )
                    .padding(.top, 67)
                    .padding(.trailing, 20)
                }
            }
            .ignoresSafeArea()
        }
        .overlay(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                Color.clear
                
                HapticButton {
                    Task {
                        await apphud.restore()
                    }
                } label: {
                    Text("Restore")
                        .frame(width: 60, height: 22)
                        .font(.gilroy(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                .padding(.top, 67)
                .padding(.leading, 20)
                
            }
            .ignoresSafeArea()
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showBottomLinks = true
                }
            }
            
            Task {
                let closeAppearDelay = ApphudManager.shared.onboardingPaywall?.config.onboardingCloseDelay ?? 0

                try await Task.sleep(for: .seconds(closeAppearDelay))

                isCloseVisible = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func content() -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                titles()
                    .padding(.top, 60)
                
                HStack(spacing: 5) {
                    if let product = apphud.inAppPaywall?.products[0] {
                        HapticButton {
                            selectedProduct = product
                            selectedChoice = .first
                        } label: {
                            OfferView(
                                badgeTitle: "POPULAR",
                                product: product,
                                isChoosing: selectedChoice == .first
                            )
                        }
                    }
                    
                    if let product = apphud.inAppPaywall?.products[1] {
                        HapticButton {
                            selectedProduct = product
                            selectedChoice = .second
                        } label: {
                            OfferView(
                                badgeTitle: "MOST TAKEN",
                                product: product,
                                isChoosing: selectedChoice == .second
                            )
                        }
                    }
                    
                    if let product = apphud.inAppPaywall?.products[2] {
                        HapticButton {
                            selectedProduct = product
                            selectedChoice = .third
                        } label: {
                            OfferView(
                                badgeTitle: "BEST DEAL",
                                product: product,
                                isChoosing: selectedChoice == .third
                            )
                        }
                    }
                }
            }
            Spacer()
        }
        .overlay(alignment: .bottom) {
            if showBottomLinks {
                bottomLinks()
                    .frame(height: 41)
                    .fixedSize()
                    .padding(.bottom, 30)
            }
        }
        .overlay(alignment: .bottom) {
            purchaseButton()
                .padding(.bottom, 30 + 41 + 20)
                .padding(.horizontal, 23)
        }
    }
    
    private func titles() -> some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Text("Clear Your Devices\nWithout Limits")
                    .foregroundStyle(Color.customBlack)
                    .font(.lufga(size: 35, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.6)
                
                Text("Unlock unlimited access to all useful\nfeatures & make your life easier!")
                    .foregroundStyle(Color.customBlack.opacity(0.5))
                    .font(.lufga(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.6)
            }
            Spacer()
        }
    }
    
    private func purchaseButton() -> some View {
        HapticButton {
            if let selectedProduct {
                Task {
                    await apphud.purchase(apphudProduct: selectedProduct)
                }
            }
        } label: {
            VStack(spacing: 0) {
                Text(apphud.paywallButtonTitle(apphudProduct: selectedProduct, config: apphud.inAppPaywall?.config))
                    .foregroundStyle(.white)
                    .font(.lufga(size: 18, weight: .semibold))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.customBlue)
            .clipShape(.rect(cornerRadius: 30))
            .padding(.horizontal, 23)
        }
    }
    
    private func bottomLinks() -> some View {
        VStack(spacing: 0) {
            Text("By continuing, you agree to")
                .font(.gilroy(size: 12, weight: .medium))
                .foregroundStyle(.text.opacity(0.2))

            HStack(alignment: .center, spacing: 0) {
                HapticButton(
                    action: {
                        open(url: URL(string: Constants.terms)!)
                    },
                    label: {
                        Text("Terms of Service")
                            .font(.gilroy(size: 12, weight: .bold))
                            .foregroundStyle(.text.opacity(0.5))
                    }
                )
                
                Text(" and ")
                    .font(.gilroy(size: 12, weight: .medium))
                    .foregroundStyle(.text.opacity(0.2))

                HapticButton(
                    action: {
                        open(url: URL(string: Constants.privacy)!)
                    },
                    label: {
                        Text("Privacy Policy")
                            .font(.gilroy(size: 12, weight: .bold))
                            .foregroundStyle(.text.opacity(0.5))
                    }
                )

            }
        }
    }
    
    private func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
