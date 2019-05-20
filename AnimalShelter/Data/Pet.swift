//
//  Pet.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/2/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation

class Pet{
    var nickname: String!
    var specie: String!
    var breed: String!
    var age: String!
    var story: String!
    var photo: String!
    var key: String!
    
    init(nickName: String) {
        self.nickname = nickName
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self.key = key
        
        if let age =  dictionary["age"] as? Int64{
            self.age = String(age)
        }
        if let breed =  dictionary["breed"] as? String{
            self.breed = breed
        }
        if let story =  dictionary["story"] as? String{
            self.story = story
        }
        if let specie =  dictionary["specie"] as? String{
            self.specie = specie
        }
        if let nickname =  dictionary["Nickname"] as? String{
            self.nickname = nickname
        }
        if let photo =  dictionary["photo"] as? String{
            self.photo = photo
        }
    }
    
    
}
