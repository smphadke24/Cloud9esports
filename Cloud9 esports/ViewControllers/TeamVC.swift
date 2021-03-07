//
//  TeamVC.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/7/21.
//

import Foundation
import UIKit
import FirebaseFirestore

class TeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var teamTitle: String = "Name"
    var members: [(name: String, game: String)] = []
    var game: String = "Game"
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        teamLabel.text = teamTitle
        tableView.register(UINib(nibName: "MembersTableViewCell", bundle: nil), forCellReuseIdentifier: "reusableMemberCell")
        tableView.rowHeight = 50
        tableView.reloadData()
        print(members)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        var mems: [String] = []
        for cell in tableView.visibleCells {
            let myCell = cell as! MembersTableViewCell
            if myCell.status.tintColor == UIColor.systemGreen {
                mems.append(myCell.name.text!)
            }
        }
        db.collection("teams").document(teamTitle).setData(["members": mems], merge: true) { (err) in
            if let e = err {
                print("Error saving member team data")
            } else {
                print("Save Successful!")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableMemberCell") as! MembersTableViewCell
        cell.name.text = members[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MembersTableViewCell
        cell.status.image = UIImage(systemName: "checkmark.circle.fill")
        cell.status.tintColor = UIColor.systemGreen
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MembersTableViewCell
        cell.status.image = UIImage(systemName: "x.circle.fill")
        cell.status.tintColor = UIColor.systemRed
    }
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
}
