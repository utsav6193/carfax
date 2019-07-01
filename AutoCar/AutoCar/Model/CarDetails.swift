//
//  CarDetails.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/30/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation

struct CarDetails: Codable{
    
    let listingID           :       String?
    let carVIN              :       String?
    let carMake             :       String?
    let carModel            :       String?
    let carModelYear        :       Int?
    let carMileage          :       Int?
    let carPrice            :       Int?
    let carCondition        :       String?
    let carExteriorColor    :       String?
    let carInteriorColor    :       String?
    let isCertified         :       Bool
    let carBodyType         :       String?
    let carTransmission     :       String?

    enum CodingKeys: String, CodingKey {
        case listingID          =       "id"
        case carVIN             =       "vin"
        case carMake            =       "make"
        case carModel           =       "model"
        case carModelYear       =       "year"
        case carMileage         =       "mileage"
        case carPrice           =       "currentPrice"
        case carCondition       =       "vehicleCondition"
        case carExteriorColor   =       "exteriorColor"
        case carInteriorColor   =       "interiorColor"
        case isCertified        =       "certified"
        case carBodyType        =       "bodytype"
        case carTransmission    =       "transmission"
    }
}


