//
//  Comment.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/2/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation


class Commnet{
    var nameOfAuthor: String!
    var text: String!
    var score: Double!
    var key: String!
    
    init() {
        
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>){
        self.key = key
        
        if let score =  dictionary["score"] as? Double{
            self.score = score
        }
        
        if let nameOfAuthor =  dictionary["nameOfAuthor"] as? String{
            self.nameOfAuthor = nameOfAuthor
        }
        if let text =  dictionary["text"] as? String{
            self.text = text
        }
    }
}
