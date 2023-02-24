import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    enum RaffleMode: String, Identifiable {
        case fullRandom = "Fully randomized (default)"
        case weightedEntries = "Weighted entries"
        case balancedVictories = "Balanced victories"
        
        static let options: [Self] = [.fullRandom, .weightedEntries, .balancedVictories]
        
        var id: Self { self }
    }
    
    let id: UUID = UUID()
    let name: String
    var entries: [LotteryEntry]
    let color: Color
    var lastResults: [LotteryResult]
    var raffleMode: RaffleMode
    
    init(name: String,
         entries: [LotteryEntry] = [],
         lastResults: [LotteryResult] = [],
         raffleMode: RaffleMode = .fullRandom
    ) {
        self.name = name
        self.entries = entries
        self.color = .random
        self.lastResults = lastResults
        self.raffleMode = raffleMode
    }
}
