//
//  Station+CoreDataClass.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 05/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import CoreLocation


public class Station: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(json: JSON) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Station", in: context)!
        
        super.init(entity: entity, insertInto: context)
        self.name = json["name"].stringValue
        self.address = json["address"].stringValue
        self.lat = json["position"]["lat"].doubleValue
        self.long = json["position"]["long"].doubleValue
        // get each lines station and create a new Line from it
        let linesArray = json["lines"].arrayValue.map { $0.stringValue }
        
        // A Station could have the same Lines so we'll check it before adding to core data :
        linesArray.forEach {
            let request: NSFetchRequest<Line> = Line.fetchRequest()
            let idToFetch = $0
            request.predicate = NSPredicate(format: "id == %@", idToFetch)
            do {
                let results: [Line] = try context.fetch(request)
                if results.count > 0 {
                    if let newLine = results.first {
                        self.addToLine(newLine)
                    }
                }
                else {
                    let newLine = Line(id: $0)
                    self.addToLine(newLine)
                }
            }
            catch {
                print ("Error fetching")
            }
        }
        
        self.distanceToUser = 0.0
    }
    
    func setDistanceToUser (userPosition : CLLocation) {
        let position = CLLocation(latitude: self.lat, longitude: self.long)
        self.distanceToUser = position.distance(from: userPosition)
    }
    
}
