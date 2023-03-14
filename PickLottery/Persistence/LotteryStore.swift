import CoreData
import Foundation
import SwiftUI

protocol LotteryStoring {
    func fetchLotteries() -> [Lottery]
    func addLottery(_ lottery: Lottery)
    func removeLottery(_ lottery: Lottery)
    func addEntry(_ entry: LotteryEntry, in lottery: Lottery)
    func removeEntry(_ entry: LotteryEntry, from lottery: Lottery)
    func addResult(_ result: LotteryResult, in lottery: Lottery)
    func clearResults(in lottery: Lottery)
}

class LotteryStore: ObservableObject {
    let container = NSPersistentContainer(name: "LotteryDataModel")

//    static var preview: PersistenceController = {
//        let controller = PersistenceController(inMemory: true)
//        let lottery = LotteryMO(context: controller.container.viewContext)
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
            let managedContext = container.viewContext
            let results = try managedContext.fetch(fetchRequest)
            print("Context loaded")
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
}

extension LotteryStore: LotteryStoring {
    func fetchLotteries() -> [Lottery] {
        fetchLotteriesMO().map(Lottery.init)
    }
    
    func addLottery(_ lottery: Lottery) {
        let managedContext = container.viewContext
        let _ = lottery.lotteryMO(context: managedContext)
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Error adding lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
    }
    
    func removeLottery(_ lottery: Lottery) {
        guard let lotteryMO = fetchLotteriesMO().first(where: { $0.id == lottery.id }) else {
            return
        }
        
        let managedContext = container.viewContext
        
        do {
            lotteryMO.results.forEach { managedContext.delete($0 as! LotteryResultMO) }
            lotteryMO.entries.forEach { managedContext.delete($0 as! LotteryEntryMO) }
            managedContext.delete(lotteryMO)
            try managedContext.save()
        } catch {
            debugPrint("Error removing lottery \"\(lottery.name)\".\nDescription: \(error)")
        }
    }
    
    func addEntry(_ entry: LotteryEntry, in lottery: Lottery) {
        
    }
    
    func removeEntry(_ entry: LotteryEntry, from lottery: Lottery) {
        
    }
    
    func addResult(_ result: LotteryResult, in lottery: Lottery) {
        
    }
    
    func clearResults(in lottery: Lottery) {
        
    }
}
