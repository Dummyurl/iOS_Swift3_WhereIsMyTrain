//
//  NetworkManager.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 04/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Singleton pour l'appel réseau

typealias ServiceResponse = ((JSON?, Error?) -> Void)

class NetworkManager {
    
    //MARK: - CONSTANTES
    let endPoint = "https://api-ratp.pierre-grimaud.fr/v3/"
    let types = "metros/"
    let schedules = "schedules/"
    let traffic = "traffic"
    let direction = (aller: "/A", retour: "/R")
    
    
    // -----
    static let sharedInstance = NetworkManager()
    fileprivate init() {}
    
    //MARK: - FONCTIONS
    
    // Get the schedules informations
    func getSchedulesInfos(line: String, slug: String, direction: String, completion: @escaping ServiceResponse) {
      
        let queryDirection : String
        
        if direction == "A" {
            queryDirection = self.direction.aller
        } else {
            queryDirection = self.direction.retour
        }
        
      let url = endPoint+schedules+types+line+"/"+slug+queryDirection
        let escapedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(escapedURL)
        
        Alamofire.request(escapedURL!, method: .get).validate().responseJSON() { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("DATA \(json)")
                    completion(json, nil)
                }
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    // Get the traffic informations
    func getTrafficInfos(line: String, completion: @escaping ServiceResponse) {
        
        let url = endPoint+traffic+types+line
        Alamofire.request(url, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("DATA \(json)")
                    completion(json, nil)
                }
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
}
