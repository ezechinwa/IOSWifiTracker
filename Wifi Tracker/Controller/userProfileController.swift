//
//  ViewController.swift
//  Wifi Tracker
//
//  Created by C on 31/10/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class userProfileController: UIViewController {
    @IBOutlet weak var profileEmailLabel: UILabel!
    
 
    @IBOutlet weak var profileLast30DaysLabel: UILabel!
    @IBOutlet weak var profileLast7days: UILabel!
    @IBOutlet weak var profileExpiryLabel: UILabel!
    @IBOutlet weak var profileMobileLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    //all global variables
    var params : [String: String]  = ["device_mac" : "0"]
    var address = Constant_Values()
    
    
    //make status bar disappear
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
     override func viewDidLoad() {
            super.viewDidLoad()
            SVProgressHUD.show()
            params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                        "action"     :  "user_auth"]
            authenticate(url: address.JSON_URL , parameters: params)
        
        
        }
    
   
    //authenticate users
    func authenticate (url : String , parameters : [String:String])
    {
        Alamofire.request(url, method: .post ,parameters : parameters).responseJSON {
            
            response in
            if response.result.isSuccess{
                
                print("Success. Data was fetched successfully")
                let jsonResponse : JSON = JSON(response.result.value!)
                self.updateUserDetails(json: jsonResponse)
            }
            else{
                //Notify user to check his internet connection
                print("Error \(response.result.error)")
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    func updateUserDetails (json : JSON)
        {
            let result  = json["result"]
            if result == 1 {
                print("start fetching user details")

                
                self.profileEmailLabel.text       = json["email"].string
                 self.profileLast30DaysLabel.text = json["usage30days"].string
                 self.profileLast7days.text       = json["usage7days"].string
                 self.profileExpiryLabel.text     = json["expiry_date"].string
                self.profileNameLabel.text       = json["fname"].string! + " - " + json["lname"].string!
                 self.profileMobileLabel.text     = json["mobile"].string
                
                
                SVProgressHUD.dismiss()
//                performSegue(withIdentifier: "private_mode", sender: self)
            }
    
            else{
                print("User has no active account")
                SVProgressHUD.dismiss()
//                performSegue(withIdentifier: "goToPublicMapViewController", sender: self)
            }
 
        }


    
}



