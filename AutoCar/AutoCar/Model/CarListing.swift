//
//  CarListing.swift
//  AutoCar
//
//  Created by Utsav Parikh on 7/5/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation

class CarListing {
    
    var arrayListing:[ListingItem] = []
    
    public static let sharedInstance = CarListing()
    
    private init() {
        self.arrayListing = []
    }
    
    public func add(myTitle: String, myDescription: String) {
        arrayListing.append(ListingItem(title: myTitle, description: myDescription))
    }
}

struct ListingItem {
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}


