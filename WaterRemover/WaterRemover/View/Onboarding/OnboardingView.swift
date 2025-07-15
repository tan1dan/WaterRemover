
import SwiftUI

struct OnboardingView: View {

    // MARK: - Properties

    @EnvironmentObject private var appState: AppState

    @State private var page: OnboardingPage? = .first
    @State private var contentHeight: CGFloat = 0
    @State private var isCloseVisible: Bool = false

    private let apphud: ApphudManager = .shared
    
    let isConfigEmpty = ApphudManager.shared.isPaywallConfigEmpty
    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(OnboardingPage.allCases) { page in
                    Image(page.image)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            //                            height: UIScreen.main.bounds.height
                        )
                        .id(page)
                        .overlay(alignment: .bottom) {
                            overlayContent(from: page)
                                .frame(height: 369)
                                .frame(in: .local) { frame in
                                    contentHeight = frame.height
                                }
                                .background(.obBackground)
                                .clipShape(.rect(cornerRadius: 30))
                                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: -4)
                        }
                        .ignoresSafeArea()
                }
            }
            .scrollTargetLayout()
        }
        .scrollDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $page, anchor: .center)
        .animation(.easeInOut, value: page)
        .overlay(alignment: .bottom) {
            if apphud.onboardingPaywall?.config.isPagingEnabled == true {
                dotsView()
                .padding(.bottom, page != .fifth ? safeArea.bottom + 130 : safeArea.bottom + 150)
            }
        }
        .onChange(of: page) { _, page in
            if page == .second {
                if ApphudManager.shared.onboardingPaywall?.config.isReviewEnabled == true {
                    RateAppManager.shared.requestReview()
                }
            }
        }
    }
}

// MARK: - Private methods

extension OnboardingView {

    private func overlayContent(from page: OnboardingPage) -> some View {
        VStack(spacing: 0) {
            titles(from: page)
                .padding(.top, 35)
                .padding(.horizontal, 12)

            mainButton(from: page)
                .padding(.top, 47)
                .padding(.horizontal, 23)
                .padding(.bottom, 20)

            if page == .fifth {
                bottomLinks()
                    .padding(.horizontal, 35.5)
            }
            Spacer()
        }
    }

    private func titles(from page: OnboardingPage) -> some View {
        VStack(spacing: 12) {
            Text(page.title)
                .font(.lufga(size:35, weight: .semibold))
                .foregroundStyle(.obTitle)

            Text(page.description)
                .font(.lufga(size: 18, weight: .semibold))
                .foregroundStyle(.obTitle.opacity(0.5))
                .opacity(apphud.onboardingPaywallDescriptionAlpha)
        }
        .multilineTextAlignment(.center)
    }

    private func mainButton(from page: OnboardingPage) -> some View {
        HapticButton(
            action: {
                switch page {
                case .first: self.page = .second
                case .second: self.page = .third
                case .third: self.page = .fourth
                case .fourth: self.page = .fifth
                case .fifth:
                    Task {
                        guard
                            let product = apphud.onboardingPaywall?.products.first,
                            await apphud.purchase(apphudProduct: product)
                        else {
                            return
                        }


                        setOnbiardingPassed()
                        appState.view = .main
                    }
                }
            },
            label: {
                VStack(spacing: 0) {
                    Text(
                        getButtonTitle(page: page)
                    )
                    .font(.lufga(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)

                    if
                        page == .fifth,
                        apphud.onboardingPaywall?.config == nil,
                        let subtitle = apphud.paywallButtonSubtitle(
                            apphudProduct: page == .fifth
                            ? apphud.onboardingPaywall?.products.first
                            : nil
                        )
                    {
                        if !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.lufga(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                                .opacity(0.5)
                        }
                    }
                }
                .frame(height: 54)
                .background(.obMainButtonBackground)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        )
    }
    
    private func getButtonTitle(page: OnboardingPage) -> String {
        if page == .first {
            return "Start"
        } else {
            guard let title = apphud.onboardingButtonTitle(
                apphudProduct: page == .fifth
                ? apphud.onboardingPaywall?.products.first
                : nil,
                config: apphud.onboardingPaywall?.config
            ) else {
                return "Next"
            }
            if page == .fifth {
                return title
            } else {
                return "Continue"
            }
        }
    }

    private func dotsView() -> some View {
        let obCases : [OnboardingPage] = [.first, .second, .third, .fourth]
        return HStack(spacing: 7) {
            ForEach(obCases) { page in
                Capsule()
                    .foregroundStyle(
                        LinearGradient(
                            colors: self.page == page
                            ? [.obMainButtonBackground]
                            : [.obTitle.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 7, height: 7)
            }
            Capsule()
                .foregroundStyle(
                    LinearGradient(
                        colors: self.page == .fifth
                        ? [.obMainButtonBackground]
                        : [.obTitle.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: self.page != .fifth ? 5.4 : 7, height: self.page != .fifth ? 5.4 : 7)
            Capsule()
                .foregroundStyle(.gray.opacity(0.3))
                .frame(width: self.page == .fifth ? 5.4 : 3.6, height: self.page == .fifth ? 5.4 : 3.6)
        }
        .frame(height: 8)
        .animation(.easeInOut, value: page)
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
                        .foregroundStyle(.obTitle.opacity(0.5))
                }
            )
            
            HapticButton(
                action: {
                    open(url: URL(string: Constants.terms)!)
                },
                label: {
                    Text("Terms")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(.obTitle.opacity(0.5))
                }
            )
            
            HapticButton(
                action: {
                    Task {
                        await apphud.restore()
                        
                        if apphud.isSubscribed {
                            setOnbiardingPassed()
                            appState.view = .main
                        }
                    }
                },
                label: {
                    Text("Restore")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(.obTitle.opacity(0.5))
                }
            )
            
            HapticButton(
                action: {
                    setOnbiardingPassed()
                    appState.view = .main
                },
                label: {
                    Text("Close")
                        .font(.anekLatin(size: 14, weight: .regular))
                        .foregroundStyle(.obTitle.opacity(0.5))
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

    private func setOnbiardingPassed() {
        UserDefaultsManager.shared.set(true, forKey: .onboardingCompleted)

        let isPassed: Bool? = UserDefaultsManager.shared.getValue(forKey: .onboardingCompleted)
        print(">>> isPassed \(isPassed)")
    }
}
