
import Foundation
import CoreHaptics

@Observable
final class VibrationManager {
    private var engine: CHHapticEngine?
    private var player: CHHapticAdvancedPatternPlayer?
    private var isRunning = false

    init() {
        prepareHaptics()
    }

    func start(type: Int, level: Int) {
        stop() // Остановить если уже играет

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("⚠️ Устройство не поддерживает haptics")
            return
        }

        guard let pattern = generatePattern(for: type, intensityLevel: level) else { return }

        do {
            player = try engine?.makeAdvancedPlayer(with: pattern)
            try engine?.start()
            try player?.start(atTime: 0)
            isRunning = true

            // Цикл
            player?.completionHandler = { [weak self] _ in
                guard self?.isRunning == true else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    try? self?.player?.start(atTime: 0)
                }
            }
        } catch {
            print("❌ Ошибка воспроизведения: \(error)")
        }
    }

    func stop() {
        isRunning = false
        try? player?.stop(atTime: 0)
        engine?.stop(completionHandler: nil)
    }

    private func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("❌ Не удалось создать движок: \(error)")
        }
    }

    private func generatePattern(for type: Int, intensityLevel: Int) -> CHHapticPattern? {
        let intensity: Float
        switch intensityLevel {
        case 0: intensity = 0.3
        case 1: intensity = 0.6
        case 2: intensity = 1.0
        default: intensity = 0.5
        }

        // Морзе-подобные шаблоны (короткие и длинные)
        let patterns: [[(duration: Double, pause: Double)]] = [
            [(1000, 0)],   // Тип 0
            [(0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.2, 0)],// Тип 1
            [(0.2, 0.1), (0.5, 0.1), (0.2, 0.1), (0.5, 0.1), (0.2, 0.1), (0.5, 0.1), (0.2, 0.0)],   // Тип 2
            [(0.2, 0.1), (0.2, 0.1), (0.2, 0.1), (0.5, 0.1), (0.5, 0.0)],   // Тип 3
            [(0.5, 0.1), (0.5, 0.1), (0.5, 0)],    // Тип 4
            [(0.2, 0.1), (0.2, 0.1), (0.5, 0.1) , (0.2, 0.1), (0.2, 0.0),]  // Тип 5
        ]

        guard type >= 0 && type < patterns.count else { return nil }

        var events: [CHHapticEvent] = []
        var time: TimeInterval = 0

        for segment in patterns[type] {
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    .init(parameterID: .hapticIntensity, value: intensity),
                    .init(parameterID: .hapticSharpness, value: 0.8)
                ],
                relativeTime: time,
                duration: segment.duration
            )
            events.append(event)
            time += segment.duration + segment.pause
        }

        return try? CHHapticPattern(events: events, parameters: [])
    }
}
