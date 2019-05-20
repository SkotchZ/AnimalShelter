//
//  ShelterModel.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/26/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import UIKit
class Shelter{
    var key: String!
    var logoUrl: String?
    var photoUrl: String?
    var name: String!
    var phone: String!
    var email: String!
    var website: String!
    var rating: Int?
    
    init(name: String, phone: String, email: String, website: String) {
        self.name = name
        self.email = email
        self.website = website
        self.phone = phone
    }

    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self.key = key
        
        if let phone =  dictionary["phone"] as? Int64{
            self.phone = String(phone)
        }
        if let email =  dictionary["email"] as? String{
            self.email = email
        }
        if let website =  dictionary["website"] as? String{
            self.website = website
        }
        if let name =  dictionary["name"] as? String{
            self.name = name
        }
        if let logo =  dictionary["logo"] as? String{
            self.logoUrl = logo
        }
        if let photoUrl =  dictionary["photo"] as? String{
            self.photoUrl = photoUrl
        }
    }
}
