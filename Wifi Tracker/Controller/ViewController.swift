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

class ViewController: UIViewController {
    //collect the api address
    var address = Constant_Values()
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    //create parameter array
    var params : [String: String]  = ["device_mac" : "0"]
    
    
    
    //add functionalities to the login button then allow the user to click on it
    
    /*
     var message : String
     var subject : String
 
     
     let deviceID = UIDevice.current.identifierForVendor!.uuidString
     var params : [String: String] = ["subject":""]
     params   = [
     "message" :   message ,
     "subject" :   "subject ,
     "uniqueID" :   deviceID ,
     "action"     :  "contact_support"]
     
     */
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//98:dd:ea:ab:b8:1f
        params   = ["device_mac" :   "B8:44:D9:11:55:0D" ,
                    "action"     :  "user_auth"]
        
        
        
        
        //Store mac id in a shared preference
      
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    
    //Function that triggers whenever the button is pressed
    @IBAction func loginButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        print(deviceID)
        //        print(address.JSON_URL)
        // print(params["device_mac"])
        
        authenticate(url: address.JSON_URL , parameters: params)
    }
    
    
    
    //create method that checks sends user parameters to the API
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
                print("Error \(response.result.error)")
            }
            
        }
    }
  
    
    func updateUserDetails (json : JSON)
    {
        let result  = json["result"]
        //Check result Status
        //if result is equal to one means that the user logged in successfully
        //collect information to store in IOS shared preferences
        if result == 1 {
            //collect and store user information in a local varable
            let email :  String = json["email"].string!
         
            
            
            print("logged in successfully")
            //now collect information to be stored in shared preference
            UserDefaults.standard.set("98:dd:ea:ab:b8:1f", forKey: "device_mac")
            UserDefaults.standard.set(email, forKey: "user_email")
            
            
            SVProgressHUD.dismiss()
            
            //navigate to private view
            performSegue(withIdentifier: "goToPublicMapViewController", sender: self)
            
        }
            
            //else just collect the result infomation and redirect him to the public page
            
        else{
            print("logged sorry username already exist")
            SVProgressHUD.dismiss()
            performSegue(withIdentifier: "goToPrivateMapViewController", sender: self)
            
        }
        print(result)
    }
    
}


