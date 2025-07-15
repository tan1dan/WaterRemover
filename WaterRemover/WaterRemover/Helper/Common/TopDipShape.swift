
import SwiftUI

struct DipShape: Shape {
    var dipRadius: CGFloat
    var dipWidth: CGFloat
    var isInverted: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let dipCenterX = rect.midX
        let dipStartX = dipCenterX - dipWidth / 2
        let dipEndX = dipCenterX + dipWidth / 2

        let controlOffsetX = dipWidth / 2.5
        let controlOffsetY = dipRadius * 1.2

        if isInverted {
            // Впуклость снизу
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: dipEndX, y: rect.maxY))

            // Правая плавная кривая вверх
            path.addCurve(
                to: CGPoint(x: dipCenterX, y: rect.maxY - dipRadius),
                control1: CGPoint(x: dipEndX - controlOffsetX / 2, y: rect.maxY),
                control2: CGPoint(x: dipCenterX + controlOffsetX / 2, y: rect.maxY - dipRadius)
            )

            // Левая плавная кривая вниз
            path.addCurve(
                to: CGPoint(x: dipStartX, y: rect.maxY),
                control1: CGPoint(x: dipCenterX - controlOffsetX / 2, y: rect.maxY - dipRadius),
                control2: CGPoint(x: dipStartX + controlOffsetX / 2, y: rect.maxY)
            )

            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.closeSubpath()
        } else {
            // Впуклость сверху
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: dipStartX, y: 0))

            // Левая плавная кривая вниз
            path.addCurve(
                to: CGPoint(x: dipCenterX, y: dipRadius),
                control1: CGPoint(x: dipStartX + controlOffsetX / 2, y: 0),
                control2: CGPoint(x: dipCenterX - controlOffsetX / 2, y: dipRadius)
            )

            // Правая плавная кривая вверх
            path.addCurve(
                to: CGPoint(x: dipEndX, y: 0),
                control1: CGPoint(x: dipCenterX + controlOffsetX / 2, y: dipRadius),
                control2: CGPoint(x: dipEndX - controlOffsetX / 2, y: 0)
            )

            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.closeSubpath()
        }

        return path
    }
}
