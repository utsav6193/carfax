//
//  AutoCarTests.swift
//  AutoCarTests
//
//  Created by Utsav Parikh on 6/29/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import XCTest
@testable import AutoCar

class AutoCarTests: XCTestCase {

    var carListing: CarListing!
    var carDetails: CarDetails?
    var carListingsController: CarListingsViewController!

    // Dummy JSON data
    private let jsonData = Data("""
    {
        "make": "Acura",
        "mileage": 82303,
        "model": "ILX",
        "vin": "19VDE1F39EE012939",
        "year": 2015,
        "bodytype": "Sedan",
        "certified": false,
        "currentPrice": 15599
    }
    """.utf8)

// MARK: - Set Up
    
    override func setUp() {
        carListing = CarListing.sharedInstance
        carListingsController = CarListingsViewController()
    }

    override func tearDown() {
        carListing = nil
        carDetails = nil
        carListingsController = nil
    }

// MARK: - Test Cases
    
    func testListingDataInsertion() {
        carListing.add(myTitle: "Make", myDescription: "Lexus")
        carListing.add(myTitle: "Model", myDescription: "RX 350")
        carListing.add(myTitle: "Year", myDescription: "2015")
        carListing.add(myTitle: "Body", myDescription: "SUV")
        
        // test for array count match
        XCTAssertTrue(carListing.arrayListing.count == 4)
        
        // test for order of values in array
        XCTAssertTrue(carListing.arrayListing[0].title == "Make")
        XCTAssertTrue(carListing.arrayListing[0].description == "Lexus")
        XCTAssertTrue(carListing.arrayListing[3].title == "Body")
        XCTAssertTrue(carListing.arrayListing[3].description == "SUV")
    }
    
    
    func testCarDetailsModelDataMapping() {
        do {
            carDetails = try JSONDecoder().decode(CarDetails.self, from: jsonData)
        }catch {
            XCTFail("Error. Unable to decode JSON")
        }
        
        XCTAssertEqual(carDetails?.carVIN, "19VDE1F39EE012939")
        XCTAssertEqual(carDetails?.carMake, "Acura")
        XCTAssertEqual(carDetails?.carModel, "ILX")
        XCTAssertNil(carDetails?.carThumbnail)
        XCTAssertNil(carDetails?.carTransmission)
    }

    func testFormattedPhoneNumber() {
        var formattedNumber = carListingsController.formattedPhoneNumber(number: "8582221134")
        XCTAssertTrue(formattedNumber == "(858) 222-1134")
        
        formattedNumber = carListingsController.formattedPhoneNumber(number: "")
        XCTAssertTrue(formattedNumber == "")
        
        formattedNumber = carListingsController.formattedPhoneNumber(number: "Not a number")
        XCTAssertTrue(formattedNumber == "")
    }
}

