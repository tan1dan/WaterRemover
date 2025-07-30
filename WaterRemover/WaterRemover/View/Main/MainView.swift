

import SwiftUI

struct MainView: View {
    private var progress: CGFloat = 1
    
    @State private var isSpeakersView: Bool = false
    @State private var isSettingsView: Bool = false
    @State private var isArticlesView: Bool = false
    @State private var isVibrationView: Bool = false
    @State private var isPaywallView: Bool = false
    @State private var isToneGeneratorView: Bool = false
    @State private var isNoiseLevelView: Bool = false
    
    var body: some View {
        
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                
                HStack {
                    Spacer()
                    cards()
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, -80)
                .frame(height: UIScreen.main.bounds.height / 1.8)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.lowDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderMainView(isSettings: $isSettingsView, isPaywall: $isPaywallView)
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
            .overlay(alignment: .top) {
                HapticButton {
                    //TODO Remove water button
                    isVibrationView = true
                } label: {
                    mainButton()
                        .padding(.top, 84 + 62)
                }
            }
            .fullScreenCover(isPresented: $isSpeakersView) {
                SpeakersView()
            }
            .fullScreenCover(isPresented: $isSettingsView) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $isArticlesView) {
                ArticlesView()
            }
            .fullScreenCover(isPresented: $isVibrationView) {
                VibrationView()
            }
            .fullScreenCover(isPresented: $isPaywallView) {
                PaywallView()
            }
            .fullScreenCover(isPresented: $isToneGeneratorView) {
                ToneGeneratorView()
            }
            .fullScreenCover(isPresented: $isNoiseLevelView) {
                NoiseLevelView()
            }
    }
    
    private func cards() -> some View {
        VStack(alignment: .center, spacing: 11) {
            HStack(spacing: 11) {
                HapticButton {
                    //TODO Tone generator
                    isToneGeneratorView = true
                } label: {
                    CardView(image: Image(.tone), title: "Tone Generator", subtitle: "Make a custom tone")
                }

                HapticButton {
                    //TODO Noise level
                    isNoiseLevelView = true
                } label: {
                    CardView(image: Image(.noise), title: "Noise level", subtitle: "Measure a noise")
                }
            }
            
            HStack(spacing: 11) {
                HapticButton {
                    //TODO Speackers check
                    isSpeakersView = true
                } label: {
                    CardView(image: Image(.speakers), title: "Speakers check", subtitle: "Listen to your sound")
                }
                
                HapticButton {
                    //TODO Articles
                    isArticlesView = true
                } label: {
                    CardView(image: Image(.noise), title: "Articles", subtitle: "Know more about it")
                }
            }
        }
    }
    
    private func mainButton() -> some View {
        ZStack(alignment: .center) {
            
            // Прогресс
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.customBlue,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
                .padding(.all, 7)
            
            // Текст
            VStack(spacing: 5) {
                Image(.waterDrop)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Remove\nwater")
                    .foregroundStyle(Color.customBlue)
                    .font(.gilroy(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("Tap to start")
                    .foregroundStyle(Color.customBlue.opacity(0.5))
                    .font(.gilroy(size: 16, weight: .medium))
            }
        }
        .frame(width: 206, height: 206)
        .background(Color.white)
        .clipShape(Circle())
    }
}

