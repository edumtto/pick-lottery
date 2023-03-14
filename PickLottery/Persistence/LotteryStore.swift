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
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("Context saved")
            } catch {
                print(error)
                // Show some error here
            }
        }
    }
}

extension LotteryStore: LotteryStoring {
    func fetchLotteries() -> [Lottery] {
        let lotteryFetch: NSFetchRequest<LotteryMO> = LotteryMO.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(LotteryMO.name), ascending: false)
        lotteryFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = container.viewContext
            let results = try managedContext.fetch(lotteryFetch)
            print("Context loaded")
            return results.map(Lottery.init)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    func addLottery(_ lottery: Lottery) {
        let _ = lottery.lotteryMO(context: container.viewContext)
        save()
    }
    
    func removeLottery(_ lottery: Lottery) {
        
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
