//
//  CircularTicksView.swift
//  WaterRemover
//
//  Created by Иван Знак on 29/07/2025.
//


import SwiftUI

struct CircularTicksView: View {
    // 11 углов по кругу: от 210° до 150° по часовой стрелке
    let tickAngles = stride(from: 210.0, through: 150.0 + 360, by: 30.0).map { $0.truncatingRemainder(dividingBy: 360) }

    let tickHeight: CGFloat = 14
    let tickWidth: CGFloat = 2
    let tickOffset: CGFloat = 45
    var circleRadius: CGFloat {
        isScreenBig ? 80 : 60
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

            ZStack {
                
                // Тики
                ForEach(tickAngles, id: \.self) { angle in
                    TickMark(
                        angle: angle - 90,
                        radius: circleRadius,
                        height: tickHeight,
                        width: tickWidth,
                        offset: tickOffset,
                        center: center
                    )
                }

                // Подписи
                LabelAtAngle(text: "0", angle: 210 - 90, radius: circleRadius + tickOffset + 10, center: center)
                LabelAtAngle(text: "60", angle: 0 - 90, radius: circleRadius + tickOffset + (isScreenBig ? 12 : 8), center: center)
                LabelAtAngle(text: "120", angle: 150 - 90, radius: circleRadius + tickOffset + 12, center: center)
            }
            .frame(width: isScreenBig ? 320 : 280, height: isScreenBig ? 320 : 280)
        }
        .frame(width: isScreenBig ? 320 : 280, height: isScreenBig ? 320 : 280) // чуть больше, чтобы тики не обрезались
    }
}

struct TickMark: View {
    let angle: Double
    let radius: CGFloat
    let height: CGFloat
    let width: CGFloat
    let offset: CGFloat
    let center: CGPoint

    var body: some View {
        let rad = Angle(degrees: angle).radians
        let inner = radius + offset - height
        let outer = radius + offset

        let x1 = cos(rad) * inner + center.x
        let y1 = sin(rad) * inner + center.y
        let x2 = cos(rad) * outer + center.x
        let y2 = sin(rad) * outer + center.y

        Path { path in
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y2))
        }
        .stroke(Color.white.opacity(0.5), lineWidth: width)
        .clipShape(.capsule)
    }
}

struct LabelAtAngle: View {
    let text: String
    let angle: Double
    let radius: CGFloat
    let center: CGPoint

    var body: some View {
        let rad = Angle(degrees: angle).radians
        let x = cos(rad) * radius + center.x
        let y = sin(rad) * radius + center.y

        Text(text)
            .font(.gilroy(size: 14, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.5))
            .position(x: x, y: y)
    }
}
