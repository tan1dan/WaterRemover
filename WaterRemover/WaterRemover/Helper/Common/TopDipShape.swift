
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

        if isInverted {
            // Впуклость снизу
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: dipEndX, y: rect.maxY))

            // Впуклая дуга вверх
            path.addQuadCurve(
                to: CGPoint(x: dipStartX, y: rect.maxY),
                control: CGPoint(x: dipCenterX, y: rect.maxY - dipRadius)
            )

            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.closeSubpath()
        } else {
            // Впуклость сверху
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: dipStartX, y: 0))

            // Впуклая дуга вниз
            path.addQuadCurve(
                to: CGPoint(x: dipEndX, y: 0),
                control: CGPoint(x: dipCenterX, y: dipRadius)
            )

            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: 0, y: rect.maxY))
            path.closeSubpath()
        }

        return path
    }
}
