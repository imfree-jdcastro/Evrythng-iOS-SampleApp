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
        //let result = evrythngScanner.identify(barcode: "own_vc_1234567")
        //print("Query Scan Result: \(result.result)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Evrythng.initialize(delegate: self)

        if let user = User(jsonData: ["firstName": "Mymymy", "lastName": "lastlastlast", "email": "test@email.com", "password": "testpassword"]) {
            
            EvrythngUserCreator(user: user).execute(completionHandler: { (user, err) in
                if(err != nil) {
                    print("Error: \(err!)")
                } else {
                    print("Created User: \(user)")
                    
//                    if let userIdToDelete = user?.id {
//                        print("Deleting User: \(userIdToDelete)")
//                        let op = EvrythngOperator(operatorApiKey: "")
//                        op.deleteUser(userId: userIdToDelete).execute(completionHandler: { (err) in
//                            print("Successfully Deleted User: \(userIdToDelete)")
//                        })
//                    } else {
//                        print("Unable to delete user since userId is nil")
//                    }
                }
            })
        }
        
        /*
        EvrythngNetworkDispatcher.getUser { (user, error) in
            guard let user = user else {
                if let error = error {
                    print(error)
                } else {
                    print("Unknown State")
                }
                return
            }
            
            if let userStr = user.toJSONString() {
                print("Test: \(userStr)")
            }
        }
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

