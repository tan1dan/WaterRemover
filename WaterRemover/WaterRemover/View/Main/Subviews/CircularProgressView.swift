import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: CGFloat // от 0 до 1

    var body: some View {
        ZStack {
            // Фон круга
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 8)
            
            // Прогресс
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            // Текст
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                Text("Removing ...")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(width: 200, height: 200)
        .background(Color.blue)
        .clipShape(Circle())
    }
}
