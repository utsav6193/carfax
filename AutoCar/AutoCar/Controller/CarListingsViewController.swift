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
    let segueToDetailViewIdentifier = "toDetailView"
    var arrayCarListings = [CarDetails?]()

    // Reachability manager checks continuously for internet connectivity
    let reachabilityManager = ReachabilityManager.sharedInstance
    
    // API Url
    private var carListingsUrl = "https://carfax-for-consumers.firebaseio.com/assignment.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

        // check if connected to internet
        self.checkForInternetConnection()
        
        // Assign navigation bar title
        self.title = NSLocalizedString("Used Cars", comment: "title for navigation bar")
        
        // Use weakSelf in blocks to avoid retain cycle
        weak var weakSelf = self
        
        reachabilityManager.isReachable { _ in
            // Fetch used car listings - calling API
            weakSelf?.getUsedCarListings()
        }
    }
    
    private func setupTableView() {
        // Assign delegate and datasource to table view
        self.carListingsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.carListingsTableView.tableFooterView = UIView(frame: .zero)
        self.carListingsTableView.reloadData()
    }
    
// MARK: - Internet Connectivity
    
    private func showOfflinePage() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toInternetUnavailable", sender: self)
        }
    }
    
    private func checkForInternetConnection() {
        // If the network is unreachable show the offline page
        reachabilityManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        reachabilityManager.reachability.whenUnreachable = { _ in
            self.showOfflinePage()
        }
    }
    
// MARK: - Networking
    
    private func getUsedCarListings(){
        
        // Use weakSelf in blocks to avoid retain cycle
        weak var weakSelf = self
        
        NetworkManager.shared.fetchCarListings(carListingsUrl, success: { (responseObject) in
            for myListing in responseObject["listings"] as! [Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: myListing, options: .prettyPrinted)
                    let listingString = String(data: jsonData, encoding: .utf8)
                    let listingData = listingString?.data(using: .utf8)
                    
                    // Decode the JSON data and feed it to the data model
                    let jsonDecoder = JSONDecoder()
                    let carListing = try jsonDecoder.decode(CarDetails.self, from: listingData!)
                    
                    // Append the carListing object in the array
                    self.arrayCarListings.append(carListing)
                    
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
        
        if let carDetails = self.arrayCarListings[indexPath.row] as CarDetails?{
            
            // Assign values to the cell properties from the data model
            if let price = carDetails.carPrice {
                carListingCell.carPrice.text = "$ \(price)"
            }
            
            if let mileage = carDetails.carMileage {
                carListingCell.carMileage.text = "\(mileage) miles"
            }
            
            if let make = carDetails.carMake, let model = carDetails.carModel, let year = carDetails.carModelYear {
                carListingCell.carName.text = "\(make) \(model) \(year)"
            }
        
            if let isCertified = carDetails.isCertified {
                carListingCell.carCondition.text = isCertified ? "Certified" : "Used"
            }
            
            if let phone = carDetails.dealer?.phone {
                carListingCell.dealerPhone.setTitle("📞 " + self.formattedPhoneNumber(number: phone), for: .normal)
                carListingCell.dealerPhone.tag = indexPath.row
                // Add action to perform when the button is tapped
                carListingCell.dealerPhone.addTarget(self, action: #selector(callDealerTapped(_:)), for: .touchUpInside)
            }
            
            if let url = carDetails.carThumbnail?.firstPhoto?.mediumPhoto {
                carListingCell.carImage.loadAsyncFrom(url: url, placeholder: UIImage(named: "placeholder"))
            }
        }
    
        // Set tableview cell selection style
        carListingCell.selectionStyle = .none
        
        return carListingCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayCarListings.count == 0 {
            self.carListingsTableView.setEmptyMessage("Used Car Listings\n\nNo data yet")
        } else {
            self.carListingsTableView.restore()
        }
        
        return self.arrayCarListings.count
    }

// MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CarListingCell {
            let index = carListingsTableView.indexPath(for: cell)!.row
            if segue.identifier == segueToDetailViewIdentifier {
                let controller = segue.destination as? CarListingDetailViewController
                if let carDetails = self.arrayCarListings[index] as CarDetails?{
                    // Pass the selected CarListing object to then next controller
                    controller?.carDetails = carDetails
                }
            }
        }
    }
    
// MARK: Helper Methods

    public func formattedPhoneNumber(number: String) -> String {
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
    
    @objc private func callDealerTapped(_ sender: UIButton) {
        if let carDetails = self.arrayCarListings[sender.tag] as CarDetails?, let phone = carDetails.dealer?.phone{
            guard let url = URL(string: "tel://\(phone)") else {
                return //be safe
            }
            // Open the Phone Dialer
            UIApplication.shared.open(url)
        }
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
