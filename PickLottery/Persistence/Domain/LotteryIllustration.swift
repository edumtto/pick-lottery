import Foundation

extension Lottery {
    enum Illustration: String, CaseIterable, Identifiable, Decodable {
        case callendar = "📆"
        case dice = "🎲"
        case gift = "🎁"
        case globe = "🌐"
        case race = "🏁"
        case clock = "🕐"
        case sentence = "💬"
        case heart = "♥️"
        case cards = "♠️"
        case gambing = "🎰"
        case fruit = "🍎"
        case book = "📚"
        case ice = "🧊"
        
        var id: String {
            rawValue
        }
        
        static var random: Self {
            Illustration.allCases.randomElement() ?? .dice
        }
    }
}
