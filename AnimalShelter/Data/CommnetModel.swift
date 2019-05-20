//
//  CommnetModel.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/4/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//
import Foundation
import Firebase
class CommnetModel{
    
    var commnets = [Commnet]()
    var currentCommnet: Int!
    var currentKey: String!
    
    init() {
        
    }
    
    func loadCommnets(complition: @escaping  () -> ()){
        if currentKey == nil {
            Database.database().reference().child("Commnets").queryOrderedByKey().queryLimited(toFirst: 5).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                let last = snapshot.children.allObjects.last as! DataSnapshot
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        let item = s.value as! Dictionary<String, AnyObject?>
                        let comment = Commnet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                        self.commnets.append(comment)
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
        else{
            Database.database().reference().child("Commnets").queryOrderedByKey().queryStarting(atValue: self.currentKey).queryLimited(toFirst: 6).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                
                let last = snapshot.children.allObjects.last as! DataSnapshot
                let index = self.commnets.count
                if snapshot.childrenCount > 0{
                    for s in snapshot.children.allObjects as!  [DataSnapshot] {
                        if s.key != self.currentKey {
                            let item = s.value as! Dictionary<String, AnyObject?>
                            let comment = Commnet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                            self.commnets.append(comment)
                        }
                    }
                    self.currentKey = last.key
                    complition()
                }
            }
        }
    }
}
