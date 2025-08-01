import AVFoundation

class VibrationAudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var audioSession = AVAudioSession.sharedInstance()

    // MARK: - Start

    func start(level: Int) {
        stop()

        guard let url = Bundle.main.url(forResource: "check_song", withExtension: "mp3") else {
            print("❌ Не найден файл check_song.mp3")
            return
        }

        // Преобразуем уровень в громкость: 0 → 0.2, 1 → 0.6, 2 → 1.0
        let volumeLevels: [Float] = [0.2, 0.6, 1.0]
        let volume = volumeLevels[safe: level] ?? 0.6

        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
            try audioSession.setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌ Ошибка настройки аудио: \(error)")
        }
    }

    // MARK: - Stop

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// MARK: - Безопасный доступ к массиву по индексу
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
