import AVFoundation
import Foundation

class MicrophoneDBManager: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    // твой код без изменений
    
    @Published var currentDB: Float = 0
    private var smoothingFactor: Float = 0.2
    
    private var lastValidDB: Float = 0
    private var decayRate: Float = 1.0 // dB/обновление
    
    // Добавим здесь буфер значений для графика
    @Published var dbValues: [Double] = [1]
    
    var count: Int {
        dbValues.count
    }
    
    private let maxBufferSize = 50 // сколько последних значений держать
    
    func start() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            let url = URL(fileURLWithPath: "/dev/null")
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
            startMonitoring()
            
        } catch {
            print("❌ Ошибка аудио: \(error)")
        }
    }
    
    private func startMonitoring() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard let recorder = self.audioRecorder else { return }
            recorder.updateMeters()
            
            let averagePower = recorder.averagePower(forChannel: 0) // [-160, 0]
            let normalized = max(0, min(1, (averagePower + 60) / 60)) // [0, 1]
            let rawDB = normalized * 120 // [0, 120]

            var finalDB: Float = rawDB
            
            // Обнаружение "падения в 0"
            if rawDB < 2 {
                // затухаем от предыдущего значения
                finalDB = max(0, self.lastValidDB - self.decayRate)
            } else {
                self.lastValidDB = rawDB
            }

            // Сглаживание
            let smoothed = self.smoothingFactor * finalDB + (1 - self.smoothingFactor) * self.currentDB

            DispatchQueue.main.async {
                self.currentDB = smoothed
                
                // Обновляем буфер значений для графика
                self.dbValues.append(Double(smoothed))

            }
        }
    }

    func stop() {
        audioRecorder?.stop()
        timer?.invalidate()
        audioRecorder = nil
    }
}
