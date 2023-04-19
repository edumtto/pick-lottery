import Foundation
import SwiftUI

final class CreateEntryViewModel: ObservableObject {
    private let lotteryStore: LotteryStorageProvider
    private let lottery: LotteryMO
    
    @Published var name: String = ""
    @Published var weight: Float = 1
    @Published var color: CGColor = Color.entryRandom.cgColor
    @Published var showValidationAlert = false
    
    init(lotteryStore: LotteryStorageProvider, lottery: LotteryMO) {
        self.lotteryStore = lotteryStore
        self.lottery = lottery
    }
    
    func createEntry() {
        if name.isEmpty {
            showValidationAlert = true
            return
        }
        let newEntry = Lottery.Entry(name, weight: weight, color: Color(cgColor: color))
        lotteryStore.addEntry(newEntry, in: lottery)
    }
}
