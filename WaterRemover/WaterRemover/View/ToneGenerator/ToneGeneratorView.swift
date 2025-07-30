
import SwiftUI
import AudioKit

struct ToneGeneratorView: View {
    
    @State private var selectedHZ: Int = 1 {
        didSet {
            if isActive {
                if isActive {
                    toneManager.updateFrequency(AUValue(selectedHZ))
                }
            }
        }
    }
    
    @State private var selectedTone: ToneType = .none
    @State private var isActive: Bool = false
    
    @StateObject private var toneManager = ToneGeneratorManager()
    
    private var progress: CGFloat {
        CGFloat(selectedHZ) / 30000
    }
    
    private let vibrationTypeWidth: CGFloat = 114
    
    var body: some View {
        LinearGradient(colors: [Color.topGradient, Color.bottomGradient], startPoint: .top, endPoint: .bottom)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                //Content
                VStack(alignment: .leading, spacing: 0) {
                    Text("Frequency")
                        .font(.gilroy(size: 16, weight: .bold))
                        .padding(.top, 80)
                        .foregroundStyle(Color.text)
                    CustomSlider(value: $selectedHZ, minValue: 1, maxValue: 30000)
                        .padding(.top, 11)
                    levelTitles()
                        .padding(.top, 15)
                    Text("Use against")
                        .font(.gilroy(size: 16, weight: .bold))
                        .foregroundStyle(Color.text)
                        .padding(.top, 22)
                    
                    vibrationTypes()
                        .padding(.top, 11)
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
                HeaderView(title: "Tone Generator")
                    .padding(.top, 62)
                    .padding(.horizontal, 20)
            }
            .overlay(alignment: .top) {
                
                mainButton()
                    .padding(.top, 84 + 62)
                
            }
            .onChange(of: selectedHZ) { oldValue, newValue in
                if selectedHZ == 15 {
                    selectedTone = .headache
                } else if selectedHZ == 500 {
                    selectedTone = .water
                } else if selectedHZ == 15000 {
                    selectedTone = .ticks
                } else if selectedHZ == 20000 {
                    selectedTone = .rodents
                } else if selectedHZ == 25000 {
                    selectedTone = .dogs
                } else if selectedHZ == 30000 {
                    selectedTone = .insects
                } else {
                    selectedTone = .none
                }
            }
    }
    
    private func levelTitles() -> some View {
        HStack {
            Text("1 Hz")
                .font(.gilroy(size: 14, weight: .medium))
                .foregroundStyle(Color.text.opacity(0.5))
            Spacer()
            
            Text("30 000 Hz")
                .font(.gilroy(size: 14, weight: .medium))
                .foregroundStyle(Color.text.opacity(0.5))
        }
        .frame(height: 17)
    }
    
    private func startStop() -> some View {
        HStack {
            Spacer()
            
            HapticButton {
                //TODO Start pause action
                isActive.toggle()
                if isActive {
                    toneManager.startTone(frequency: AUValue(selectedHZ))
                } else {
                    toneManager.stopTone()
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
            VStack(spacing: 0) {
                Text("\(selectedHZ) HZ")
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
            HStack(spacing: 11) {
                Spacer()
                //First Vibration
                HapticButton {
                    //TODO First Type Action
                    selectedTone = .rodents
                    selectedHZ = 20000
                } label: {
                    rodents()
                }
                
                
                //Second Vibration
                HapticButton {
                    //TODO Second Type Action
                    selectedTone = .dogs
                    selectedHZ = 25000
                } label: {
                    dogs()
                }
                
                
                //Third Vibration
                HapticButton {
                    //TODO Third Type Action
                    selectedTone = .insects
                    selectedHZ = 30000
                } label: {
                    insects()
                }
                
                Spacer()
            }
            
            //Second Line
            HStack(spacing: 11) {
                Spacer()
                
                //Fourth Vibration
                HapticButton {
                    //TODO Fourth Type Action
                    selectedTone = .ticks
                    selectedHZ = 15000
                } label: {
                    ticks()
                }
                
                
                
                //Fifth Vibration
                HapticButton {
                    //TODO Fifth Type Action
                    selectedTone = .water
                    selectedHZ = 500
                } label: {
                    water()
                }
                
                
                //Sixth Vibration
                HapticButton {
                    //TODO Sixth Type Action
                    selectedTone = .headache
                    selectedHZ = 15
                } label: {
                    headache()
                }
                
                Spacer()
            }
            
        }
        
    }
    
    private func rodents() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .rodents ? .rodentsChosen : .rodentsNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Rodents")
                .foregroundStyle(selectedTone == .rodents ? Color.white : Color.text)
                .font(selectedTone == .rodents ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .rodents ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func dogs() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .dogs ? .dogChosen : .dogNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Dogs")
                .foregroundStyle(selectedTone == .dogs ? Color.white : Color.text)
                .font(selectedTone == .dogs ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .dogs ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func insects() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .insects ? .insectsChosen : .insectsNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Insects")
                .foregroundStyle(selectedTone == .insects ? Color.white : Color.text)
                .font(selectedTone == .insects ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .insects ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func ticks() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .ticks ? .ticksChosen : .ticksNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Ticks")
                .foregroundStyle(selectedTone == .ticks ? Color.white : Color.text)
                .font(selectedTone == .ticks ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .ticks ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func water() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .water ? .waterChosen : .waterNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Water")
                .foregroundStyle(selectedTone == .water ? Color.white : Color.text)
                .font(selectedTone == .water ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .water ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
    
    private func headache() -> some View {
        HStack {
            Spacer()
            Image(selectedTone == .headache ? .headacheChosen : .headacheNotChosen)
                .resizable()
                .frame(width: 20, height: 20)
            Text("Headache")
                .foregroundStyle(selectedTone == .headache ? Color.white : Color.text)
                .font(selectedTone == .headache ? .gilroy(size: 14, weight: .bold) : .gilroy(size: 14, weight: .medium))
                .lineLimit(1)
            Spacer()
        }
        .frame(width: vibrationTypeWidth, height: 40)
        .background(selectedTone == .headache ? Color.customBlue : Color.white)
        .clipShape(.rect(cornerRadius: 50))
    }
}

