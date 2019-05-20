//
//  ProfileController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/21/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreData
class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    
    var pets = [PetCoreData]()
    var imgForUpload: UIImage!
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var userModel: UserModel? = UserModel()
    var picker = UIImagePickerController()
    var dataProvider: DataProvider! = DataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.cornerRadius = img.frame.size.width / 2
        
        
            
        picker.delegate = self
        picker.allowsEditing = true
        userModel?.loadUser {
            self.emailLabel.text = self.userModel?.user.email
            self.userLabel.text = self.userModel?.user.name
            self.dataProvider.dowloadImage(url: URL(string: (self.userModel?.user?.photoURL)!)!, complition: { (image) in
                self.img.image = image
            })
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        do {
            let fetchRequest: NSFetchRequest<PetCoreData> = PetCoreData.fetchRequest()
            let temp = try PersistentService.context.fetch(fetchRequest)
            self.pets = temp
            tableView.reloadData()
        } catch {}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func LogOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
        }catch {
            print(error)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            img.image = editedImage
            uploadProfileImage(editedImage) { (url) in
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges(completion: { (error) in
                    if error == nil {
                        print("user image changed")
                        self.saveProfileChanges(profileImageUrl: url!)
                    }
                    else
                    {
                        print(error?.localizedDescription)
                    }
                })
            }
        }
         picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image: UIImage, complition: @escaping ((_ url:URL?)->())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let jpg = UIImageJPEGRepresentation(image, 0.7) else {return}
        let meta = StorageMetadata()
        meta.contentType = "image/jpg"
        storageRef.putData(jpg, metadata: meta) { (metaData, error) in
            if error == nil && metaData != nil{
                storageRef.downloadURL { url, error in
                    complition(url)
                    // success!
                }
            }
            else{
                complition(nil) //failed
            }
        }
    }
    
    func saveProfileChanges(profileImageUrl: URL){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("user/\(uid)").child("photoURL").setValue(profileImageUrl.absoluteString)
    }
    
    deinit {
        print("controller dissmised")
    }
    
    @IBAction func remindAction(_ sender: Any) {
        appDelegate?.scheduleNotication()
    }
    
    
}

extension ProfileController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = pets[indexPath.row].nickname
        cell.detailTextLabel?.text = pets[indexPath.row].spicie
        return cell
    }
}
