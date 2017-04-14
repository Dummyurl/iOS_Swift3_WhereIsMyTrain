//
//  Schedule.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 10/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Schedule {
    var message: String
    var destination: String
    
    init(json: JSON) {
        self.message = json["message"].stringValue
        self.destination = json["destination"].stringValue
    }
}
