//
//  PetShelter.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/7/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation

class PetShelter{
    var PetId: String!
    var ShelterId: String!
    var key: String!
    
       
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self.key = key
        if let PetId =  dictionary["PetId"] as? Int64{
            self.PetId = String(PetId)
        }
        if let ShelterId =  dictionary["ShelterId"] as? Int64{
            self.ShelterId = String(ShelterId)
        }
       

    }
}
