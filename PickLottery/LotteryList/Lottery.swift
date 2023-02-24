import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    let id: UUID = UUID()
    let name: String
    var entries: [LotteryEntry]
    let color: Color
    var lastResults: [LotteryResult]
    // let configuration
    
    init(name: String, entries: [LotteryEntry] = [], lastResults: [LotteryResult] = []) {
        self.name = name
        self.entries = entries
        self.color = .random
        self.lastResults = lastResults
    }
}
