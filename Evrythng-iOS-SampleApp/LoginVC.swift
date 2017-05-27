//
//  LoginVC.swift
//  Evrythng-iOS-SampleApp
//
//  Created by JD Castro on 26/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    // MARK: IBActions
    
    @IBAction func actionLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func actionLoginAnonymous(_ sender: UIButton) {
        self.performSegue(withIdentifier: ViewController.SEGUE, sender: nil)
    }
    
    // MARK: ViewController Life Cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
