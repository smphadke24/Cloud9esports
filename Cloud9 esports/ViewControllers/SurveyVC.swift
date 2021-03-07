//
//  SurveyVC.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/6/21.
//

import Foundation
import UIKit
import FirebaseFirestore

class SurveyVC: UIViewController, UITextFieldDelegate {
    let db = Firestore.firestore()
    
    var titleTourney: String?
    var idDesc: String?
    
    let genderIndex = ["Male", "Female", "Other", "Prefer not to say"]
    let ageIndex = ["1-12", "13-17", "18-30", "30-50", "50+"]
    let termsIndex = ["Yes", "No"]
    
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var idText: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        name.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        nameLast.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        discord.attributedPlaceholder = NSAttributedString(string: "username#XXXX", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        id.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Placeholder")!])
        name.delegate = self
        nameLast.delegate = self
        discord.delegate = self
        id.delegate = self
        top.text = titleTourney ?? "No title"
        idText.text = idDesc ?? "Generic ID"
        signUpButton.layer.cornerRadius = 15
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if name.text == "" || nameLast.text == "" || discord.text == "" || id.text == "" || termsControl.selectedSegmentIndex == 1 {
            return
        }
        let data = ["first": name.text!, "last": nameLast.text!, "discord": discord.text!, "id": id.text!, "gender": genderIndex[genderControl.selectedSegmentIndex], "age": ageIndex[ageControl.selectedSegmentIndex], "terms": termsIndex[termsControl.selectedSegmentIndex], "tournament": titleTourney!]
        db.collection("signUpData").document(name.text! + "_" + nameLast.text!).setData(data) { (err) in
            if let e = err {
                print("Couldn't save survey data to Firestore - \(e)")
                return
            }
            print("Successfuly saved survey data to Firestore")
        }
        activateBot(data)
        self.dismiss(animated: true) {
            
        // TODO - ALERT FOR DISCORD BOT AND SUCCESS
            
           
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            nameLast.becomeFirstResponder()
        case 2:
            nameLast.resignFirstResponder()
        case 3:
            id.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nameLast: UITextField!
    @IBOutlet weak var discord: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var ageControl: UISegmentedControl!
    @IBOutlet weak var termsControl: UISegmentedControl!
    
    func activateBot(_ dat: [String: String]) {
        
        // prepare json data
        let json = dat as [String: Any]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://SegfaultBot.saamstep.repl.co/formSubmit")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                print("^ JSON response ^")
            }
            print("done with request")
        }
        task.resume()
    }
    
}
