import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    let id: UUID = UUID()
    let name: String
    var entries: [LotteryEntry]
    let color: Color
    // let configuration
    
    init(name: String, entries: [LotteryEntry] = []) {
        self.name = name
        self.entries = entries
        self.color = .random
    }
}
