//
//  CarListingsViewController.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/29/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import UIKit

class CarListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var carListingsTableView : UITableView!
    
    let carListingCellIdentifier = "CarListingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        carListingsTableView.delegate = self
        carListingsTableView.dataSource = self
    }
    
// MARK: TableView Delegate and Datasource Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carListingCell = tableView.dequeueReusableCell(withIdentifier: carListingCellIdentifier) as! CarListingCell
        
        return carListingCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
}

