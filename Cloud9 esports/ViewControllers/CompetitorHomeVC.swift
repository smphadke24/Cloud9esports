//
//  CompetitorHomeVC.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/6/21.
//

import Foundation
import UIKit

class CompetitorHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selected: Int?
    
    let gameKey = ["Valorant": ("Val Rookie Cup", "Riot ID"), "Rocket League": ("RL Rocket Cup", "Rocket ID"), "Fortnite": ("Fortnite Cup", "Epic ID"), "Overwatch": ("OW Spring Skirmish", "Overwatch ID")]
    
    var gameListings = [(title: "Valorant", desc: "Sign up for the Rookie Cup today!", date: "Due March 24"), (title: "Fortnite", desc: "Sign up for the Summer Cup today!", date: "Due April 4"), (title: "Rocket League", desc: "Sign up for the Rocket Cup today!", date: "Due March 15"), (title: "Overwatch", desc: "Sign up for the Spring Skirmish today!", date: "Due March 28")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SignUpTableViewCell", bundle: nil), forCellReuseIdentifier: "reusableGameCell")
        self.navigationController?.navigationItem.hidesBackButton = true
        tableView.rowHeight = 174
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameListings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableGameCell") as! SignUpTableViewCell
        
        cell.desc.text = gameListings[indexPath.row].desc
        cell.date.text = gameListings[indexPath.row].date
        cell.imgView.image = UIImage(named: gameListings[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        selected = indexPath.row
        self.performSegue(withIdentifier: "signUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp" {
            let dest = segue.destination as! SurveyVC
            dest.titleTourney = gameKey[gameListings[selected!].title]!.0
            dest.idDesc = gameKey[gameListings[selected!].title]!.1
        }
    }
}
