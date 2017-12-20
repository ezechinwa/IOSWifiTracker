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

class paymentViewController: UIViewController {
      //amount variable
    var amount: String = ""
     var params : [String: String]  = ["device_mac" : "0"]
    
    
    //import buttons actions
    @IBAction func twohundredpressed(_ sender: Any) {
        SVProgressHUD.show()
        amount = "20000"
        params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                    "amount"     :   amount,
                    "action"     :   "paystack_initialize"]
        //make api calls
          authenticate(url:"http://www.wifi.com.ng/mobile_api/index.php" , parameters: params)
        
    }
    @IBAction func onethousandpressed(_ sender: Any) {
        SVProgressHUD.show()
        amount = "100000"
        params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                    "amount"     :   amount,
                    "action"     :  "paystack_initialize"]
        //make api calls
        authenticate(url:"http://www.wifi.com.ng/mobile_api/index.php" , parameters: params)
        
    }
    @IBAction func threethousand(_ sender: Any) {
        SVProgressHUD.show()
        amount = "300000"
        params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                    "amount"     :   amount,
                    "action"     :  "paystack_initialize"]
        //make api calls
        authenticate(url:"http://www.wifi.com.ng/mobile_api/index.php" , parameters: params)
    }
  
    @IBAction func fiftheenthousandpressed(_ sender: Any) {
        SVProgressHUD.show()
        amount = "1500000"
        params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                    "amount"     :   amount,
                    "action"     :  "paystack_initialize"]
        //make api calls
        authenticate(url:"http://www.wifi.com.ng/mobile_api/index.php" , parameters: params)
    }
    
    
    //make status bar disappear
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        
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
     if result == "1" {
 
        let paymenturl = json["paystack_response"]["data"]["authorization_url"].string
        print("paymemturl\(paymenturl)")
        
        //store value here into the shared preference
        UserDefaults.standard.set(paymenturl, forKey: "payment_url")
        
            performSegue(withIdentifier: "gotopayment", sender: self)
        
           SVProgressHUD.dismiss()
       
        
        
        
        
        print("Successful")
            //                performSegue(withIdentifier: "private_mode", sender: self)
        }
            
        else{
            print("Unsuccessful transaction")
            SVProgressHUD.dismiss()
            //                performSegue(withIdentifier: "goToPublicMapViewController", sender: self)
        }
        
    }
    
    
    
}




