//
//  CarListingsViewController.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/29/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import UIKit

class CarListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carListingsTableView : UITableView!
    
    let carListingCellIdentifier = "CarListingCell"
    var arrContacts = [CarDetails]()

    // MARK: - URL
    private var carListingsUrl = "https://carfax-for-consumers.firebaseio.com/assignment.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch car listings by calling API
        getCarListings()
    }
    
    func setupTableView() {
        carListingsTableView.delegate = self
        carListingsTableView.dataSource = self
        self.carListingsTableView.reloadData()
    }
    
// MARK: - Networking
    
    func getCarListings(){
        
        weak var weakSelf = self
        
        NetworkManager.shared.fetchCarListings(carListingsUrl, success: { (responseObject) in
            for aContact in responseObject["listings"] as! [Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: aContact, options: .prettyPrinted)
                    let listingString = String(data: jsonData, encoding: .utf8)
                    let listingData = listingString?.data(using: .utf8)
                    
                    // Decode the JSON data and feed it to the data model
                    let jsonDecoder = JSONDecoder()
                    let carListing = try jsonDecoder.decode(CarDetails.self, from: listingData!)
                    self.arrContacts.append(carListing)
                }
                catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            // As we have the data in the array now, set table delegates and reload the tableview
            weakSelf?.setupTableView()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
// MARK: TableView Delegate and Datasource Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carListingCell = tableView.dequeueReusableCell(withIdentifier: carListingCellIdentifier) as! CarListingCell
        let carDetails = self.arrContacts[indexPath.row] as CarDetails
    
        // TO DO:
        // Assign values to the cell properties from the data model
        
        return carListingCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrContacts.count;
    }
}

