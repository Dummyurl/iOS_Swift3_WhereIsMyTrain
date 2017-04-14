//
//  Line+CoreDataProperties.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 05/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import CoreData


extension Line {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Line> {
        return NSFetchRequest<Line>(entityName: "Line");
    }

    @NSManaged public var id: String
    @NSManaged public var station: NSSet?

}

// MARK: Generated accessors for station
extension Line {

    @objc(addStationObject:)
    @NSManaged public func addToStation(_ value: Station)

    @objc(removeStationObject:)
    @NSManaged public func removeFromStation(_ value: Station)

    @objc(addStation:)
    @NSManaged public func addToStation(_ values: NSSet)

    @objc(removeStation:)
    @NSManaged public func removeFromStation(_ values: NSSet)

}
