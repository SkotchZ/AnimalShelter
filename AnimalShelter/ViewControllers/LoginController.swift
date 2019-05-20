//
//  LoginController.swift
//  AnimalShelter
//
//  Created by Игорь Скачков on 4/20/19.
//  Copyright © 2019 Игорь Скачков. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginTaped(_ sender: Any) {
        let mail = emailField.text!
        let pass = passwordField.text!
        if (!mail.isEmpty && !pass.isEmpty){
            Auth.auth().signIn(withEmail: mail, password: pass) { (result, error) in
                if error == nil{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else{
            showAllert()
        }
        
    }
    
    @IBAction func signUpTaped(_ sender: Any) {
        performSegue(withIdentifier: "ToSignUp", sender: self)
    }
    
    
    func showAllert(){
        let alert = UIAlertController(title: "Error", message: "fill all fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginController: UITextFieldDelegate{
    
}

//extension LoginController: FUIAuthDelegate{
//    func  authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        guard error == nil else{
//            return
//        }
//
//
//    }
//
//}
