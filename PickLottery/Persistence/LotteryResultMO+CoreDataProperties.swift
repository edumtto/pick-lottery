//
//  LotteryResultMO+CoreDataProperties.swift
//  PickLottery
//
//  Created by Eduardo Motta de Oliveira on 3/13/23.
//
//

import Foundation
import CoreData


extension LotteryResultMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotteryResultMO> {
        return NSFetchRequest<LotteryResultMO>(entityName: "LotteryResult")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var entry: LotteryEntryMO?
    @NSManaged public var lottery: LotteryMO?

}

extension LotteryResultMO : Identifiable {

}
