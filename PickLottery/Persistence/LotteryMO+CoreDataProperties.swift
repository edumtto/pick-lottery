import Foundation
import CoreData


extension LotteryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryMO> {
        return NSFetchRequest<LotteryMO>(entityName: "Lottery")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var hexColor: String?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var raffleMode: Int16
    @NSManaged public var entries: NSSet
    @NSManaged public var results: NSSet

}

// MARK: Generated accessors for entries
extension LotteryMO {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: LotteryEntryMO)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: LotteryEntryMO)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

// MARK: Generated accessors for results
extension LotteryMO {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: LotteryResultMO)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: LotteryResultMO)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

extension LotteryMO : Identifiable {

}
