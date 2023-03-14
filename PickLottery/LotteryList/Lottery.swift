import CoreData
import SwiftUI

final class Lottery: Identifiable, ObservableObject {
    enum RaffleMode: Int16, Identifiable, Codable {
        case fullRandom = 0
        case weightedEntries = 1
        case balancedVictories = 2
        
        static let options: [Self] = [.fullRandom, .weightedEntries, .balancedVictories]
        
        var id: Self { self }
        
        var description: String {
            switch self {
            case .fullRandom:
                return "Fully randomized (default)"
            case .weightedEntries:
                return "Weighted entries"
            case .balancedVictories:
                return "Balanced victories"
            }
        }
    }
    
    let id: UUID
    let name: String
    let color: Color
    let raffleMode: RaffleMode
    @Published var entries: [LotteryEntry]
    @Published var lastResults: [LotteryResult]
    
    init(id: UUID = .init(),
         name: String,
         entries: [LotteryEntry] = [],
         color: Color = .random,
         lastResults: [LotteryResult] = [],
         raffleMode: RaffleMode = .fullRandom
    ) {
        self.id = id
        self.name = name
        self.entries = entries
        self.color = color
        self.lastResults = lastResults
        self.raffleMode = raffleMode
    }
    
    convenience init(_ lotteryMO: LotteryMO) {
        self.init(
            id: lotteryMO.id,
            name: lotteryMO.name,
            entries: Array(lotteryMO.entries).compactMap({
                if let entryMO = $0 as? LotteryEntryMO {
                    return LotteryEntry(entryMO.name)
                }
                return nil
            }),
            color: Color(hex: lotteryMO.hexColor ?? "") ?? .red,
            raffleMode: RaffleMode(rawValue: lotteryMO.raffleMode) ?? .fullRandom
        )
    }
    
    func lotteryMO(context: NSManagedObjectContext) -> LotteryMO {
        let lotteryMO = LotteryMO(context: context)
        lotteryMO.id = id
        lotteryMO.name = name
        lotteryMO.hexColor = color.toHex() ?? ""
        lotteryMO.raffleMode = raffleMode.rawValue
        lotteryMO.entries = NSSet(
            array:
                entries.map { entry in
                    let entryMO = LotteryEntryMO(context: context)
                    entryMO.id = entry.id
                    entryMO.name = entry.name
                    entryMO.hexColor = entry.color.toHex()
                    entryMO.weight = Float(entry.weight)
                    entryMO.wins = Int32(entry.winningCounter)
                    return entryMO
                }
        )
        lotteryMO.results = .init()
        return lotteryMO
    }
}
