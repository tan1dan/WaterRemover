
import SwiftUI

struct SpeakersView: View {
    @State private var isTopSpeaker = false {
        didSet {
            userDefaults.set(isTopSpeaker, forKey: .topSpeaker)
        }
    }
    @State private var isBottomSpeaker = false {
        didSet {
            userDefaults.set(isBottomSpeaker, forKey: .bottomSpeaker)
        }
    }
    @State private var isActive = false
    @StateObject var speakerManager = SpeakerCheckManager()

    let userDefaults = UserDefaultsManager()
    
    private var topSpeakerOpacity: Double {
        if isTopSpeaker && isActive {
            return 0
        } else {
            return 1
        }
    }
    
    private var topAnimationOpacity: Double {
        if isTopSpeaker && isActive {
            return 1
        } else {
            return 0
        }
    }
    
    private var bottomSpeakerOpacity: Double {
        if isBottomSpeaker && isActive {
            return 0
        } else {
            return 1
        }
    }
    
    private var bottomAnimationOpacity: Double {
        if isBottomSpeaker && isActive {
            return 1
        } else {
            return 0
        }
    }
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                VStack {
                    HapticButton {
                        isTopSpeaker.toggle()
                    } label: {
                        
                        speakerTop()
                            .opacity(topSpeakerOpacity)
                            .overlay(alignment: .center) {
                                LottieView(animationFileName: "speaker_animation", loopMode: .loop)
                                    .frame(width: 500, height: 500)
                                    .opacity(topAnimationOpacity)
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
                            .opacity(bottomSpeakerOpacity)
                            .overlay(alignment: .center) {
                                LottieView(animationFileName: "speaker_animation", loopMode: .loop)
                                    .frame(width: 500, height: 500)
                                    .opacity(bottomAnimationOpacity)
                            }
                    }
                    
                    Text("Bottom speaker")
                        .font(.gilroy(size: 16, weight: .bold))
                        .foregroundStyle(.text)
                        .padding(.top, 11)
                    Spacer()
                    
                    HapticButton {
                        //TODO Speakers check start/stop
                        isActive.toggle()
                        if isActive {
                            speakerManager.start(top: isTopSpeaker, bottom: isBottomSpeaker)
                        } else {
                            speakerManager.stop()
                        }
                    } label: {
                        button()
                            .padding(.bottom, 45)
                            .padding(.horizontal, 87)
                    }
                }
                .frame(height: isScreenBig ? UIScreen.main.bounds.height - 100 : UIScreen.main.bounds.height - 50)
                .frame(maxWidth: .infinity)
                .background(Color.background)
                .clipShape(Constants.highDipShape)
                .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: -1)
            }
            .overlay(alignment: .top) {
                HeaderView(title: "Speakers Check")
                    .padding(.top, paddingHeaderTop)
                    .padding(.horizontal, 20)
            }
            .onAppear {
                isTopSpeaker = userDefaults.getValue(forKey: .topSpeaker) ?? false
                isBottomSpeaker = userDefaults.getValue(forKey: .bottomSpeaker) ?? false
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
                .frame(width: isScreenBig ? 206 : 186, height: isScreenBig ? 206 : 186)
                .foregroundStyle(isTopSpeaker ? .customBlue : .white)
            
            Image(.speaker)
                .resizable()
                .frame(width: isScreenBig ? 164 : 154, height: isScreenBig ? 164 : 154)
        }
    }
    
    private func speakerBottom() -> some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: isScreenBig ? 206 : 186, height: isScreenBig ? 206 : 186)
                .foregroundStyle(isBottomSpeaker ? .customBlue : .white)
            
            Image(.speaker)
                .resizable()
                .frame(width: isScreenBig ? 164 : 154, height: isScreenBig ? 164 : 154)
        }
    }
}

