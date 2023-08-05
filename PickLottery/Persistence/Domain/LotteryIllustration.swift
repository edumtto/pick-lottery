import Foundation

extension Lottery {
    typealias Illustration = String
    
    static var randomIllustration: String {
        [
            "📆", "🎲", "🎁", "🌐", "🏁",
            "🕐", "💬", "♥️", "♠️", "🎰",
            "🍎", "📚", "🧊", "🍀", "🌵",
            "❓", "📕", "🪙", "🎱"
        ].randomElement() ?? "🎲"
    }
}
