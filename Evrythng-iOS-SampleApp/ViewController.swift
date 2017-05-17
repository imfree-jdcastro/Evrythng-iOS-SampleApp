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
import QRCodeReader
import AVFoundation

class ViewController: UIViewController {

    let apiManager = EvrythngApiManager()
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - IBActions
    
    @IBAction func actionScan(_ sender: UIButton) {
        
        let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
        evrythngScanner.scanBarcode()
        
        /*
        if(QRCodeReader.isAvailable()) {
            do {
                let isSupported = try QRCodeReader.supportsMetadataObjectTypes()
                if(isSupported) {
                    // Retrieve the QRCode content
                    // By using the delegate pattern
                    readerVC.delegate = self
                    
                    // Or by using the closure pattern
                    /*
                    readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                        print(result)
                    }
                    */
                    
                    // Presents the readerVC as modal form sheet
                    readerVC.modalPresentationStyle = .formSheet
                    self.present(readerVC, animated: true, completion: nil)
                    
                    //        let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
                    //        evrythngScanner.scanBarcode()
                    //let result = evrythngScanner.identify(barcode: "own_vc_1234567")
                    //print("Query Scan Result: \(result.result)")

                }
            } catch {
                print("Device does not support MetadataObjectTypes")
                self.showAlertDialog(title: "Sorry", message: "Your device does not support AVMetadataObjectTypes for Scanning")
            }
        } else {
            print("QRCodeCodeReader is not available")
            self.showAlertDialog(title: "Sorry", message: "Your device does not support QRCodeReader for Scanning")
        }
         */
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Evrythng.initialize(delegate: self)
        
        /*
        if let user = User(jsonData: ["firstName": "Mymymy", "lastName": "lastlastlast", "email": "test2@email.com", "password": "testpassword"]) {
            
            apiManager.authService.evrythngUserCreator(user: user).execute(completionHandler: { (user, err) in
                if(err != nil) {
                    print("Error: \(err!)")
                    self.showAlertDialog(title: "Sorry", message: err!.localizedDescription)
                } else {
                    print("Created User: \(user?.jsonData?.rawString())")
                    if let userIdToDelete = user?.id {
                        print("Deleting User: \(userIdToDelete)")
                        self.deleteUser(userId: userIdToDelete, completion: nil)
                    } else {
                        print("Unable to delete user since userId is nil")
                    }
                }
            })
 
        }
         */
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

// MARK: Other Private Methods

extension ViewController {
    
    internal func deleteUser(userId: String, completion: (()->Void)?) {
        let op = apiManager.authService.evrythngOperator(operatorApiKey: "hohzaKH7VbVp659Pnr5m3xg2DpKBivg9rFh6PttT5AnBtEn3s17B8OPAOpBjNTWdoRlosLTxJmUrpjTi")
        op.deleteUser(userId: userId).execute(completionHandler: { (err) in
            print("Successfully Deleted User: \(userId)")
            completion?()
        })
    }
    
    internal func showAlertDialog(title: String, message: String) {
        let alertDialog = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertDialog.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alertDialog.dismiss(animated: true, completion: nil)
        }))
        self.present(alertDialog, animated: true, completion: nil)
    }
}

// MARK: EvrythngDelegate

extension ViewController: EvrythngDelegate {
    
    func evrythngInitializationDidSucceed() {
        print("Evrythng Initialization Succeeded")
    }
    
    func evrythngInitializationDidFail() {
        print("Evrythng Initialization Failed")
    }
}

extension ViewController: EvrythngScannerResultDelegate {
    public func didFinishScanResult(result: String, error: Swift.Error?) {
        if let err = error {
            print("Default Scan Result Error: \(err.localizedDescription)")
            self.showAlertDialog(title: "Sorry", message: "Scan Error: \(err.localizedDescription)")
            return
        } else {
            print("Default Scan Result Successful: \(result)")
            self.showAlertDialog(title: "Congratulations", message: "Thng Identified: \(result)")
        }
    }
}

// MARK: - QRCodeReaderViewController Delegate Methods

extension ViewController: QRCodeReaderViewControllerDelegate {
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
        evrythngScanner.identify(barcode: result.value)
        //dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}
