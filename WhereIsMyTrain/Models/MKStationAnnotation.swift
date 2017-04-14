//
//  MKStationAnnotation.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 12/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import MapKit

class MKStationAnnotation: NSObject, MKAnnotation {
    
    fileprivate var coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var pinColor: UIColor?
    var title: String?
    var subtitle: String?
    var station: Station?
    
    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
    
    func buildStationLocation(_ station: Station) {
        self.setCoordinate(CLLocationCoordinate2D(latitude: station.lat, longitude: station.long))
        self.title = station.name
        self.subtitle = station.address
        self.station = station
        self.pinColor = UIColor.blue
    }
    
}
