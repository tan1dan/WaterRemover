

import SwiftUI

struct NoiseLevelView: View {
    @State private var currentDB: CGFloat = 25
    @State private var isActive: Bool = false
    
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
        if currentDB > 0 && currentDB < 60 {
            return "Normal"
        } else if currentDB >= 60 && currentDB <= 80 {
            return "Loud"
        } else {
            return "Dangerous"
        }
    }
    
    private var levelColor: Color {
        let color: Color
        if currentDB > 0 && currentDB < 60 {
            color = Color.customBlue
        } else if currentDB >= 60 && currentDB <= 80 {
            color = Color.orange
        } else {
            color = Color.red
        }
        return color.opacity(0.5)
    }
    
    private let vibrationTypeWidth: CGFloat = 114
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                //Content
                VStack(alignment: .leading, spacing: 0) {
                    ScrollableChartView()
                        .padding(.top, 80)
                    Spacer()
                    
                    startStop()
                        .padding(.bottom, 45)

                }
                .padding(.horizontal, 20)
                .frame(height: UIScreen.main.bounds.height / 1.8)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.lowDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Noise Level")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
            .overlay(alignment: .top) {
                
                mainButton()
                    .padding(.top, 84 + 62)
                
            }
    }
    
    private func startStop() -> some View {
        HStack {
            Spacer()
            
            HapticButton {
                //TODO Start pause action
                isActive.toggle()
            } label: {
                StartStopView(isActive: $isActive)
            }
            
            Spacer()
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
        .frame(width: 206, height: 206)
        .background(Color.white)
        .clipShape(Circle())
        .overlay(alignment: .center) {
            CircularTicksView()
        }
        
    }
    
}

