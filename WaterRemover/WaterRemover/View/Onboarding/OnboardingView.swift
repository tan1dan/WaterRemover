
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
        scrollPages()
        .overlay(alignment: .topTrailing) {
            ZStack(alignment: .topTrailing) {
                Color.clear

                if isCloseVisible {
                    HapticButton(
                        action: {
                            setOnbiardingPassed()
                            appState.view = .main
                        },
                        label: {
                            Image(.closeButton)
                                .resizable()
                                .frame(width: 25, height: 25)
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
                if page == .fifth {
                    HapticButton {
                        Task {
                            await apphud.restore()
                            
                            if apphud.isSubscribed {
                                setOnbiardingPassed()
                                appState.view = .main
                            }
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
            }
            .ignoresSafeArea()
        }
        .onChange(of: page) { _, page in
            if page == .second {
                if ApphudManager.shared.onboardingPaywall?.config.isReviewEnabled == true {
                    RateAppManager.shared.requestReview()
                }
            } else if page == .fifth {
                Task {
                    let closeAppearDelay = ApphudManager.shared.onboardingPaywall?.config.onboardingCloseDelay ?? 0

                    try await Task.sleep(for: .seconds(closeAppearDelay))

                    isCloseVisible = true
                }
            } else {
                isCloseVisible = false
            }
        }
    }
}

// MARK: - Private methods

extension OnboardingView {
    
    private func scrollPages() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(OnboardingPage.allCases) { page in
                    pageContent(page: page)
                }
            }
            .scrollTargetLayout()
        }
        .scrollDisabled(true)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $page, anchor: .center)
        .animation(.easeInOut, value: page)
        .overlay(alignment: .bottom) {
//            if apphud.onboardingPaywall?.config.isPagingEnabled == true {
                dotsView()
                .padding(.bottom, 150)
//            }
        }
    }
    
    private func pageContent(page: OnboardingPage) -> some View {
        GeometryReader { proxy in
            Image(page.image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: proxy.size.width + 2)
                .clipped()
                .id(page)
                .overlay(alignment: .bottom) {
                    overlayContent(from: page)
                        .frame(height: 400)
                        .frame(maxWidth: .infinity)
                        .background(Color.background)
                        .clipShape(DipShape(dipRadius: 100, dipWidth: proxy.size.width, isInverted: false))
                        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
                }
                .ignoresSafeArea()
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    

    private func overlayContent(from page: OnboardingPage) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                titles(from: page)
                    .padding(.top, 60)
                    .padding(.horizontal, 12)
                Spacer()
            }
            Spacer()
        }
        .overlay(alignment: .bottom) {
            if page == .fifth {
                bottomLinks()
                    .frame(height: 41)
                    .fixedSize()
                    .padding(.bottom, 30)
            }
        }
        .overlay(alignment: .top) {
            mainButton(from: page)
                .padding(.top, 60 + 142 + 47)
                .padding(.horizontal, 23)
        }
    }

    private func titles(from page: OnboardingPage) -> some View {
        VStack(spacing: 12) {
            Text(page.title)
                .font(.gilroy(size: 35, weight: .bold))
                .foregroundStyle(Color.customBlack)

            Text(page.description)
                .font(.gilroy(size: 18, weight: .medium))
                .foregroundStyle(Color.customBlack.opacity(0.5))
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
                    .font(.gilroy(size: 18, weight: .bold))
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
                                .font(.gilroy(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                                .opacity(0.5)
                        }
                    }
                }
                .frame(height: 54)
                .background(.customBlue)
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
                    .foregroundStyle(self.page == page
                                     ? Color.customBlue
                                     : .gray.opacity(0.3))
                    .frame(width: 7, height: 7)
            }
            Capsule()
                .foregroundStyle(self.page == .fifth
                                 ? Color.customBlue
                                 : .gray.opacity(0.3))
                .frame(width: self.page != .fifth ? 5.4 : 7, height: self.page != .fifth ? 5.4 : 7)
            Capsule()
                .foregroundStyle(.gray.opacity(0.3))
                .frame(width: self.page == .fifth ? 5.4 : 3.6, height: self.page == .fifth ? 5.4 : 3.6)
        }
        .frame(height: 8)
        .animation(.easeInOut, value: page)
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

    private func setOnbiardingPassed() {
        UserDefaultsManager.shared.set(true, forKey: .onboardingCompleted)

        let isPassed: Bool? = UserDefaultsManager.shared.getValue(forKey: .onboardingCompleted)
        print(">>> isPassed \(isPassed)")
    }
}
