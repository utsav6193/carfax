//
//  NetworkManager.swift
//  AutoCar
//
//  Created by Utsav Parikh on 6/30/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

struct NetworkManager {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    
    // MARK: - Services
    func fetchCarListings(_ strURL: String, success:@escaping ([String : Any]) -> Void, failure:@escaping (Error) -> Void) {
        
        //start HUD while calling network API
        SVProgressHUD.show()
        
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            //dismiss HUD once API response received
            SVProgressHUD.dismiss()
            
            if responseObject.result.isSuccess {
                success(responseObject.result.value! as! [String : Any])
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
}
