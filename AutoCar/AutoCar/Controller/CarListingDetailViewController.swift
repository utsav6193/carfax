//
//  CarListingDetailViewController.swift
//  AutoCar
//
//  Created by Utsav Parikh on 7/5/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import UIKit

class CarListingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carDetailsTableView : UITableView!
    
    let carDetailCellIdentifier = "CarDetailCell"
    var carDetails:CarDetails?
    var carListing = CarListing.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carListing.arrayListing.removeAll()
        
        if let make = carDetails?.carMake, let model = carDetails?.carModel, let year = carDetails?.carModelYear {
            let carName = "\(make) \(model) \(year)"
            self.title = carName
            carListing.add(myTitle: "Make:", myDescription: carName)
        }
        
        if let VIN = carDetails?.carVIN {
            carListing.add(myTitle: "VIN:", myDescription: VIN)
        }
        
        if let body = carDetails?.carBodyType {
            carListing.add(myTitle: "Body Type:", myDescription: body)
        }
        
        if let transmission = carDetails?.carTransmission {
            carListing.add(myTitle: "Transmission", myDescription: transmission)
        }
        
        if let mileage = carDetails?.carMileage {
            carListing.add(myTitle: "Mileage:" , myDescription:  "\(mileage) miles")
        }
        
        if let price = carDetails?.carPrice {
            carListing.add(myTitle: "Price:", myDescription: "$ \(price)")
        }
        
        if let exteriorColor = carDetails?.carExteriorColor {
            carListing.add(myTitle: "Exterior Color:", myDescription: exteriorColor)
        }
        
        if let interiorColor = carDetails?.carInteriorColor {
            carListing.add(myTitle: "Interior Color:", myDescription: interiorColor)
        }
        
        if let isCertified = carDetails?.isCertified {
            carListing.add(myTitle: "Certified:", myDescription: isCertified ? "Yes" : "No")
        }
        
        
        
        self.setupTableView()
    }
    
    func setupTableView() {
        // Assign delegate and datasource to table view
        self.carDetailsTableView.delegate = self
        self.carDetailsTableView.dataSource = self
        self.carDetailsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Set up table header view and load image
        if let url = carDetails?.carThumbnail?.firstPhoto?.mediumPhoto {
            let headerView = AsyncImageView()
            headerView.loadAsyncFrom(url: url, placeholder: nil)
            headerView.contentMode = .scaleAspectFit
            self.carDetailsTableView.tableHeaderView = headerView
        }
        
        // Reload Table View
        self.carDetailsTableView.reloadData()
    }
    
// MARK: TableView Delegate and Datasource Methods

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carDetailCell = tableView.dequeueReusableCell(withIdentifier: carDetailCellIdentifier) as! CarDetailCell

        carDetailCell.detailTitle.text = carListing.arrayListing[indexPath.row].title
        carDetailCell.detailDescription.text = carListing.arrayListing[indexPath.row].description as? String

        // Set tableview cell selection style
        carDetailCell.selectionStyle = .none

        return carDetailCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carListing.arrayListing.count;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        carDetailsTableView.updateHeaderViewHeight()
    }
}

extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let padding = 100.0
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height + CGFloat(padding)
        }
    }
}
