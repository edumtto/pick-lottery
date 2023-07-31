import Foundation
import SwiftUI

final class LotteryEntriesViewModel: ObservableObject {
    private(set) var lotteryStore: LotteryStorageProvider
    @Binding private(set) var lottery: LotteryMO
    
    @Published var updateView = true
    @Published var showCreateEntry = false
    
    var color: Color {
        Color(hex: lottery.hexColor) ?? Color.primary
    }
    
    var entries: [LotteryEntryMO] {
        Array(lottery.entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    init(lottery: Binding<LotteryMO>, lotteryStore: LotteryStorageProvider) {
        self._lottery = lottery
        self.lotteryStore = lotteryStore
        
        //lottery.didChange().assign
    }
    
    func deleteItems(offsets: IndexSet) {
        let selectedEntries = offsets.map { entries[$0] }
        lotteryStore.removeEntries(selectedEntries, from: lottery)
        
        //objectWillChange.send()
    }
}
