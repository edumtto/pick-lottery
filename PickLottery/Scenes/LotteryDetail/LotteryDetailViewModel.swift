import Foundation
import SwiftUI

final class LotteryDetailViewModel: ObservableObject {
    let lotteryStore: LotteryStorageProvider
    @Published var lottery: LotteryMO
    @Published var animate: Bool = false
    @Published var presentRaffleAnimation = false
    @Published var isRaffleAnimationFinished = false
    
    @Published var presentEntryEditor = false
    @Published var presentRaffleModeDescription = false
    
    @Published var isResultsEmpty: Bool // Only used to trigger View update after cleaning results
    
    var selectedLotteryEntry: LotteryEntryMO?
    
    var lastResults: [LotteryResultMO] {
        Array(lottery.results)
            .compactMap { $0 as? LotteryResultMO }
            .sorted { $0.date > $1.date }
    }
    
    var entries: [LotteryEntryMO] {
        Array(lottery.entries)
            .compactMap { $0 as? LotteryEntryMO }
            .sorted { $0.name < $1.name }
    }
    
    var color: Color {
        Color(hex: lottery.hexColor) ?? Color.primary
    }
    
    var modeDescription: String {
        (Lottery.RaffleMode(rawValue: lottery.raffleMode) ?? .fullRandom).description
    }
    
    init(lottery: LotteryMO, lotteryStore: LotteryStorageProvider) {
        self.lottery = lottery
        self.lotteryStore = lotteryStore
        isResultsEmpty = lottery.results.count == 0
    }
    
    func raffleButtonAction(completion: @escaping () -> Void = {}) {
        isRaffleAnimationFinished = false
        
        let selectedEntry = raffleRandomEntry()
        selectedLotteryEntry = selectedEntry
        presentRaffleAnimation.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.lotteryStore.addResult(id: .init(), date: Date(), entry: selectedEntry, in: self.lottery)
            completion()
        }
    }
    
    func clearResults() {
        lotteryStore.clearResults(in: lottery)
        isResultsEmpty = true
    }
    
    func deleteLottery() {
        lotteryStore.removeLottery(lottery)
    }
    
    private func raffleRandomEntry() -> LotteryEntryMO {
        let numberOfEntries = lottery.entries.count
        var entryIndexes = [Int]()
        let raffleMode = Lottery.RaffleMode(rawValue: lottery.raffleMode) ?? .fullRandom
        
        switch raffleMode {
        case .balancedVictories:
            var biggerVictoryNumber: UInt = 0
            entries.forEach { entry in
                if entry.wins > biggerVictoryNumber {
                    biggerVictoryNumber = UInt(entry.wins)
                }
            }
            
            for i in 0..<numberOfEntries {
                let entry = entries[i]
                if entry.wins < biggerVictoryNumber {
                    entryIndexes.append(i)
                }
            }
            
        case .weightedEntries:
            for i in 0..<numberOfEntries {
                let entry = entries[i]
                entryIndexes.append(contentsOf: [Int](repeating: i, count: Int(entry.weight)))
            }
        case .fullRandom:
            entryIndexes = [Int](0..<numberOfEntries)
        }
        
        let randomNum = Int(arc4random_uniform(UInt32(entryIndexes.count)))
        let randomIndex = entryIndexes.index(entryIndexes.startIndex, offsetBy: randomNum)
        let randomEntryIndex = entryIndexes[randomIndex]
        return entries[randomEntryIndex]
    }
}
