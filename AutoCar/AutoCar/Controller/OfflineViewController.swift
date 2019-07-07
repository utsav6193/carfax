//
//  OfflineViewController.swift
//  AutoCar
//
//  Created by Utsav Parikh on 7/6/19.
//  Copyright © 2019 Carfax. All rights reserved.
//

import Foundation
import UIKit

class OfflineViewController: UIViewController {
    
    let reachabilityManager:ReachabilityManager = ReachabilityManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachabilityManager.reachability.whenReachable = { reachability in
            self.showMainController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toCarListingsController", sender: self)
        }
    }
}

