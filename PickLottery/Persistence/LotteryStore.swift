import CoreData
import Foundation
import SwiftUI

protocol LotteryStorageProvider {
    //func fetchLotteries() -> [Lottery]
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
    //@Published var lotteries: [LotteryMO] = .init()
    
    let container = NSPersistentContainer(name: "LotteryDataModel")
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static var preview: LotteryStore = {
        let storage = LotteryStore(inMemory: true)
        let entries: [Lottery.Entry] = [
            .init("João", weight: 1, wins: 0),
            .init("Maria", weight: 0, wins: 1),
            .init("James", weight: 1, wins: 0),
            .init("Ana", weight: 1.5, wins: 2)
        ]
        let results: [Lottery.Result] = [
            .init(entryID: entries[2].id, date: Date.init(timeIntervalSinceNow: -32)),
            .init(entryID: entries[0].id, date: Date())
        ]
        let lottery = Lottery(name: "Supper Lottery 1", entries: entries, results: results)
        storage.addLottery(lottery)
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
            print("Error saving contest: \(error) description: \(error.userInfo)")
        }
    }
    
    private func fetchLotteriesMO() -> [LotteryMO] {
        let fetchRequest: NSFetchRequest<LotteryMO> = LotteryMO.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(LotteryMO.name), ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        do {
            let results = try context.fetch(fetchRequest)
            print("Context loaded")
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    private func fetchLottery(id: UUID) -> LotteryMO? {
        let fetchRequest: NSFetchRequest<LotteryMO> = LotteryMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            print("Context loaded")
            return result.first
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    private func fetchEntriesMO(for lottery: Lottery) -> [LotteryEntryMO] {
        let fetchRequest: NSFetchRequest<LotteryEntryMO> = LotteryEntryMO.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(LotteryMO.name), ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        fetchRequest.predicate = NSPredicate(format: "lottery.id = %@", lottery.id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            print("Context loaded")
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    private func fetchEntry(id: UUID) -> LotteryEntryMO? {
        let fetchRequest: NSFetchRequest<LotteryEntryMO> = LotteryEntryMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            print("Context loaded")
            return results.first
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
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
        let context = context
        do {
            lottery.results.forEach { context.delete($0 as! LotteryResultMO) }
            lottery.entries.forEach { context.delete($0 as! LotteryEntryMO) }
            context.delete(lottery)
            try context.save()
        } catch {
            debugPrint("Error removing lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
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
