

import AVFoundation

class SpeakerCheckManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private var audioSession = AVAudioSession.sharedInstance()

    // MARK: - Start

    func start(top: Bool, bottom: Bool) {
        stop()

        guard let url = Bundle.main.url(forResource: "check_song", withExtension: "mp3") else {
            print("❌ Не найден файл check_song.mp3")
            return
        }

        do {
            
            if top && !bottom {
                // Используем верхний динамик (receiver)
                try audioSession.setCategory(.playAndRecord, options: []) // без defaultToSpeaker
            } else if bottom && !top {
                try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker])
               
            } else {
                // Оба — iOS по умолчанию воспроизводит через нижний
                try audioSession.setCategory(.playback)
            }

            try audioSession.setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
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

        do {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

}
