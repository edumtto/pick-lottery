import CoreData
import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    enum RaffleMode: Int16, Identifiable, Codable {
        case fullRandom = 0
        case weightedEntries = 1
        case avoidRepetition = 2
        
        static let options: [Self] = [.fullRandom, .weightedEntries, .avoidRepetition]
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .fullRandom:
                return "Default"
            case .weightedEntries:
                return "Weighted"
            case .avoidRepetition:
                return "No repetition"
            }
        }
        
        var detailedDescription: String {
            switch self {
            case .fullRandom:
                return "In a raffle with a default mode, the winner is chosen completely at random. Each entry has an equal chance of winning, regardless of how important or valuable it is. It doesn't matter how many raffles have taken place in the past, as each selection is completely independent and unaffected by previous outcomes. \nExample: Tossing a dice."
            case .weightedEntries:
                return "In a raffle with a weighted mode, the winner is still chosen randomly, but each entry has a different chance of winning based on its weight or importance. However, just like in the default mode, the outcome of the raffle is not influenced by previous raffles. Each selection is still completely independent and random."
            case .avoidRepetition:
                return "In a raffle with a no repetition mode, the winner is chosen randomly from the entries that haven't been picked yet, or have been picked fewer times than others. This means that the history of the raffles impacts the next selection. However, just like in the default mode, the importance or value of each entry is not taken into account. \nExample: Bingo game."
            }
        }
    }
    
    struct Entry: Identifiable {
        let id: UUID
        let name: String
        let weight: Float
        let wins: Int32
        let color: String
        
        init(_ name: String, id: UUID = UUID(), weight: Float = 1, wins: Int32 = 0, color: Color = .entryRandom) {
            self.id = id
            self.name = name
            self.weight = weight
            self.wins = wins
            self.color = color.toHex() ?? "FFFFFF"
        }
    }
    
    struct Result: Identifiable {
        let id: UUID = UUID()
        let entryID: UUID
        let date: Date
    }
    
    let id: UUID
    let name: String
    let description: String?
    let illustration: Illustration?
    let color: String
    let raffleMode: RaffleMode
    let entries: [Entry]
    let results: [Result]
    
    init(id: UUID = .init(),
         name: String,
         description: String? = nil,
         illustration: Illustration? = nil,
         entries: [Entry] = [],
         color: Color = .lotteryRandom,
         results: [Result] = [],
         raffleMode: RaffleMode = .fullRandom
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.illustration = illustration
        self.entries = entries
        self.color = color.toHex() ?? "FFFFFF"
        self.results = results
        self.raffleMode = raffleMode
    }
}
