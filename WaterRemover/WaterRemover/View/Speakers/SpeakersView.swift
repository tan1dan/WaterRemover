
import SwiftUI

struct SpeakersView: View {
    @State private var isTopSpeaker = false
    @State private var isBottomSpeaker = false
    @State private var isActive = false
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                VStack {
                    HapticButton {
                        isTopSpeaker.toggle()
                    } label: {
                        ZStack(alignment: .center) {
                            speakerTop()
                            LottieView(animationFileName: "speaker_animation", loopMode: .loop)
                                .frame(width: 206, height: 206)
                        }
                    }
                    .padding(.top, 69)

                    Text("Top speaker")
                        .font(.gilroy(size: 16, weight: .bold))
                        .foregroundStyle(.text)
                        .padding(.top, 11)
                    
                    HapticButton {
                        isBottomSpeaker.toggle()
                    } label: {
                        speakerBottom()
                            .padding(.top, 22)
                    }
                    
                    Text("Bottom speaker")
                        .font(.gilroy(size: 16, weight: .bold))
                        .foregroundStyle(.text)
                        .padding(.top, 11)
                    Spacer()
                    
                    HapticButton {
                        //TODO Speakers check start/stop
                    } label: {
                        button()
                            .padding(.bottom, 45)
                            .padding(.horizontal, 87)
                    }
                }
                .frame(height: UIScreen.main.bounds.height - 100)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.highDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Speakers Check")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
    }
    
    private func button() -> some View {
        HStack {
            Spacer()
            Text(isActive ? "Stop" : "Start")
                .foregroundStyle(.white)
                .font(.anekLatin(size: 18, weight: .bold))
            Spacer()
        }
        .frame(height: 54)
        .background(Color.customBlue)
        .clipShape(.rect(cornerRadius: 30))
    }
    
    private func speakerTop() -> some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 206, height: 206)
                .foregroundStyle(isTopSpeaker ? .customBlue : .white)
            
            Image(.speaker)
                .resizable()
                .frame(width: 164, height: 164)
        }
    }
    
    private func speakerBottom() -> some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 206, height: 206)
                .foregroundStyle(isBottomSpeaker ? .customBlue : .white)
            
            Image(.speaker)
                .resizable()
                .frame(width: 164, height: 164)
        }
    }
}

