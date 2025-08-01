import SwiftUI

struct CustomSlider: View {
    @Binding var value: Int

    let minValue: Int
    let maxValue: Int
    private let filledColor: Color = Color.customBlue
    private let unfilledColor: Color = Color.white

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let totalSteps = maxValue - minValue
            let progress = CGFloat(value - minValue) / CGFloat(totalSteps)
            let knobSize: CGFloat = 20

            ZStack(alignment: .leading) {
                // Unfilled Track
                Capsule()
                    .fill(unfilledColor)
                    .frame(height: 14)

                // Filled Track
                RoundedRectangle(cornerRadius: 7)
                    .fill(filledColor)
                    .frame(width: width * progress, height: 14)
                    .padding(.leading, value < 750 ? 10 : 0)
                // Custom Thumb
                Circle()
                    .fill(Color.sliderBlue)
                    .frame(width: knobSize, height: knobSize)
                    .offset(x: max(0, min(width - knobSize, width * progress - knobSize / 2)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let location = gesture.location.x
                                let percent = min(max(location / width, 0), 1)
                                let newValue = Int(round(percent * CGFloat(totalSteps))) + minValue
                                value = newValue
                            }
                    )
            }
            
        }
        .frame(height: 20)
    }
}
