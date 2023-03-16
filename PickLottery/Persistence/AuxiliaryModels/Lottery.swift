import CoreData
import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    enum RaffleMode: Int16, Identifiable, Codable {
        case fullRandom = 0
        case weightedEntries = 1
        case balancedVictories = 2
        
        static let options: [Self] = [.fullRandom, .weightedEntries, .balancedVictories]
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .fullRandom:
                return "Fully randomized (default)"
            case .weightedEntries:
                return "Weighted entries"
            case .balancedVictories:
                return "Balanced victories"
            }
        }
    }
    
    struct Entry: Identifiable {
        let id: UUID
        let name: String
        let weight: Float
        let wins: Int32
        let color: String
        
        init(_ name: String, id: UUID = UUID(), weight: Float = 1, wins: Int32 = 0, color: Color = .random) {
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
    let color: String
    let raffleMode: RaffleMode
    let entries: [Entry]
    let results: [Result]
    
    init(id: UUID = .init(),
         name: String,
         entries: [Entry] = [],
         color: Color = .random,
         results: [Result] = [],
         raffleMode: RaffleMode = .fullRandom
    ) {
        self.id = id
        self.name = name
        self.entries = entries
        self.color = color.toHex() ?? "FFFFFF"
        self.results = results
        self.raffleMode = raffleMode
    }
}
