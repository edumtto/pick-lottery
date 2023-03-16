import Foundation

struct LotteryResult: Identifiable {
    let id: UUID = UUID()
    let entry: LotteryEntryMO
    let date: Date
}
