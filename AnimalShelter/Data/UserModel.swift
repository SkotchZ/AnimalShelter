//
//  UserModel.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/10/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import Firebase
class UserModel{
    var user: User!

    init() {
        
    }
    
    func loadUser(complition: @escaping  () -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("user").child(uid).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            self.user = User(key: uid, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
            complition()
        })
    }
}
