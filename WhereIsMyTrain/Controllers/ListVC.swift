//
//  ListVC.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 06/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - CONSTANTS & VARIABLES
    
    // Core Data elements
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var listTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredStations = [Station]()
    
    var stations = [Station]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    
    // MARK: - Views' functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        listTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Rechercher une station"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFromCoreData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Other Functions
    
    // Filtered Search
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredStations = stations.filter {
            station in
            return station.name.lowercased().contains(searchText.lowercased())
        }
        listTableView.reloadData()
    }
    
    // Core Data Fetching
    func fetchFromCoreData() {
        do {
            // create the Dog request
            let request : NSFetchRequest<Station> = Station.fetchRequest()
            
            stations = try context.fetch( request )
            
        }
        catch  {
            print("An error occurs when fetching data : \(error)")
        }
    }
    
   
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredStations.count
        }
        
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell") as? StationCell {
            
            let station: Station
            
            if searchController.isActive && searchController.searchBar.text != "" {
                station = filteredStations[indexPath.row]
            }
            else {
                station = stations[indexPath.row]
            }
            
            // Configuring the cell
            cell.nameLabel.text = station.name.uppercased()
            cell.coordonatesLabel.text = "\(station.lat.toFormattedString(2)!), \(station.long.toFormattedString(2)!)"
            
            // Get the Line Number by casting the station & line relationship
            let lineNumbers = station.line!.allObjects as! [Line]
            let numberOfLines = lineNumbers.count
            
            var linesAvailableForThisStation = [String]()
            
            
            for line in lineNumbers {
                linesAvailableForThisStation.append(line.id)
            }
            
            switch numberOfLines {
            case 1:
                cell.line1.isHidden = false
                cell.line1.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[0])")
                print("M"+"\(linesAvailableForThisStation[0])")
                cell.line2.isHidden = true
                cell.line3.isHidden = true
                cell.line4.isHidden = true
                cell.line5.isHidden = true
                
            case 2:
                cell.line1.isHidden = false
                cell.line1.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[0])")
                cell.line2.isHidden = false
                cell.line2.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[1])")
                cell.line3.isHidden = true
                cell.line4.isHidden = true
                cell.line5.isHidden = true
                
            case 3:
                cell.line1.isHidden = false
                cell.line1.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[0])")
                cell.line2.isHidden = false
                cell.line2.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[1])")
                cell.line3.isHidden = false
                cell.line3.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[2])")
                cell.line4.isHidden = true
                cell.line5.isHidden = true
                
            case 4:
                cell.line1.isHidden = false
                cell.line1.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[0])")
                cell.line2.isHidden = false
                cell.line2.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[1])")
                cell.line3.isHidden = false
                cell.line3.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[2])")
                cell.line4.isHidden = false
                cell.line4.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[3])")
                cell.line5.isHidden = true
                
            case 5:
                cell.line1.isHidden = false
                cell.line1.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[0])")
                cell.line2.isHidden = false
                cell.line2.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[1])")
                cell.line3.isHidden = false
                cell.line3.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[2])")
                cell.line4.isHidden = false
                cell.line4.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[3])")
                cell.line5.isHidden = false
                cell.line5.image = UIImage(named: "M_"+"\(linesAvailableForThisStation[4])")
                
            default:
                break
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    // Segues
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSchedules", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSchedules" {
            if let destinationVC = segue.destination as? SchedulesVC {
                
                if let row = self.listTableView.indexPathForSelectedRow?.row {
                    if searchController.isActive && searchController.searchBar.text != "" {
                        let station = self.filteredStations[row]
                        destinationVC.station = station
                    }
                    else {
                        let station = self.stations[row]
                        destinationVC.station = station
                    }
                }
            }
        }
    }
    
}

// MARK: - EXTENSIONS

extension ListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
