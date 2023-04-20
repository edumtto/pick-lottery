import Foundation
import SwiftUI

final class LotteryEntriesViewModel: ObservableObject {
    let lotteryStore: LotteryStorageProvider
    @Binding var lottery: LotteryMO
    
    @Published var updateView = true
    @Published var showCreateEntry = false
    
    var entries: [LotteryEntryMO] {
        Array(lottery.entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    init(lottery: Binding<LotteryMO>, lotteryStore: LotteryStorageProvider) {
        self._lottery = lottery
        self.lotteryStore = lotteryStore
    }
    
    func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entries[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
    }
}
