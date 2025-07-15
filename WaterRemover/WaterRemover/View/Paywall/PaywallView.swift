
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            //Image background paywall
            Image(.empty)
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
                    .frame(height: 489)
                    .ignoresSafeArea()
                    .background(Color.paywallBackground)
                    .clipShape(.rect(cornerRadius: 30))
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: -4)
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showBottomLinks = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func content() -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Listen to Radio\nWithout Limits")
                        .foregroundStyle(Color.paywallTitle)
                        .font(.lufga(size: 35, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.6)
                    
                    Text("Unlock unlimited access to worldwide\nradio cast & other features !")
                        .foregroundStyle(Color.paywallDescription)
                        .font(.lufga(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.6)
                }
                .padding(.top, 26)
                
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
                
                VStack(spacing: 0) {
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
                        .background(Color.paywallOfferBackgroundChosen)
                        .clipShape(.rect(cornerRadius: 30))
                        .padding(.horizontal, 23)
                    }
                    if showBottomLinks {
                        bottomLinks()
                            .padding(.top, 20)
                            .padding(.horizontal, 35.5)
                            .transition(.opacity)
                    }
                }
            }
            Spacer()
        }
    }
    
    private func bottomLinks() -> some View {
        HStack(spacing: 40) {
            HapticButton(
                action: {
                    open(url: URL(string: Constants.privacy)!)
                },
                label: {
                    Text("Privacy")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(Color.paywallDescription)
                }
            )
            
            HapticButton(
                action: {
                    open(url: URL(string: Constants.terms)!)
                },
                label: {
                    Text("Terms")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(Color.paywallDescription)
                }
            )
            
            HapticButton(
                action: {
                    Task {
                        await apphud.restore()
                        
                        if apphud.isSubscribed {
                            dismiss()
                        }
                    }
                },
                label: {
                    Text("Restore")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(Color.paywallDescription)
                }
            )
            
            HapticButton(
                action: {
                    dismiss()
                },
                label: {
                    Text("Close")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(Color.paywallDescription)
                }
            )
        }
    }
    
    private func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url)
    }
}

#Preview {
    PaywallView()
}
