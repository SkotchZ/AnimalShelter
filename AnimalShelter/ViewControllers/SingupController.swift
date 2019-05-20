//
//  SingupController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/20/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class SignupController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateAccount(_ sender: Any) {
        let pass1 = passwordFiled.text!
        let pass2 = passwordFiled.text!
        let mail = emailField.text!
        let uname = usernameField.text!
        
        if (!pass1.isEmpty && !pass2.isEmpty && !mail.isEmpty && pass1==pass2){
            Auth.auth().createUser(withEmail: mail, password: pass1) { (result, error) in
                if error == nil{
                    if let result = result{
                        print(result.user.uid)
                        let ref = Database.database().reference().child("user")
                        ref.child(result.user.uid).updateChildValues(["email":mail, "uname":uname])
                    }
                }
            }
        }else
        {
            showAllert()
        }
        
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAllert(){
        let alert = UIAlertController(title: "Error", message: "fill al fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
