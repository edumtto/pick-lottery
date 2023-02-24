import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    let id: UUID = UUID()
    let name: String
    var entries: [LotteryEntry]
    let color: Color
    var lastResults: [LotteryResult]
    var configuration: LotteryConfiguration
    
    init(name: String,
         entries: [LotteryEntry] = [],
         lastResults: [LotteryResult] = [],
         configuration: LotteryConfiguration = LotteryConfiguration(weightedEntries: false, balancedVictories: false)
    ) {
        self.name = name
        self.entries = entries
        self.color = .random
        self.lastResults = lastResults
        self.configuration = configuration
    }
}

struct LotteryConfiguration {
    var weightedEntries: Bool
    var balancedVictories: Bool
}
