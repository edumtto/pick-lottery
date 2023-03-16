import Foundation
import CoreData

@objc(LotteryResultMO)
public class LotteryResultMO: NSManagedObject {
}

extension LotteryResultMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryResultMO> {
        return NSFetchRequest<LotteryResultMO>(entityName: "LotteryResult")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var entry: LotteryEntryMO
    @NSManaged public var lottery: LotteryMO

}

extension LotteryResultMO : Identifiable {
}
