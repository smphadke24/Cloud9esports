//
//  SignUpTableViewCell.swift
//  Cloud9 esports
//
//  Created by Soham Phadke on 3/6/21.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var main: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        main.layer.cornerRadius = 15
        imgView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            contentView.backgroundColor = UIColor(named: "Selected Background")
        } else {
            contentView.backgroundColor = UIColor(named: "Semi")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
}
