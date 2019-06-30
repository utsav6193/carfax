//
//  CarListingCell.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/30/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import UIKit

class CarListingCell: UITableViewCell {
    @IBOutlet var carImage      : UIImageView!
    @IBOutlet var carName       : UILabel!
    @IBOutlet var carMileage    : UILabel!
    @IBOutlet var carPrice      : UILabel!
    @IBOutlet var carModelYear  : UILabel!
    @IBOutlet var carCondition  : UILabel!
}
