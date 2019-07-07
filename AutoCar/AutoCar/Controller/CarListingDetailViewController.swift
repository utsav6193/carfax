//
//  CarListingDetailViewController.swift
//  AutoCar
//
//  Created by Utsav Parikh on 7/5/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CarListingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var carDetailsTableView : UITableView!
    
    let carDetailCellIdentifier = "CarDetailCell"
    var carDetails:CarDetails?
    var carListing = CarListing.sharedInstance
    
    let headerViewBottomPadding = 100
    let tableFooterHeight = 400
    
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
            carListing.add(myTitle: "Transmission:", myDescription: transmission)
        }
        
        if let mileage = carDetails?.carMileage {
            carListing.add(myTitle: "Mileage:" , myDescription:  "\(mileage) miles")
        }
        
        if let price = carDetails?.carPrice {
            carListing.add(myTitle: "Price:", myDescription: "$ \(price)")
        }
        
        if let exteriorColor = carDetails?.carExteriorColor {
            carListing.add(myTitle: "Exterior:", myDescription: exteriorColor)
        }
        
        if let interiorColor = carDetails?.carInteriorColor {
            carListing.add(myTitle: "Interior:", myDescription: interiorColor)
        }
        
        if let isCertified = carDetails?.isCertified {
            carListing.add(myTitle: "Certified:", myDescription: isCertified ? "Yes" : "No")
        }
        
        if let dealerName = carDetails?.dealer?.name {
            carListing.add(myTitle: "Dealer:", myDescription: dealerName)
        }
        
        if let address = carDetails?.dealer?.address, let city = carDetails?.dealer?.city,
           let state = carDetails?.dealer?.state, let zip = carDetails?.dealer?.zip
        {
            let dealerAddress = "\(address)\n\(city)\n\(state) \(zip)"
            carListing.add(myTitle: "Address:", myDescription: dealerAddress)
        }
        
        if let rating = carDetails?.dealer?.rating {
            carListing.add(myTitle: "Dealer Rating:", myDescription: "\(rating) ⭐")
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
            headerView.loadAsyncFrom(url: url, placeholder: UIImage(named: "placeholder"))
            headerView.contentMode = .scaleAspectFit
            let newSize = headerView.systemLayoutSizeFitting(CGSize(width: self.view.bounds.width, height: 0))
            headerView.frame.size.height = newSize.height + CGFloat(headerViewBottomPadding)
            self.carDetailsTableView.tableHeaderView = headerView
        }
        
        if let latitude = carDetails?.dealer?.latitude,  let longitude = carDetails?.dealer?.longitude{
            let coordinates = CLLocation(latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue)
            
            // Add Footer View to table
            let footerView = UIView()
            footerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: CGFloat(tableFooterHeight))

            // Add MapView to the table footer view
            let mapView = MKMapView()
            mapView.mapType = .standard
            mapView.frame = CGRect(x: 0, y: 20, width: footerView.bounds.width, height: footerView.bounds.height - 40)
            
            // Display the coordinates in the mapView using annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(coordinates.coordinate.latitude, coordinates.coordinate.longitude);
            mapView.addAnnotation(annotation);
            mapView.showAnnotations(mapView.annotations, animated: true)

            footerView.addSubview(mapView)
            self.carDetailsTableView.tableFooterView = footerView
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
        carDetailCell.detailDescription.text = carListing.arrayListing[indexPath.row].description
        carDetailCell.detailDescription.numberOfLines = 0
        
        // Set tableview cell selection style
        carDetailCell.selectionStyle = .none

        return carDetailCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carListing.arrayListing.count;
    }
}


