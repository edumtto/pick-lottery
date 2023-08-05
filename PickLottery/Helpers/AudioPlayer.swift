import AVFoundation

struct AudioPlayer {
    enum Sound: String {
        case pick = "pick-sound"
        
        var type: String {
            "mp3"
        }
    }
    
    let player: AVAudioPlayer
    
    init?(sound: Sound) {
        guard let path = Bundle.main.path(forResource: sound.rawValue, ofType: sound.type) else {
            debugPrint("Wrong path for \(sound.rawValue).\(sound.type)")
            return nil
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    func play() {
        player.play()
    }
}
