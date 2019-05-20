//
//  ShelterTableViewController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/25/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class ShelterTableViewController: UITableViewController, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
    
    var sheltermodel: ModelShelter = ModelShelter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tableView.register(UINib(nibName: "ShelterTableViewCell", bundle: nil), forCellReuseIdentifier: "ShelterCell")
        sheltermodel.loadShelters {
            self.tableView.reloadData()
        }
        
        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self
//        self.navigationItem.searchController = search
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let height: CGFloat = 50 //whatever height you want to add to the existing height
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
//        
//    }
    
    
    
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
        return sheltermodel.shelters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterCell", for: indexPath) as! ShelterTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        let shelter = sheltermodel.shelters[indexPath.row]
        cell.descrition.text = shelter.phone
        cell.title.text = shelter.name
        cell.logoURL = shelter.logoUrl
        cell.updateImage()
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToShelterProfile", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToShelterProfile") {
            let vc = segue.destination as! ShelterProfileTableViewController
            vc.shelter = sheltermodel.shelters[(sender as! IndexPath).row]
            
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maxOffset - currentOffset < 40 {
            sheltermodel.loadShelters {
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    }
    
}

