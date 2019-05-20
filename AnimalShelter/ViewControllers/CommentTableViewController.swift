//
//  CommentTableViewController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/4/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {
    
    var shelterId: String!
    var comments: CommnetModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let height: CGFloat = 20 //whatever height you want to add to the existing height
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
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @objc func tapAddButton(){
        let popOverUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpId") as! PopUpViewController
        self.addChildViewController(popOverUpVC)
        popOverUpVC.view.frame = self.view.frame
        self.view.addSubview(popOverUpVC.view)
        popOverUpVC.didMove(toParentViewController: self)
    }

}
