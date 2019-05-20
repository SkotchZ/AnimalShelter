//
//  PetCoreData+CoreDataProperties.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/14/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//
//

import Foundation
import CoreData


extension PetCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetCoreData> {
        return NSFetchRequest<PetCoreData>(entityName: "PetCoreData")
    }

    @NSManaged public var age: String?
    @NSManaged public var nickname: String?
    @NSManaged public var breed: String?
    @NSManaged public var spicie: String?
    @NSManaged public var key: String?
    @NSManaged public var shelterPhone: String?
    @NSManaged public var shelterMail: String?
    @NSManaged public var shelterName: String?

}
