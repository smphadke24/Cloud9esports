//
//  AdminLoginVC.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/6/21.
//

import Foundation
import UIKit
import FirebaseAuth

class AdminLoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        email.becomeFirstResponder()
        email.delegate = self
        password.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        login()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            password.becomeFirstResponder()
        } else {
            login()
        }
        return true
    }
    
    func login() {
        if let em = email.text, let pass = password.text {
            Auth.auth().signIn(withEmail: em, password: pass) { (result, err) in
                if let e = err {
                    print("error signing in -\(e)")
                    return
                }
                print("Successfully signed in \(em)!")
                self.performSegue(withIdentifier: "signIn", sender: self)
            }
        }
    }
}
