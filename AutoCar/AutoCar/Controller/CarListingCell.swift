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
    @IBOutlet weak var carImage      : AsyncImageView!
    @IBOutlet weak var carName       : UILabel!
    @IBOutlet weak var carMileage    : UILabel!
    @IBOutlet weak var carPrice      : UILabel!
    @IBOutlet weak var carCondition  : UILabel!
    @IBOutlet weak var dealerPhone   : UIButton!
    
    @IBOutlet
    weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 20.0
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            containerView.layer.shadowRadius = 7.0
            containerView.layer.shadowOpacity = 0.7
        }
    }
}


