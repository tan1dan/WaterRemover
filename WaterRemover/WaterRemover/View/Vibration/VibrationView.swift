
import SwiftUI

struct VibrationView: View {
    
    @State private var selectedLevel: PerfectSyncSlider.Level = .light
    @State private var selectedVibration: VibrationType = .first
    @State private var isActive: Bool = false
    
    @State private var vibrationManager = VibrationManager()
    
    private var progress: CGFloat = 1
    
    private let rectangleHeight: CGFloat = 3
    private let rectangleSpacing: CGFloat = 3
    private let vibrationTypeWidth: CGFloat = 114
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                //Content
                VStack(alignment: .leading, spacing: 0) {
                    Text("Intensity")
                        .font(.gilroy(size: 16, weight: .bold))
                        .padding(.top, 80)
                        .foregroundStyle(Color.text)
                    PerfectSyncSlider(selectedLevel: $selectedLevel)
                        .padding(.top, 11)
                        .padding(.horizontal, 5)
                        .disabled(isActive)
                    levelTitles()
                        .padding(.top, 11)
                    Text("Vibration mode")
                        .font(.gilroy(size: 16, weight: .bold))
                        .foregroundStyle(Color.text)
                        .padding(.top, 22)
                    
                    vibrationTypes()
                        .padding(.top, 11)
                        .disabled(isActive)
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
                HeaderView(title: "Water Remover")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
            .overlay(alignment: .top) {
                HapticButton {
                    //TODO Remove water button
                } label: {
                    mainButton()
                        .padding(.top, 84 + 62)
                }
            }
    }
    
    private func levelTitles() -> some View {
        HStack {
            Text("light")
                .font(.gilroy(size: 14, weight: .medium))
                .foregroundStyle(Color.text.opacity(0.5))
            Spacer()
            
            Text("medium")
                .font(.gilroy(size: 14, weight: .medium))
                .foregroundStyle(Color.text.opacity(0.5))
            Spacer()
            
            Text("hard")
                .font(.gilroy(size: 14, weight: .medium))
                .foregroundStyle(Color.text.opacity(0.5))
        }
    }
    
    private func startStop() -> some View {
        HStack {
            Spacer()
            
            HapticButton {
                //TODO Start pause action
                isActive.toggle()
                if isActive {
                    var vibrationType: Int
                    var vibrationLevel: Int
                    
                    switch selectedVibration {
                    case .first:
                        vibrationType = 0
                    case .second:
                        vibrationType = 1
                    case .third:
                        vibrationType = 2
                    case .fourth:
                        vibrationType = 3
                    case .fifth:
                        vibrationType = 4
                    case .sixth:
                        vibrationType = 5
                    }
                    
                    switch selectedLevel {
                    case .light:
                        vibrationLevel = 0
                    case .medium:
                        vibrationLevel = 1
                    case .hard:
                        vibrationLevel = 2
                    }
                    vibrationManager.start(type: vibrationType, level: vibrationLevel)
                } else {
                    vibrationManager.stop()
                }
            } label: {
                StartStopView(isActive: $isActive)
                    
            }
            
            Spacer()
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
            }
        }
        .frame(width: 206, height: 206)
        .background(Color.white)
        .clipShape(Circle())
    }
    
    private func vibrationTypes() -> some View {
        
        VStack(alignment: .center, spacing: 11) {
            //First line
            HStack {
                //First Vibration
                HapticButton {
                    //TODO First Type Action
                    selectedVibration = .first
                } label: {
                    firstRectangles()
                }
                
                Spacer()
                
                //Second Vibration
                HapticButton {
                    //TODO Second Type Action
                    selectedVibration = .second
                } label: {
                    secondRectangles()
                }
                
                Spacer()
                
                //Third Vibration
                HapticButton {
                    //TODO Third Type Action
                    selectedVibration = .third
                } label: {
                    thirdRectangles()
                }
            }
            
            //Second Line
            HStack {
                //Fourth Vibration
                HapticButton {
                    //TODO Fourth Type Action
                    selectedVibration = .fourth
                } label: {
                    fourthRectangles()
                }
                
                Spacer()
                
                //Fifth Vibration
                HapticButton {
                    //TODO Fifth Type Action
                    selectedVibration = .fifth
                } label: {
                    fifthRectangles()
                }
                
                Spacer()
                
                //Sixth Vibration
                HapticButton {
                    //TODO Sixth Type Action
                    selectedVibration = .sixth
                } label: {
                    sixthRectangles()
                }
            }
            
        }
        
    }
    
    private func firstRectangles() -> some View {
        HStack {
            Spacer()
            Capsule()
                .frame(width: 72, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .first ? Color.white : Color.text)
                .padding(.horizontal, 16)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .first ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func secondRectangles() -> some View {
        HStack(spacing: rectangleSpacing) {
            
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                .padding(.leading, 16)
            
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
               
           
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                
            
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                
            
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                
           
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                
            
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                
           
            Capsule()
                .frame(width: 7, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .second ? Color.white : Color.text)
                .padding(.trailing, 16)
           
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .second ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func thirdRectangles() -> some View {
        HStack(spacing: rectangleSpacing) {
            
            Capsule()
                .frame(width: 6, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
                .padding(.leading, 16)
            
            Capsule()
                .frame(width: 11, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
               
            
            Capsule()
                .frame(width: 6, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
                
            
            Capsule()
                .frame(width: 11, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
                
           
            Capsule()
                .frame(width: 6, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
                
            
            Capsule()
                .frame(width: 11, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
            
           
            Capsule()
                .frame(width: 6, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .third ? Color.white : Color.text)
                .padding(.trailing, 16)
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .third ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func fourthRectangles() -> some View {
        HStack(spacing: rectangleSpacing) {
            
            Capsule()
                .frame(width: 8, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fourth ? Color.white : Color.text)
                .padding(.leading, 16)
        
            
            Capsule()
                .frame(width: 8, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fourth ? Color.white : Color.text)
                
           
            Capsule()
                .frame(width: 8, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fourth ? Color.white : Color.text)
            
           
            Capsule()
                .frame(width: 18, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fourth ? Color.white : Color.text)
            
            Capsule()
                .frame(width: 18, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fourth ? Color.white : Color.text)
                .padding(.trailing, 16)
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .fourth ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func fifthRectangles() -> some View {
        HStack(spacing: rectangleSpacing) {
            
            Capsule()
                .frame(width: 24, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fifth ? Color.white : Color.text)
                .padding(.leading, 16)
            
            Capsule()
                .frame(width: 24, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fifth ? Color.white : Color.text)
            
            Capsule()
                .frame(width: 24, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .fifth ? Color.white : Color.text)
                .padding(.trailing, 16)
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .fifth ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func sixthRectangles() -> some View {
        HStack(spacing: rectangleSpacing) {
            
            Capsule()
                .frame(width: 10, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .sixth ? Color.white : Color.text)
                .padding(.leading, 16)
            
            Capsule()
                .frame(width: 10, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .sixth ? Color.white : Color.text)
            
            Capsule()
                .frame(width: 25, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .sixth ? Color.white : Color.text)
            
            Capsule()
                .frame(width: 10, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .sixth ? Color.white : Color.text)
            
            Capsule()
                .frame(width: 10, height: rectangleHeight)
                .foregroundStyle(selectedVibration == .sixth ? Color.white : Color.text)
                .padding(.trailing, 16)
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedVibration == .sixth ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
}

