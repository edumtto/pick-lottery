import Foundation
import SwiftUI

final class LotteryDetailViewModel: ObservableObject {
    let lotteryStore: LotteryStorageProvider
    let addResultDelay: DispatchTimeInterval
    
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
        Color(hex: lottery.hexColor) ?? Color.accentColor
    }
    
    var modeDescription: String {
        raffleMode.description
    }
    
    var modeDetailedDescription: String {
        raffleMode.detailedDescription
    }
    
    var drawButtonTitle: String {
        if isEntriesEmpty {
            return "Register entries"
        }
        return "Draw"
    }
    
    var isEntriesEmpty: Bool {
        lottery.entries.anyObject() == nil
    }
    
    var entriesAmmountText: String {
        if isEntriesEmpty {
            return "No entries"
        }
        
        let n = lottery.entries.count
        if n == 1 {
            return "1 entry"
        }
        return String(n) + " entries"
    }
    
    private var raffleMode: Lottery.RaffleMode {
        Lottery.RaffleMode(rawValue: lottery.raffleMode) ?? .fullRandom
    }
    
    init(
        lottery: LotteryMO,
        lotteryStore: LotteryStorageProvider,
        addResultDelay: DispatchTimeInterval = .seconds(1)
    ) {
        self.lottery = lottery
        self.lotteryStore = lotteryStore
        self.addResultDelay = addResultDelay
        isResultsEmpty = lottery.results.count == 0
    }
    
    func raffleButtonAction(completion: @escaping () -> Void = {}) {
        if isEntriesEmpty {
            presentEntryEditor = true
            return
        }
        isRaffleAnimationFinished = false
        
        let selectedEntry = raffleRandomEntry()
        selectedLotteryEntry = selectedEntry
        presentRaffleAnimation.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + addResultDelay) {
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
        
        switch raffleMode {
        case .avoidRepetition:
            var biggerVictoryNumber: UInt = 0
            var lowerVictoryNumber: UInt = .max
            
            entries.forEach { entry in
                if entry.wins > biggerVictoryNumber {
                    biggerVictoryNumber = UInt(entry.wins)
                }
                if entry.wins < lowerVictoryNumber {
                    lowerVictoryNumber = UInt(entry.wins)
                }
            }
            
            if lowerVictoryNumber == biggerVictoryNumber {
                entryIndexes = [Int](0..<numberOfEntries)
            } else {
                for i in 0..<numberOfEntries {
                    let entry = entries[i]
                    if entry.wins < biggerVictoryNumber {
                        entryIndexes.append(i)
                    }
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
