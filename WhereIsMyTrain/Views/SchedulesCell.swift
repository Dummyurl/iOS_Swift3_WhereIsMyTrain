//
//  SchedulesCell.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 10/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class SchedulesCell: UITableViewCell {

    @IBOutlet weak var stationImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
