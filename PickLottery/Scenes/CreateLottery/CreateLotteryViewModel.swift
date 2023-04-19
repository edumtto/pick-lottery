import Foundation
import SwiftUI

final class CreateLotteryViewModel: ObservableObject {
    var lotteryStore: LotteryStorageProvider
    
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var color: Color = .lotteryRandom
    @Published var emoji: String = Lottery.Illustration.random.rawValue
    @Published var raffleMode: Lottery.RaffleMode = .fullRandom
    @Published var entriesDescription: String = ""
    @Published var showValidationAlert = false
    
    var illustrations: [Lottery.Illustration] {
        Lottery.Illustration.allCases
    }
    
    var raffleModes: [Lottery.RaffleMode] {
        Lottery.RaffleMode.options
    }
    
    func createLottery() {
        if name.isEmpty {
            showValidationAlert = true
            return
        }
        
        let entries: [Lottery.Entry] = entriesDescription
            .components(separatedBy: ",")
            .compactMap {
                let entryName = $0.trimmingCharacters(in: CharacterSet(charactersIn: " "))
                return entryName.isEmpty ? nil : Lottery.Entry(entryName)
            }
        
        let newLottery = Lottery(
            name: name,
            description: description,
            illustration: .init(rawValue: emoji),
            entries: entries,
            color: color,
            raffleMode: raffleMode
        )
        lotteryStore.addLottery(newLottery)
    }
    
    init(lotteryStore: LotteryStorageProvider) {
        self.lotteryStore = lotteryStore
    }
}
