//
//  DealerDetails.swift
//  AutoCar
//
//  Created by Utsav Parikh on 7/6/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation

struct DealerDetails: Codable {
    
    let phone                   :       String?
    let name                    :       String?
    let address                 :       String?
    let city                    :       String?
    let state                   :       String?
    let zip                     :       String?
    let rating                  :       Float?
    let latitude                :       String?
    let longitude               :       String?
    
    enum CodingKeys: String, CodingKey {
        case phone              =       "phone"
        case name               =       "name"
        case address            =       "address"
        case city               =       "city"
        case state              =       "state"
        case zip                =       "zip"
        case rating             =       "dealerAverageRating"
        case latitude           =       "latitude"
        case longitude          =       "longitude"
    }
}
