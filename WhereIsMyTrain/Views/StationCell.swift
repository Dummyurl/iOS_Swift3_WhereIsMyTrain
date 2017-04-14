//
//  StationCell.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 06/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordonatesLabel: UILabel!
    
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var line2: UIImageView!
    @IBOutlet weak var line3: UIImageView!
    @IBOutlet weak var line4: UIImageView!
    @IBOutlet weak var line5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
