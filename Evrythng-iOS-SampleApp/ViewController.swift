//
//  ViewController.swift
//  Evrythng-iOS-SampleApp
//
//  Created by JD Castro on 26/04/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import EvrythngiOS
import Moya

class ViewController: UIViewController {

    // MARK: - IBActions
    
    @IBAction func actionScan(_ sender: UIButton) {
        let evrythngScanner = EvrythngScanner.init(presentingVC: self)
        evrythngScanner.scanBarcode()
        //let result = evrythngScanner.queryScanResult(barcode: "own_vc_1234567")
        //print("Query Scan Result: \(result.result)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Evrythng.initialize(delegate: self)

        EvrythngNetworkDispatcher.getUser { (user, error) in
            guard let user = user else {
                if let error = error {
                    print(error)
                } else {
                    print("Unknown State")
                }
                return
            }
            print("Test: \(user.birthday)")
        }
        /*
        let provider = MoyaProvid
        provider.request(.createUser(firstName: "James", lastName: "Potter")) { result in
            // do something with the result (read on for more details)
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: EvrythngDelegate {
    
    func evrythngInitializationDidSucceed() {
        print("Evrythng Initialization Succeeded")
    }
    
    func evrythngInitializationDidFail() {
        print("Evrythng Initialization Failed")
    }
}

