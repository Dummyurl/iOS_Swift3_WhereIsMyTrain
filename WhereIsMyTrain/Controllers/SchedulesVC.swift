//
//  SchedulesVC.swift
//  WhereIsMyTrain
//
//  Created by etudiant-06 on 07/04/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import SwiftyJSON

class SchedulesVC: UIViewController {
    
    // MARK: - CONSTANTS & VARIABLES
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var station = Station()
    var slug = String()
    var direction = "A"
    var schedules = [Schedule]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var linesAvailableForThisStation = [String]()
    var lineNumberTapped = String()
    var lineButtonImageTapped = UIImage()
    
    
    
    // MARK: - VIEWS'FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.slug = station.name.lowercased().replacingOccurrences(of: " ", with: "+")
        self.navigationItem.title = station.name
        
        let linesForThisStation = station.line!.allObjects as! [Line]
        let numberOfLines = linesForThisStation.count
        
        // Adding the lines into an Array
        for line in linesForThisStation {
            self.linesAvailableForThisStation.append(line.id)
        }
        
        if numberOfLines > 1 {
            messageLabel.isHidden = false
            
            switch numberOfLines {
            case 5:
                button5.isHidden = false
                button5.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[4])"), for: .normal)
                button4.isHidden = false
                button4.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[3])"), for: .normal)
                button3.isHidden = false
                button3.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[2])"), for: .normal)
                button2.isHidden = false
                button2.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[1])"), for: .normal)
                button1.isHidden = false
                button1.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[0])"), for: .normal)
            case 4:
                button5.isHidden = true
                button4.isHidden = false
                button4.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[3])"), for: .normal)
                button3.isHidden = false
                button3.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[2])"), for: .normal)
                button2.isHidden = false
                button2.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[1])"), for: .normal)
                button1.isHidden = false
                button1.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[0])"), for: .normal)
            case 3:
                button5.isHidden = true
                button4.isHidden = true
                button3.isHidden = false
                button3.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[2])"), for: .normal)
                button2.isHidden = false
                button2.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[1])"), for: .normal)
                button1.isHidden = false
                button1.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[0])"), for: .normal)
            case 2:
                button5.isHidden = true
                button4.isHidden = true
                button3.isHidden = true
                button2.isHidden = false
                button2.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[1])"), for: .normal)
                button1.isHidden = false
                button1.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[0])"), for: .normal)
            case 1 :
                button5.isHidden = true
                button4.isHidden = true
                button3.isHidden = true
                button2.isHidden = true
                button1.isHidden = false
                button1.setImage(UIImage(named: "M_"+"\(linesAvailableForThisStation[0])"), for: .normal)
            default :
                button5.isHidden = true
                button4.isHidden = true
                button3.isHidden = true
                button2.isHidden = true
                button1.isHidden = true
            }
            
        } else {
            
            button5.isHidden = true
            button4.isHidden = true
            button3.isHidden = true
            button2.isHidden = true
            button1.isHidden = true
            messageLabel.isHidden = true
            
        }
        
        // Network Request
        NetworkManager.sharedInstance.getSchedulesInfos(line: linesForThisStation[0].id, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error when getting schedlues infos")
                return
            }
            if let json = json {
                let jsonArray = json["result"]["schedules"].arrayValue
                //Cleaning actual schedules Array
                self.schedules.removeAll()
                
                for element in jsonArray {
                    let currentElement = Schedule(json: element)
                    
                    self.schedules.append(currentElement)
                }
                self.lineButtonImageTapped = UIImage(named: "M_" + linesForThisStation[0].id)!
            }
        }
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender:  UIButton!) {
        
        switch sender.tag {
        case 5:
            self.lineNumberTapped = self.linesAvailableForThisStation[4]
        case 4:
            self.lineNumberTapped = self.linesAvailableForThisStation[3]
        case 3:
            self.lineNumberTapped = self.linesAvailableForThisStation[2]
        case 2:
            self.lineNumberTapped = self.linesAvailableForThisStation[1]
        case 1:
            self.lineNumberTapped = self.linesAvailableForThisStation[0]
        default:
            break
        }
        
        // Network Request
        NetworkManager.sharedInstance.getSchedulesInfos(line: lineNumberTapped, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
            guard error == nil else {
                print("error when getting schedlues infos")
                return
            }
            if let json = json {
                let jsonArray = json["result"]["schedules"].arrayValue
                //Cleaning actual schedules Array
                self.schedules.removeAll()
                
                for element in jsonArray {
                    let currentElement = Schedule(json: element)
                    
                    self.schedules.append(currentElement)
                }
                self.lineButtonImageTapped = (sender.imageView?.image)!
            }
        }
    }
    
    //TODO: - Revoir le fait qu'il y ai une ou plusieurs stations au chargement de la vue (bouton retour Ko si pas d'appuie sur le boutton)
    @IBAction func controlChanged(_ sender: UISegmentedControl) {
        if linesAvailableForThisStation.count == 1 {
            self.lineNumberTapped = self.linesAvailableForThisStation[0]
            
            if segmentedControl.selectedSegmentIndex == 0 {
                self.direction = "A"
                // Network Request
                NetworkManager.sharedInstance.getSchedulesInfos(line: lineNumberTapped, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
                    guard error == nil else {
                        print("error when getting schedlues infos")
                        return
                    }
                    if let json = json {
                        let jsonArray = json["result"]["schedules"].arrayValue
                        //Cleaning actual schedules Array
                        self.schedules.removeAll()
                        
                        for element in jsonArray {
                            let currentElement = Schedule(json: element)
                            
                            self.schedules.append(currentElement)
                        }
                        self.lineButtonImageTapped = UIImage(named: "M_" + self.lineNumberTapped)!                    }
                }
            } else {
                self.direction = "R"
                // Network Request
                NetworkManager.sharedInstance.getSchedulesInfos(line: lineNumberTapped, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
                    guard error == nil else {
                        print("error when getting schedlues infos")
                        return
                    }
                    if let json = json {
                        let jsonArray = json["result"]["schedules"].arrayValue
                        //Cleaning actual schedules Array
                        self.schedules.removeAll()
                        
                        for element in jsonArray {
                            let currentElement = Schedule(json: element)
                            
                            self.schedules.append(currentElement)
                        }
                        self.lineButtonImageTapped = UIImage(named: "M_" + self.lineNumberTapped)!
                    }
                }
            }
            
        } else {
            if segmentedControl.selectedSegmentIndex == 1 {
                self.direction = "A"
                // Network Request
                NetworkManager.sharedInstance.getSchedulesInfos(line: lineNumberTapped, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
                    guard error == nil else {
                        print("error when getting schedlues infos")
                        return
                    }
                    if let json = json {
                        let jsonArray = json["result"]["schedules"].arrayValue
                        //Cleaning actual schedules Array
                        self.schedules.removeAll()
                        
                        for element in jsonArray {
                            let currentElement = Schedule(json: element)
                            
                            self.schedules.append(currentElement)
                        }
                        self.lineButtonImageTapped = UIImage(named: "M_" + self.lineNumberTapped)!
                    }
                }
            } else {
                self.direction = "R"
                // Network Request
                NetworkManager.sharedInstance.getSchedulesInfos(line: lineNumberTapped, slug: slug, direction: direction) { (json: JSON?, error: Error?) in
                    guard error == nil else {
                        print("error when getting schedlues infos")
                        return
                    }
                    if let json = json {
                        let jsonArray = json["result"]["schedules"].arrayValue
                        //Cleaning actual schedules Array
                        self.schedules.removeAll()
                        
                        for element in jsonArray {
                            let currentElement = Schedule(json: element)
                            
                            self.schedules.append(currentElement)
                        }
                        self.lineButtonImageTapped = UIImage(named: "M_" + self.lineNumberTapped)!
                    }
                }
            }
        }
    }
    
}
extension SchedulesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleToDisplay = schedules[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! SchedulesCell
        cell.stationImage.image = lineButtonImageTapped
        cell.timeLabel.text = "\(scheduleToDisplay.message)"
        cell.destinationLabel.text = "\(scheduleToDisplay.destination)"
        
        return cell
    }
}
