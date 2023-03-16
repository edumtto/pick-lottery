import Foundation
import CoreData

@objc(LotteryMO)
public class LotteryMO: NSManagedObject {

}

extension LotteryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryMO> {
        return NSFetchRequest<LotteryMO>(entityName: "Lottery")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var hexColor: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var raffleMode: Int16
    @NSManaged public var entries: NSSet
    @NSManaged public var results: NSSet

    convenience init(_ lottery: Lottery, context: NSManagedObjectContext) {
        self.init(context: context)
        id = lottery.id
        name = lottery.name
        hexColor = lottery.color.toHex() ?? ""
        raffleMode = lottery.raffleMode.rawValue
        entries = NSSet(
            array:
                lottery.entries.map { entry in
                    let entryMO = LotteryEntryMO(context: context)
                    entryMO.id = entry.id
                    entryMO.name = entry.name
                    entryMO.hexColor = entry.color.toHex() ?? "FFFFFF"
                    entryMO.weight = Float(entry.weight)
                    entryMO.wins = Int32(entry.winningCounter)
                    return entryMO
                }
        )
        results = .init()
    }
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
