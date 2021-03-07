//
//  HomeViewController.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/6/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var admin: UIButton!
    @IBOutlet weak var competitor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        admin.layer.cornerRadius = 10
        competitor.layer.cornerRadius = 10
    }

    @IBAction func adminTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToAdmin", sender: self)
    }
    
    @IBAction func competitorPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToCompetitor", sender: self)
    }
}

