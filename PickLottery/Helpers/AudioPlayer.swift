import AVFoundation

struct AudioPlayer {
    let audioPlayer: AVAudioPlayer
    
    init?(sound: String, type: String) {
        guard let path = Bundle.main.path(forResource: sound, ofType: type) else {
            debugPrint("Wrong path for \(sound).\(type)")
            return nil
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    func play() {
        audioPlayer.play()
    }
}
