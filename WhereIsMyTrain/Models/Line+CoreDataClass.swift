//
//  Line+CoreDataClass.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 05/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


public class Line: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(id: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Line", in: context)!
        
        super.init(entity: entity, insertInto: context)
        self.id = id
}
}
