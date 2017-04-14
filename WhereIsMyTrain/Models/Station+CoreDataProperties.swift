//
//  Station+CoreDataProperties.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 05/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station");
    }

    @NSManaged public var address: String
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String
    @NSManaged public var distanceToUser: Double
    @NSManaged public var line: NSSet?

}

// MARK: Generated accessors for line
extension Station {

    @objc(addLineObject:)
    @NSManaged public func addToLine(_ value: Line)

    @objc(removeLineObject:)
    @NSManaged public func removeFromLine(_ value: Line)

    @objc(addLine:)
    @NSManaged public func addToLine(_ values: NSSet)

    @objc(removeLine:)
    @NSManaged public func removeFromLine(_ values: NSSet)

}
