//
//  PetTableViewController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/25/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import Firebase
class PetTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
    
    var petmodel: PetModel = PetModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tableView.register(UINib(nibName: "PetTableViewCell", bundle: nil), forCellReuseIdentifier: "animalCell")
        petmodel.loadPets {
           self.tableView.reloadData()
        }
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
//        self.navigationItem.searchController = search
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return petmodel.pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! PetTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
       
        let pet = petmodel.pets[indexPath.row]
        cell.photoURL = pet.photo
        cell.breedLabel.text = pet.breed
        cell.specieLabel.text = pet.specie
        cell.nameLabel.text = pet.nickname
        cell.updateImage()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToPetInfo", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToPetInfo") {
            let vc = segue.destination as! PetProfileTableViewController
            vc.pet = petmodel.pets[(sender as! IndexPath).row]
            
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffset - currentOffset < 40 {
            petmodel.loadPets {
                self.tableView.reloadData()
            }
//            self.tableView.reloadData()
        }
    }
    
  
}
