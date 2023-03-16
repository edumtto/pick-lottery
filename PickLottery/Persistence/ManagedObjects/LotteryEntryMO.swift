import Foundation
import SwiftUI
import CoreData

@objc(LotteryEntryMO)
public class LotteryEntryMO: NSManagedObject {
    static var example: LotteryEntryMO {
        let context = LotteryStore.preview.container.viewContext
        let fetchRequest: NSFetchRequest<LotteryEntryMO> = LotteryEntryMO.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try! context.fetch(fetchRequest)
        return results.first!
    }
}

extension LotteryEntryMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryEntryMO> {
        return NSFetchRequest<LotteryEntryMO>(entityName: "LotteryEntry")
    }

    @NSManaged public var hexColor: String
    @NSManaged public var name: String
    @NSManaged public var weight: Float
    @NSManaged public var wins: Int32
    @NSManaged public var id: UUID
    @NSManaged public var lottery: LotteryMO?
    @NSManaged public var results: NSSet?

    var color: Color {
        Color(hex: hexColor) ?? Color.primary
    }
}

// MARK: Generated accessors for results
extension LotteryEntryMO {
    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: LotteryResultMO)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: LotteryResultMO)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

extension LotteryEntryMO : Identifiable {
}
