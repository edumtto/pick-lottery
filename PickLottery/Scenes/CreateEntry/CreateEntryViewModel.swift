import Foundation
import SwiftUI

final class CreateEntryViewModel: ObservableObject {
    let lotteryStore: LotteryStore
    let lottery: LotteryMO
    
    @Published var name: String = ""
    @Published var weight: Float = 1
    @Published var showValidationAlert = false
    
    init(lotteryStore: LotteryStore, lottery: LotteryMO) {
        self.lotteryStore = lotteryStore
        self.lottery = lottery
    }
    
    func createEntry() {
        if name.isEmpty {
            showValidationAlert = true
            return
        }
        let newEntry = Lottery.Entry(name, weight: weight)
        lotteryStore.addEntry(newEntry, in: lottery)
    }
}
