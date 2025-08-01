
import SwiftUI
import MessageUI

struct SettingsView: View {
    
    let settingsManager = SettingsActionsManager.share
    
    @State private var isShowingMail = false
    @State private var isShowingShare = false
    @State private var showMailAlert = false
    
    var items: [SettingsItem] = [
        SettingsItem(image: Image(.rateApp), text: "Rate the App", subtext: "Share your rating of the app", type: .rateUs),
        SettingsItem(image: Image(.contactUs), text: "Contact Us", subtext: "Write us if you need help", type: .support),
        SettingsItem(image: Image(.termsOfUse), text: "Terms of Use", subtext: "Read about how to use the app", type: .termsOfUse),
        SettingsItem(image: Image(.privacyPolicy), text: "Privacy Policy", subtext: "Know more about your safety", type: .privacy),
        SettingsItem(image: Image(.share), text: "Share with Friends", subtext: "Tell your friends about the app", type: .share),
    ]
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                   list()
                        .padding(.horizontal, 20)
                        .padding(.top, Constants.topPadding)
                   Spacer()
               }
                .frame(height: UIScreen.main.bounds.height - 100)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.highDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Settings")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
    }
    
    func list() -> some View {
        VStack(spacing: 14) {
            Group {
                ForEach(items.indices, id: \.self) { index in
                    HapticButton {
                        switch items[index].type {
                        case .rateUs:
                            settingsManager.rate_us()
                        case .support:
                            if MFMailComposeViewController.canSendMail() {
                                isShowingMail = true
                            } else {
                                showMailAlert = true
                                print("Mail services are not available")
                            }
                        case .share:
                            isShowingShare = true
                        case .privacy:
                            settingsManager.openLink(Constants.privacy)
                        case .termsOfUse:
                            settingsManager.openLink(Constants.terms)
                        }
                    } label: {
                        SettingCell(image: items[index].image, title: items[index].text, subtitle: items[index].subtext, buttonType: items[index].type)
                    }
                    
                }
            }
        }
        .sheet(isPresented: $isShowingMail) {
            MailView(
                recipient: Constants.contactEmail,
                subject: "Support",
                messageBody: "Hey team, I need some help..."
            )
            .presentationDetents([.large])
        }
        .sheet(isPresented: $isShowingShare) {
            if
                let url = URL(
                    string: "https://apps.apple.com/app/id\(Constants.appleId)"
                )
            {
                ActivityView(activityItems: [url])
                    .presentationDetents([.fraction(0.75)])
            }
        }
        .alert("Error", isPresented: $showMailAlert) {
            Button("Ок", role: .cancel) { }
        } message: {
            Text("Mail services are not available")
        }
    }
    
}

