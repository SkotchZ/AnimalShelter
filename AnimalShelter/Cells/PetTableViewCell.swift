//
//  PetTableViewCell.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/4/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    
    var photoURL: String?
    var dataProvider: DataProvider! = DataProvider()
    
    override func awakeFromNib() {
        updateImage()
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateImage(){
        if self.photoURL != nil{
            self.dataProvider.dowloadImage(url: URL(string: (self.photoURL)!)!, complition: { (image) in
                self.img.image = image
            })}
        else{
            img.backgroundColor = UIColor.black
        }
    }
}
