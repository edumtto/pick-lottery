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
    // let description: String
    let color: Color
    let raffleMode: RaffleMode
    @Published var entries: [LotteryEntry]
    @Published var lastResults: [LotteryResult]
    
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
