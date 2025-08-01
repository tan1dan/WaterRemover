import Foundation
import AudioKit
import Observation

@Observable
final class ToneGeneratorManager: ObservableObject {
    private let engine = AudioEngine()
    private var oscillator: PlaygroundOscillator?

    func startTone(frequency: AUValue) {
        stopTone()

        let oscillator = PlaygroundOscillator(waveform: Table(.sine))
        oscillator.frequency = frequency
        oscillator.amplitude = 0.5
        self.oscillator = oscillator

        engine.output = oscillator

        do {
            try engine.start()
            oscillator.start()
            print("▶️ Тон запущен: \(frequency) Hz")
        } catch {
            print("❌ Ошибка запуска тона: \(error.localizedDescription)")
        }
    }

    func updateFrequency(_ frequency: AUValue) {
        oscillator?.frequency = frequency
    }

    func stopTone() {
        oscillator?.stop()
        oscillator = nil
        engine.stop()
        print("⏹️ Тон остановлен")
    }
}
