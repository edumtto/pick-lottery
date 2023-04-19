import CoreData
import Foundation
@testable import PickLottery

class LotteryStoreSpy: LotteryStorageProvider {
    let container = NSPersistentContainer(name: "LotteryDataModel")
    
    private(set) var addLotteryCalls: [Lottery] = []
    
    func addLottery(_ lottery: Lottery) {
        addLotteryCalls.append(lottery)
    }
    
    private(set) var removeLotteryCalls: [LotteryMO] = []
    
    func removeLottery(_ lottery: LotteryMO) {
        removeLotteryCalls.append(lottery)
    }
    
    private(set) var addEntryCalls: [(entry: Lottery.Entry, lottery: LotteryMO)] = []
    
    func addEntry(_ entry: Lottery.Entry, in lottery: LotteryMO) -> LotteryEntryMO {
        addEntryCalls.append((entry: entry, lottery: lottery))
        return LotteryEntryMO(context: container.viewContext)
    }
    
    private(set) var removeEntriesCalls: [(entries: [LotteryEntryMO], lottery: LotteryMO)] = []
    
    func removeEntries(_ entries: [LotteryEntryMO], from lottery: LotteryMO) {
        removeEntriesCalls.append((entries: entries, lottery: lottery))
    }
    
    private(set) var addResultCalls: [(id: UUID, date: Date, entry: LotteryEntryMO, lottery: LotteryMO)] = []
    
    func addResult(id: UUID, date: Date, entry: LotteryEntryMO, in lottery: LotteryMO) -> LotteryResultMO {
        addResultCalls.append((id: id, date: date, entry: entry, lottery: lottery))
        return LotteryResultMO(context: container.viewContext)
    }
    
    private(set) var clearResultsCalls: [LotteryMO] = []
    
    func clearResults(in lottery: LotteryMO) {
        clearResultsCalls.append(lottery)
    }
}
