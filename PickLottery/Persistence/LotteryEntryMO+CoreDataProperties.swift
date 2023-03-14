//
//  LotteryEntryMO+CoreDataProperties.swift
//  PickLottery
//
//  Created by Eduardo Motta de Oliveira on 3/13/23.
//
//

import Foundation
import CoreData


extension LotteryEntryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryEntryMO> {
        return NSFetchRequest<LotteryEntryMO>(entityName: "LotteryEntry")
    }

    @NSManaged public var hexColor: String?
    @NSManaged public var name: String
    @NSManaged public var weight: Float
    @NSManaged public var wins: Int32
    @NSManaged public var id: UUID
    @NSManaged public var lottery: LotteryMO?
    @NSManaged public var results: NSSet?

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
