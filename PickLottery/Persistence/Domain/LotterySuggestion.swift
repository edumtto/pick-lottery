import Foundation
import SwiftUI

struct LotterySuggestion: Decodable {
    struct Entry: Decodable {
        let name: String
        let weight: Float?
    }
    
    let name: String
    let description: String?
    let illustration: Lottery.Illustration?
    let color: Int
    let raffleMode: Lottery.RaffleMode?
    let entries: [Entry]
    
    
    var lotteryEntries: [Lottery.Entry] {
        entries.map {
            Lottery.Entry($0.name, weight: $0.weight ?? 1.0)
        }
    }
    
    var lottery: Lottery {
        .init(
            name: name,
            description: description,
            illustration: illustration,
            entries: lotteryEntries,
            color: colorCodeToPallete(color),
            raffleMode: raffleMode ?? .fullRandom
        )
    }
    
    private func colorCodeToPallete(_ code: Int) -> Color {
        if code < Color.lotteryPallete.count {
            return Color.lotteryPallete[color]
        } else {
            return Color.lotteryPallete[0]
        }
        
    }
}
