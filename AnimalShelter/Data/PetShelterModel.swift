//
//  PetShelterModel.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/7/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import Firebase
class PetShelterModel{
    var petshelters = [PetShelter]()
    var currentKey: String!
    var shelterId: String!
    init() {
        
    }
    
    func loadPetsShelters(complition: @escaping  () -> ()){
        if currentKey == nil {
            Database.database().reference().child("PetShelter").queryOrdered(byChild: "ShelterId").queryEqual(toValue: Int(shelterId)).queryLimited(toFirst: 5).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                let last = snapshot.children.allObjects.last as! DataSnapshot
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        let item = s.value as! Dictionary<String, AnyObject?>
                        let petShelter = PetShelter(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                        self.petshelters.append(petShelter)
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
        else{
            Database.database().reference().child("PetShelter").queryOrdered(byChild: "ShelterId").queryEqual(toValue: Int(shelterId)).queryStarting(atValue: self.currentKey).queryLimited(toFirst: 6).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                
                let last = snapshot.children.allObjects.last as! DataSnapshot
                let index = self.petshelters.count
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        if s.key != self.currentKey {
                            let item = s.value as! Dictionary<String, AnyObject?>
                            let petShelter = PetShelter(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                            self.petshelters.append(petShelter)
                        }
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
    }
    
    
}
