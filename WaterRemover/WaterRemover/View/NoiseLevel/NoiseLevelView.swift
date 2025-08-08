

import SwiftUI

struct NoiseLevelView: View {
    
    private var currentDB: CGFloat {
        return CGFloat(micManager.currentDB)
    }
    
    @State private var isActive: Bool = false
    @State private var isPaywall: Bool = false
    
    @StateObject private var micManager = MicrophoneDBManager()
    private let userDefaults = UserDefaultsManager.shared
    private let apphud = ApphudManager.shared
    
    private var progress: CGFloat {
        let minVisualTrim: CGFloat = 0.01
        let maxVisualTrim: CGFloat = 1.0 - 1.0 / 6.0 // 0.8333...
        let minDB: CGFloat = 0
        let maxDB: CGFloat = 120
        
        // Пример: currentDB можно сделать @State или брать из модели
        let normalizedProgress = (CGFloat(currentDB) - minDB) / (maxDB - minDB)
        let visualProgress = minVisualTrim + (maxVisualTrim - minVisualTrim) * normalizedProgress
        return visualProgress
    }
    
    private var levelText: String {
        if currentDB >= 0 && currentDB < 60 {
            return "Normal"
        } else if currentDB >= 60 && currentDB <= 80 {
            return "Loud"
        } else {
            return "Dangerous"
        }
    }
    
    private var levelColor: Color {
        let color: Color
        if currentDB >= 0 && currentDB < 60 {
            color = Color.customBlue
        } else if currentDB >= 60 && currentDB <= 80 {
            color = Color.orange
        } else {
            color = Color.red
        }
        return color.opacity(0.5)
    }
    
    private var freeTranslationCount: Int {
        userDefaults.getValue(forKey: .freeTranlationsCompleted) ?? 0
    }
    
    let freeAccessCount: Int = 1
    
    private let vibrationTypeWidth: CGFloat = 114
    
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                //Content
                VStack(alignment: .leading, spacing: 0) {
                    ScrollableChartView(micManager: micManager, isActive: $isActive)
                        .padding(.top, 80)
                    Spacer()
                    
                    startStop()
                        .padding(.bottom, 45)

                }
                .padding(.horizontal, 20)
                .frame(height: isScreenBig ? UIScreen.main.bounds.height / 1.8 : 430)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.lowDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Noise Level")
                    .padding(.top, paddingHeaderTop)
                    .padding(.horizontal, 20)
            }
            .overlay(alignment: .top) {
                mainButton()
                    .padding(.top, isScreenBig ? 84 + paddingHeaderTop : 64 + paddingHeaderTop)
            }
            .fullScreenCover(isPresented: $isPaywall) {
                PaywallView()
            }
    }
    
    private func startStop() -> some View {
        HStack {
            Spacer()
            
            HapticButton {
                //TODO Start pause action
                
                if apphud.isSubscribed || freeTranslationCount <= freeAccessCount {
                    if freeTranslationCount <= freeAccessCount {
                        var count = freeTranslationCount
                        count+=1
                        userDefaults.set(count, forKey: .freeTranlationsCompleted)
                    }
                    startStopAction()
                } else {
                    isPaywall = true
                }
            } label: {
                StartStopView(isActive: $isActive)
            }
            
            Spacer()
        }
    }
    
    private func startStopAction() {
        isActive.toggle()
        if isActive {
            micManager.start()
        } else {
            micManager.stop()
        }
    }
    
    private func mainButton() -> some View {
        
        return ZStack(alignment: .center) {
            // Прогресс
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.customBlue,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(120))
                .animation(.easeInOut, value: progress)
                .padding(.all, 7)
            
            // Текст
            VStack(spacing: 3) {
                Text("\(Int(currentDB)) dB")
                    .foregroundStyle(Color.customBlue)
                    .font(.gilroy(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                Text(levelText)
                    .foregroundStyle(levelColor)
                    .font(.gilroy(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: isScreenBig ? 206 : 166, height: isScreenBig ? 206 : 166)
        .background(Color.white)
        .clipShape(Circle())
        .overlay(alignment: .center) {
            CircularTicksView()
        }
        
    }
    
}

