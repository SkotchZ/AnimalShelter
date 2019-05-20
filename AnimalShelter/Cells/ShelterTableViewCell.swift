//
//  ShelterTableViewCell.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/1/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class ShelterTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descrition: UILabel!
    
    var logoURL: String?
    var dataProvider: DataProvider! = DataProvider()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateImage()
        img.layer.cornerRadius = img.frame.size.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateImage(){
        if self.logoURL != nil{
            self.dataProvider.dowloadImage(url: URL(string: (self.logoURL)!)!, complition: { (image) in
                self.img.image = image
            })}
        else{
            img.backgroundColor = UIColor.black
        }
    }
}
