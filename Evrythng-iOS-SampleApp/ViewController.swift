//
//  ViewController.swift
//  TestProject
//
//  Created by JD Castro on 09/06/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit
import EvrythngiOS
import Moya
import AVFoundation
import KRProgressHUD

class ViewController: UIViewController {
    
    static let SEGUE = "segueScan"
    
    public var credentials: Credentials?
    
    private let imagePicker = UIImagePickerController()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ivReference: UIImageView!
    @IBOutlet weak var tvDetails: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func actionScan(_ sender: UIButton) {
        let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
        evrythngScanner.scanBarcode()
    }
    
    @IBAction func actionScanFromGallery(_ sender: UIButton) {
        launchGallery()
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.readThng(completion: nil)
        /*self.createUser(completion: { [weak self] (user) in
         self.readThng()
         })*/
    }
    
    private func launchGallery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func readThng(completion: ((Thng?)->Void)?) {
        if let credentials = self.credentials, let apiKey = credentials.evrythngApiKey {
            
            let apiManager = EvrythngApiManager(apiKey: apiKey)
            apiManager.thngService.thngReader(thngId: "U3cVQqSdBgswt5waaYsGxepg").execute(completionHandler: { (thng, err) in
                
                if(err != nil) {
                    print("Error: \(err!.localizedDescription)")
                    let alertTitle = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    if case EvrythngNetworkError.ResponseError(let errorResponse) = err! {
                        var errorMessage = ""
                        if let errorList = errorResponse.errors {
                            errorMessage = errorList.joined(separator: ", ")
                        }
                        self.showAlertDialog(title: alertTitle, message: errorMessage)
                    } else {
                        self.showAlertDialog(title: alertTitle, message: err!.localizedDescription)
                    }
                    
                } else {
                    if let rawString = thng?.jsonData?.rawString() {
                        print("Get Thng Response: \(rawString)")
                    }
                    completion?(thng)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: Other Private Methods

extension ViewController {
    
    internal func deleteUser(userId: String, completion: (()->Void)?) {
        let apiManager = EvrythngApiManager()
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

// MARK: UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("\(#function) Info: \(info)")
        
        let evrythngScanner = EvrythngScanner.init(presentedBy: self, withResultDelegate: self)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                evrythngScanner.scanBarcodeImage(image: pickedImage)
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("\(#function)")
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: EvrythngDelegate

extension ViewController: EvrythngIdentifierResultDelegate {
    
    public func evrythngScannerWillStartIdentify() {
        print("\(#function)")
        KRProgressHUD.show()
    }
    
    public func evrythngScannerDidFinishIdentify(scanIdentificationsResponse: EvrythngScanIdentificationsResponse?, value: String, error: Swift.Error?) {
        print("\(#function)")
        KRProgressHUD.dismiss()
        
        if let err = error {
            
            print("Scan Result Error: \(err.localizedDescription)")
            self.showAlertDialog(title: "Sorry", message: "Scan Error: \(err.localizedDescription)")
            return
            
        } else if let scanResponse = scanIdentificationsResponse {
            
            if let results = scanResponse.results, results.count > 0 {
                print("Scan Result Successful: \(value)")
                
                //if let thng = scanResponse.results?.first?.thng {
                // self.showAlertDialog(title: "Congratulations", message: "Thng Identified: \(thng)")
                if scanResponse.results?.first?.thng != nil {
                    self.showAlertDialog(title: "Congratulations", message: "Thng Identified: \(value)")
                } else if scanResponse.results?.first?.product != nil {
                    self.showAlertDialog(title: "Congratulations", message: "Product Identified: \(value)")
                } else {
                    self.showAlertDialog(title: "Congratulations", message: "Unknown Type Identified: \(value)")
                }
                
                //Custom Identifier "image"
                if let imageStr = scanResponse.results?.first?.thng?.identifiers?["image"] {
                    print("Image Str: \(imageStr)")
                    //let url = URL(string: imageStr)
                    //self.ivReference.kf.setImage(with: url)
                }
            } else {
                self.showAlertDialog(title: "Sorry", message: "No Thng/Product Identified.")
            }
            self.tvDetails.text = scanResponse.jsonData?.rawString()!
            
        } else {
            self.showAlertDialog(title: "Oops", message: "An unknown error occurred")
        }
    }
}
