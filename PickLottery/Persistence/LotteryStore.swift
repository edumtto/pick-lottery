import CoreData
import Foundation
import SwiftUI

protocol LotteryStoring {
    //func fetchLotteries() -> [Lottery]
    func addLottery(_ lottery: Lottery)
    func removeLottery(_ lottery: LotteryMO)
    func addEntry(_ entry: LotteryEntry, in lottery: LotteryMO)
    func removeEntries(_ entries: [LotteryEntryMO], from lottery: LotteryMO)
    func addResult(_ result: LotteryResult, in lottery: LotteryMO)
    func clearResults(in lottery: LotteryMO)
}

class LotteryStore: ObservableObject {
    //@Published var lotteries: [LotteryMO] = .init()
    
    let container = NSPersistentContainer(name: "LotteryDataModel")
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
//    static var preview: LotteryStore = {
//        let controller = LotteryStore(inMemory: true)
//        let _ = LotteryMO(
//            .init(
//                name: "Supper Lottery 1",
//                entries:  [
//                    .init("João", weight: 1, winningCounter: 0),
//                    .init("Maria", weight: 0, winningCounter: 1),
//                    .init("James", weight: 1, winningCounter: 0),
//                    .init("Ana", weight: 1.5, winningCounter: 2)
//                ],
//                lastResults: [
//                    .init(entry: .init("João"), date: Date()),
//                    .init(entry: .init("Maria"), date: Date()),
//                    .init(entry: .init("James"), date: Date()),
//                    .init(entry: .init("Ana"), date: Date())
//                ]
//            ),
//            context: controller.container.viewContext
//        )
//        return controller
//    }()
    
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
    
    private func save() throws {
        let context = container.viewContext

        if context.hasChanges {
            try context.save()
            print("Context saved")
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
}

extension LotteryStore: LotteryStoring {
//    func fetchLotteries() -> [Lottery] {
//        fetchLotteriesMO().map(Lottery.init)
//    }
    
    func addLottery(_ lottery: Lottery) {
        let _ = LotteryMO(lottery, context: context)
        
        do {
            try context.save()
        } catch {
            debugPrint("Error adding lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
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
    
//    func fetchEntries(for lottery: Lottery) -> [LotteryEntry] {
//        fetchEntriesMO(for: lottery).map(\.lotteryEntry)
//    }
    
    func addEntry(_ entry: LotteryEntry, in lottery: LotteryMO) {
        let entryMO = LotteryEntryMO(context: context)
        entryMO.id = entry.id
        entryMO.lottery = lottery
        entryMO.name = entry.name
        entryMO.weight = entry.weight
        entryMO.wins = Int32(entry.winningCounter)
        entryMO.results = .init()
        entryMO.hexColor = entry.color.toHex() ?? "FFFFFF"
        
        do {
            try context.save()
            print("success!")
        } catch {
            debugPrint("Error adding lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
    }
    
    func removeEntries(_ entries: [LotteryEntryMO], from lottery: LotteryMO) {
        entries.forEach { context.delete($0) }
        do {
            try context.save()
            print("success!")
        } catch {
            debugPrint("Error adding lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
    }
    
    func addResult(_ result: LotteryResult, in lottery: LotteryMO) {
        let resultMO = LotteryResultMO(context: context)
        resultMO.lottery = lottery
        resultMO.id = result.id
        resultMO.entry = result.entry
        resultMO.date = result.date
        
        do {
            try context.save()
        } catch {
            debugPrint("Error adding lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
    }
    
    func clearResults(in lottery: LotteryMO) {
        do {
            lottery.results.forEach { context.delete($0 as! LotteryResultMO) }
            try context.save()
        } catch let error as NSError {
            print("Delete result error: \(error) description: \(error.userInfo)")
        }
    }
}
