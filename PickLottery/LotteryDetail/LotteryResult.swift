import Foundation

struct LotteryResult: Identifiable {
    let id: UUID = UUID()
    let entry: LotteryEntry
    let date: Date
}
