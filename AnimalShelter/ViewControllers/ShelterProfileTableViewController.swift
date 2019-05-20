//
//  ShelterProfileTableViewController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/2/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
class ShelterProfileTableViewController: UITableViewController {
    
    var shelter: Shelter!
    var petId: String?
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
     var dataProvider: DataProvider! = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteButton.titleLabel?.textAlignment = .right
        phoneButton.titleLabel?.textAlignment = .right
        phoneButton.titleLabel?.textAlignment = .right
        if petId == nil{
            
            titleLable.text = shelter.name
            phoneButton.setTitle(shelter.phone, for: .normal)
            mailButton.setTitle(shelter.email, for: .normal)
            websiteButton.setTitle(shelter.website, for: .normal)
            updateImage()
            get_rating()
        }
        else
        {
            findShelterByPet {
                self.titleLable.text = self.shelter.name
                self.phoneButton.setTitle(self.shelter.phone, for: .normal)
                self.mailButton.setTitle(self.shelter.email, for: .normal)
                self.websiteButton.setTitle(self.shelter.website, for: .normal)
                self.updateImage()
                self.get_rating()
            }
        }
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let height: CGFloat = 20 //whatever height you want to add to the existing height
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
//        
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "ToComments", sender: indexPath)
            }
            else{
                self.performSegue(withIdentifier: "FromShelterToPets", sender: indexPath)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToComments") {
            let vc = segue.destination as! CommentTableViewController
            vc.shelterId = shelter.key
        }
        if (segue.identifier == "FromShelterToPets") {
            let vc = segue.destination as! PetTableViewController
            vc.petmodel.shelterId = shelter.key
        }
    }
  
    @IBAction func phoneCall(_ sender: Any) {
        guard let number = phoneButton.titleLabel?.text, let url = URL(string: "telprompt://\(number)") else {
            return
        }
        UIApplication.shared.open(url, options:[:], completionHandler: nil)
    }
    
    @IBAction func emailAction(_ sender: Any) {
        guard let mail = mailButton.titleLabel?.text, let url = URL(string: "mailto:\(mail)") else {
            return
        }
        UIApplication.shared.open(url, options:[:], completionHandler: nil)
    }
    
    @IBAction func websiteAction(_ sender: Any) {
        guard let siteURL = websiteButton.titleLabel?.text, let url = URL(string: "https://\(siteURL)") else {
            return
        }
        UIApplication.shared.open(url, options:[:], completionHandler: nil)
    }
    
    func findShelterByPet(complition: @escaping  () -> ()){
        Database.database().reference().child("PetShelter").queryOrdered(byChild: "PetId").queryEqual(toValue: Int(petId!)).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            if snapshot.childrenCount == 1{
                let temp = snapshot.children.allObjects as!  [DataSnapshot]
                let item = temp[0].value as! Dictionary<String, AnyObject?>
                let petShelter = PetShelter(key: temp[0].key, dictionary: item as Dictionary<String, AnyObject>)
                Database.database().reference().child("Shelters").child(petShelter.ShelterId).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                    self.shelter = Shelter(key: petShelter.ShelterId, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
                    complition()
                })
            }
        }
    }
    func updateImage(){
        if self.shelter != nil{
            self.dataProvider.dowloadImage(url: URL(string: (self.shelter.photoUrl)!)!, complition: { (image) in
                self.image.image = image
            })}
        else{
            image.backgroundColor = UIColor.black
        }
    }
    func get_rating(){
        Database.database().reference().child("Comments").queryOrdered(byChild: "shelterId").queryEqual(toValue: Int(shelter.key)).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            let count = snapshot.childrenCount
            var sum:Double = 0
            if snapshot.childrenCount > 0{
                for s in snapshot.children.allObjects as!  [DataSnapshot] {
                    let item = s.value as! Dictionary<String, AnyObject?>
                    let curCommnet = Commnet(key: s.key, dictionary: item as Dictionary<String, AnyObject>)
                    sum += curCommnet.score
                }
                self.ratingStars.rating = sum / Double(count)
            }
        }
    }
}
