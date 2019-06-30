//
//  CarDetails.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/30/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import Alamofire


struct CarDetails: Codable{
    
    let listingID           :       Int?
    let carVIN              :       Int?
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

    enum ListingKeys: String, CodingKey {
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

// MARK: Convenience initializers

extension CarDetails
{
    init(data: Data) throws {
        self = try JSONDecoder().decode(CarDetails.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
