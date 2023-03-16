import CoreData
import Foundation
import SwiftUI

protocol LotteryStorageProvider {
    func addLottery(_ lottery: Lottery)
    func removeLottery(_ lottery: LotteryMO)
    
    @discardableResult
    func addEntry(_ entry: Lottery.Entry, in lottery: LotteryMO) -> LotteryEntryMO
    func removeEntries(_ entries: [LotteryEntryMO], from lottery: LotteryMO)
    
    @discardableResult
    func addResult(id: UUID, date: Date, entry: LotteryEntryMO, in lottery: LotteryMO) -> LotteryResultMO
    func clearResults(in lottery: LotteryMO)
}

class LotteryStore: ObservableObject {
    let container = NSPersistentContainer(name: "LotteryDataModel")
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static var preview: LotteryStore = {
        let storage = LotteryStore(inMemory: true)
        
        let entries1: [Lottery.Entry] = [
            .init("João", weight: 1, wins: 0),
            .init("Maria", weight: 0, wins: 1),
            .init("James", weight: 1, wins: 0),
            .init("Ana", weight: 1.5, wins: 2)
        ]
        let results1: [Lottery.Result] = [
            .init(entryID: entries1[2].id, date: Date.init(timeIntervalSinceNow: -32)),
            .init(entryID: entries1[0].id, date: Date())
        ]
        let lottery1 = Lottery(name: "Supper Lottery 1", entries: entries1, results: results1)
        storage.addLottery(lottery1)
        
        let entries2: [Lottery.Entry] = [1, 2, 3, 4, 5, 6].map { Lottery.Entry.init(String($0)) }
        let lottery2 = Lottery(name: "🎲\nDice", entries: entries2, results: .init())
        storage.addLottery(lottery2)
        
        return storage
    }()

    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            print(description)
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving context: \(error) description: \(error.userInfo)")
        }
    }
    
    private func fetchEntry(id: UUID) -> LotteryEntryMO? {
        let fetchRequest: NSFetchRequest<LotteryEntryMO> = LotteryEntryMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            print("Context loaded")
            return results.first
        } catch let error as NSError {
            print("Fetch entry error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
}

extension LotteryStore: LotteryStorageProvider {
    func addLottery(_ lottery: Lottery) {
        let lotteryMO = LotteryMO(context: context)
        lotteryMO.id = lottery.id
        lotteryMO.name = lottery.name
        lotteryMO.hexColor = lottery.color
        lotteryMO.raffleMode = lottery.raffleMode.rawValue
        let entiesList = lottery.entries.map { entry in
            return addEntry(entry, in: lotteryMO)
        }
        lotteryMO.entries = NSSet(array: entiesList)
        let resultList: [LotteryResultMO] = lottery.results.compactMap { result in
            guard let entry = fetchEntry(id: result.entryID) else { return nil }
            return addResult(id: result.id, date: result.date, entry: entry, in: lotteryMO)
        }
        lotteryMO.results = NSSet(array: resultList)
        saveContext()
    }
    
    func removeLottery(_ lottery: LotteryMO) {
        lottery.results.forEach { context.delete($0 as! LotteryResultMO) }
        lottery.entries.forEach { context.delete($0 as! LotteryEntryMO) }
        context.delete(lottery)
        saveContext()
    }
    
    @discardableResult
    func addEntry(_ entry: Lottery.Entry, in lottery: LotteryMO) -> LotteryEntryMO {
        let entryMO = LotteryEntryMO(context: context)
        entryMO.id = entry.id
        entryMO.name = entry.name
        entryMO.hexColor = entry.color
        entryMO.weight = entry.weight
        entryMO.wins = entry.wins
        entryMO.lottery = lottery
        saveContext()
        return entryMO
    }
    
    func removeEntries(_ entries: [LotteryEntryMO], from lottery: LotteryMO) {
        entries.forEach { context.delete($0) }
        saveContext()
    }
    
    @discardableResult
    func addResult(id: UUID, date: Date, entry: LotteryEntryMO, in lottery: LotteryMO) -> LotteryResultMO {
        let resultMO = LotteryResultMO(context: context)
        resultMO.id = id
        resultMO.entry = entry
        resultMO.date = date
        resultMO.lottery = lottery
        saveContext()
        return resultMO
    }
    
    func clearResults(in lottery: LotteryMO) {
        lottery.results.forEach { context.delete($0 as! LotteryResultMO) }
        saveContext()
    }
}
