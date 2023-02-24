import SwiftUI

struct LotteryEntry: Identifiable {
    let id: UUID = UUID()
    
    let name: String
    let weight: Double
    let winningCounter: UInt
    let color: Color
    
    init(_ name: String, weight: Double = 1, winningCounter: UInt = 0) {
        self.name = name
        self.weight = weight
        self.winningCounter = winningCounter
        self.color = .random
    }
}

extension Double {
    static var random: Double {
        return Double(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Color {
    static var random: Color {
        .init(red: .random, green: .random, blue: .random)
    }
}
