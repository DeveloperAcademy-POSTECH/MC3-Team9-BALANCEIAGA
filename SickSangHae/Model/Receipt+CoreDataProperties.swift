//
//  Receipt+CoreDataProperties.swift
//  SickSangHae
//
//  Created by user on 2023/07/13.
//
//

import CoreData
import Foundation


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var state: Int16
    @NSManaged public var price: Double
    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var icon: String
    @NSManaged public var fastEatPin: Bool
    @NSManaged public var dateOfPurchase: Date
    @NSManaged public var placeOfPurchase: String?

    var status: Status {
        get {
            return Status(rawValue: self.state) ?? .UnConsumed
        }
        set {
            self.state = newValue.rawValue
        }
    }
}

extension Receipt : Identifiable {

}
