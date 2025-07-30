
import SwiftUI

struct PerfectSyncSlider: View {
    enum Level: Int, CaseIterable {
        case light = 0, medium, hard
        
        var label: String {
            switch self {
            case .light: return "Light"
            case .medium: return "Medium"
            case .hard: return "Hard"
            }
        }
    }
    
    @Binding var selectedLevel: Level
    @State private var dragPosition: CGFloat = 0 // 0...1 normalized
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let step = 1.0 / CGFloat(Level.allCases.count - 1)
            
            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Color.white)
                    .frame(height: 14)
                
                // Filled part
                Capsule()
                    .fill(Color.customBlue)
                    .frame(width: dragPosition * width, height: 14)
                    
                
                // Thumb
                Image(.waterDrop)
                    .resizable()
                    .frame(width: 28, height: 29)
                    .padding(.bottom, 1)
                    .offset(x: dragPosition * width - 14)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let clamped = value.location.x.clamped(to: 0...width)
                                dragPosition = clamped / width
                            }
                            .onEnded { _ in
                                let nearest = round(dragPosition / step) * step
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    dragPosition = nearest
                                }
                                let newIndex = Int(round(nearest / step))
                                selectedLevel = Level(rawValue: newIndex) ?? .light
                            }
                    )
            }
            .frame(height: 40)
            .onAppear {
                dragPosition = CGFloat(selectedLevel.rawValue) * step
            }
            .onChange(of: selectedLevel) { newValue in
                withAnimation(.easeInOut(duration: 0.25)) {
                    dragPosition = CGFloat(newValue.rawValue) * step
                }
            }
        }
        .frame(height: 40)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}


