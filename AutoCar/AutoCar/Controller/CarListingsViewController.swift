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
    var arrayCarDetails = [CarDetails]()

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
        carListingsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
                    
                    // Append the carListing object in the array
                    self.arrayCarDetails.append(carListing)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
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
        
        if let carDetails = self.arrayCarDetails[indexPath.row] as CarDetails?{
            
            // Assign values to the cell properties from the data model
            if let price = carDetails.carPrice{
                carListingCell.carPrice.text = "$ \(price)"
            }
            
            if let mileage = carDetails.carMileage{
                carListingCell.carMileage.text = "\(mileage) miles"
            }
            
            if let make = carDetails.carMake, let model = carDetails.carModel, let year = carDetails.carModelYear{
                carListingCell.carName.text = "\(make) \(model) \(year)"
            }
        
            if let condition = carDetails.carCondition{
                carListingCell.carCondition.text = "\(condition)"
            }
            
            if let phone = carDetails.dealer?.phone{
                carListingCell.dealerPhone.setTitle("📞 " + self.formattedPhoneNumber(number: phone), for: .normal)
                
                carListingCell.dealerPhone.tag = indexPath.row
                // Add action to perform when the button is tapped
                carListingCell.dealerPhone.addTarget(self, action: #selector(callDealerTapped(_:)), for: .touchUpInside)
            }
            
            if let url = carDetails.carThumbnail?.firstPhoto?.mediumPhoto {
                carListingCell.carImage.loadAsyncFrom(url: url, placeholder: nil)
            }
        }
    
        carListingCell.selectionStyle = .none
        
        
        return carListingCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCarDetails.count;
    }
    
// MARK: Helper Methods

    private func formattedPhoneNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX" // Phone number format in US
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    @objc func callDealerTapped(_ sender: UIButton){
         if let carDetails = self.arrayCarDetails[sender.tag] as CarDetails?, let phone = carDetails.dealer?.phone{
            guard let url = URL(string: "tel://\(phone)") else {
                return //be safe
            }
            // Open the Phone Dialer
            UIApplication.shared.open(url)
        }
    }
}


