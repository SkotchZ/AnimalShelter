//
//  CommentTableViewCell.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 5/15/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateImage()
        // Initialization code
    }
    var dataProvider: DataProvider! = DataProvider()
    var photoURL: String?
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
