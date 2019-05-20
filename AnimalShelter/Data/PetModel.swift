//
//  PetModel.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/4/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import Firebase
class PetModel{
    var petShelterModel: PetShelterModel? = PetShelterModel()
    var shelterId: String?
    
    var pets = [Pet]()
    var currentKey: String!
    
    init() {
        
    }
    
    func loadPets(complition: @escaping  () -> ()){
        if shelterId != nil {
            loadPetsFromShelter {
                complition()
            }
            return
        }
        if currentKey == nil {
            Database.database().reference().child("Pets").queryOrderedByKey().queryLimited(toFirst: 5).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                let last = snapshot.children.allObjects.last as! DataSnapshot
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        let item = s.value as! Dictionary<String, AnyObject?>
                        let pet = Pet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                        self.pets.append(pet)
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
        else{
            Database.database().reference().child("Pets").queryOrderedByKey().queryStarting(atValue: self.currentKey).queryLimited(toFirst: 6).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                let last = snapshot.children.allObjects.last as! DataSnapshot
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        if s.key != self.currentKey {
                            let item = s.value as! Dictionary<String, AnyObject?>
                            let pet = Pet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                            self.pets.append(pet)
                        }
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
    }
    
    func loadPetsFromShelter(complition: @escaping  () -> ()){
        petShelterModel?.shelterId = shelterId
        petShelterModel?.loadPetsShelters {
            for i in self.petShelterModel!.petshelters{
                if self.currentKey == nil {
                    Database.database().reference().child("Pets").child(i.PetId).queryOrderedByKey().queryLimited(toFirst: 5).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                            if snapshot.childrenCount > 0{
                                let pet = Pet(key: i.PetId, dictionary: snapshot.value as! Dictionary<String, AnyObject> )
                                self.pets.append(pet)
                                complition()
                        }
                    }
                }
                else{
                    Database.database().reference().child("Pet").child(i.PetId).queryOrderedByKey().queryStarting(atValue: self.currentKey).queryLimited(toFirst: 6).observeSingleEvent(of: .value) {
                        (snapshot: DataSnapshot) in
                            if snapshot.childrenCount > 0{
                                for s in snapshot.children.allObjects as!  [DataSnapshot] {
                                    if s.key != self.currentKey {
                                        let item = s.value as! Dictionary<String, AnyObject?>
                                        let pet = Pet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                                        self.pets.append(pet)
                                    }
                                }
                                complition()
                            }
                    }
                }
            }
        }
        
    }
}
