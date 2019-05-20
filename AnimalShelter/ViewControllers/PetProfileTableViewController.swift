//
//  PetProfileTableViewController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/2/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//
import Foundation
import UIKit
import Cosmos
import TinyConstraints
import Firebase
import CoreData
class PetProfileTableViewController: UITableViewController {
    
    var pet: Pet!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    
    @IBOutlet weak var descr: UITextView!
    var dataProvider: DataProvider! = DataProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        breedLabel.text = pet.breed
        ageLabel.text = pet.age
        nameLabel.text = pet.nickname
        specieLabel.text = pet.specie
        descr.text = pet.story
        updateImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 1{
                self.performSegue(withIdentifier: "FromPetToShelter", sender: indexPath)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FromPetToShelter") {
            let vc = segue.destination as! ShelterProfileTableViewController
            vc.petId = pet.key
        }
        
    }
    func findShelterByPet(complition: @escaping  (_ shelter:Shelter?) -> ()){
        Database.database().reference().child("PetShelter").queryOrdered(byChild: "PetId").queryEqual(toValue: Int(pet.key!)).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            if snapshot.childrenCount == 1{
                let temp = snapshot.children.allObjects as!  [DataSnapshot]
                let item = temp[0].value as! Dictionary<String, AnyObject?>
                let petShelter = PetShelter(key: temp[0].key, dictionary: item as Dictionary<String, AnyObject>)
                Database.database().reference().child("Shelters").child(petShelter.ShelterId).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                    let tempShelter = Shelter(key: petShelter.ShelterId, dictionary: snapshot.value as! Dictionary<String, AnyObject>)
                    complition(tempShelter)
                })
            }
        }
    }
    
    @IBAction func bookmark(_ sender: Any) {
        findShelterByPet { (shelter: Shelter?) in
            do {
                let fetchRequest: NSFetchRequest<PetCoreData> = PetCoreData.fetchRequest()
                let temp = try PersistentService.context.fetch(fetchRequest)
                if let found = temp.first( where: {$0.key == self.pet.key} ) {
                    let alert = UIAlertController(title: "Error", message: "This pet is already bookmarked", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
                else{
                    let tmp = PersistentService.context
                    let tempPet = PetCoreData(context: tmp)
                    tempPet.age = self.pet.age
                    tempPet.breed = self.pet.breed
                    tempPet.key = self.pet.key
                    tempPet.nickname = self.pet.nickname
                    tempPet.spicie = self.pet.specie
                    tempPet.shelterMail = shelter != nil ? shelter!.email : "not found"
                    tempPet.shelterName = shelter != nil ? shelter!.email : "not found"
                    tempPet.shelterPhone = shelter != nil ? shelter!.email : "not found"
                    PersistentService.saveContext()
                }
            } catch {}
        }
    }
    
    func updateImage(){
        if self.pet != nil{
            self.dataProvider.dowloadImage(url: URL(string: (self.pet.photo)!)!, complition: { (image) in
                self.img.image = image
            })}
        else{
            img.backgroundColor = UIColor.black
        }
    }
    
    
    
}
