//
//  User.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/10/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation

class User{
    var name: String!
    var email: String!
    var photoURL: String!
    var key: String!
    
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self.key = key
        
        
        if let name =  dictionary["name"] as? String{
            self.name = name
        }
        if let email =  dictionary["email"] as? String{
            self.email = email
        }
        if let photoURL =  dictionary["photoURL"] as? String{
            self.photoURL = photoURL
        }
    }
}
