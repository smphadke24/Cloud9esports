//
//  AdminHomeVC.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/7/21.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class AdminHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    var teams: [(name: String, game: String, members: [String])] = []
    var images: [String] = []
    var selected: Int?
    var members: [(name: String, game: String)] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TeamsTableViewCell", bundle: nil), forCellReuseIdentifier: "reusableTeamCell")
        tableView.rowHeight = 110
        
        db.collection("teams").getDocuments { [self] (qSnap, err) in
            if let e = err {
                print("Error getting team data from Firestore - \(e)")
            } else {
                if let docs = qSnap?.documents {
                    for doc in docs {
                        let myData = doc.data()
                        if let tName = doc.documentID as? String, let tGame = myData["game"] as? String, let members = ["members"] as? [String], let imageName = myData["image"] as? String {
                            self.teams.append((name: tName, game: tGame, members: members))
                            self.images.append(imageName)
                        }
                    }
                }
                self.tableView.reloadData()
                self.navigationController?.navigationItem.hidesBackButton = true
                db.collection("signUpData").getDocuments { [self] (qsnap, err) in
                    if let er = err {
                        print("ERROR")
                    } else {
                        for doc in qsnap!.documents {
                            let data = doc.data()
                            if let nameN = doc.documentID as? String, let gameN = data["tournament"] as? String {
                                members.append((name: nameN, game: gameN))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
//        do {
//            try FirebaseAuth.Auth.auth().signOut()
//
//        } catch (Error error) {
//            print("Unable to sign out - \(error)")
//            return
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableTeamCell") as! TeamsTableViewCell
        cell.name.text = teams[indexPath.row].name
        cell.imgView.image = UIImage(named: images[indexPath.row])
        //cell.memberCount.text = "\(teams[indexPath.row].members.count - 1)  Members"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selected = indexPath.row
        self.performSegue(withIdentifier: "goToTeam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTeam" {
            let dest = segue.destination as! TeamVC
            dest.members = members
            dest.teamTitle = teams[selected!].name
            dest.game = teams[selected!].game
        }
    }
}
