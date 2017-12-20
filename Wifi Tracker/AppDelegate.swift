//
//  AppDelegate.swift
//  Wifi Tracker
//
//  Created by C on 31/10/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import Alamofire
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //collect the current location data
    var userLatitude  :  Double  = UserDefaults.standard.double(forKey: "currentLatitude")
    var userLongitude :  Double  = UserDefaults.standard.double(forKey: "currentLongitude")
    var userAddress   :  String  = UserDefaults.standard.string(forKey: "currentAddress") as? String ?? "0"
    
    var params : [String: String]  = ["action" : "nearestDistance"]
    
   
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
              GMSServices.provideAPIKey("AIzaSyCtF3diziXKr-u3kX5QadCdZcNKR9-VcEc")
              GMSPlacesClient.provideAPIKey("AIzaSyCtF3diziXKr-u3kX5QadCdZcNKR9-VcEc")
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        return true
    }
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
      
        if userLatitude != 0.0 {
            params   = ["action"       :   "nearestDistance" ,
                        "latitude"     :    String(userLatitude),
                        "longitude"    :    String(userLongitude)
                  ]
            
             authenticate(url: "http://104.131.101.150/tizetiwebsite/testing.php", parameters: params)
            
            print("Hello nigeria \(userLatitude)")
//           postAction(self)
            
            //make API calls
            
            
        }
        else{
            //this means user has never been initialized to use this service
            print("Hello world")
        }
        completionHandler(UIBackgroundFetchResult.newData)
        
        
        }
    

 
    //create method that checks sends user parameters to the API
    func authenticate (url : String , parameters : [String:String])
    {
        Alamofire.request(url, method: .post ,parameters : parameters).responseJSON {
            
            response in
            if response.result.isSuccess{
                
                print("Background. Data was fetched successfully")
                let jsonResponse : JSON = JSON(response.result.value!)
                self.updateUserDetails2(json: jsonResponse)
            }
            else{
                print("Error \(response.result.error)")
            }
            
        }
    }
  
    
    func updateUserDetails2 (json : JSON)
    {
        let result  = json["result"]

        if result == "OK" {
        
            print("Background Task here")
            
            //Store current UserData in a shared preference
//            UserDefaults.standard.set(location.coordinate.latitude,  forKey: "currentLatitude")
//            UserDefaults.standard.set(location.coordinate.longitude, forKey: "currentLongitude")
            
            
            
            //now collect information to be stored in shared preference
//            UserDefaults.standard.set("98:dd:ea:ab:b8:1f", forKey: "device_mac")
//            UserDefaults.standard.set(email, forKey: "user_email")
            
            
            if UserDefaults.standard.string(forKey: "currentAddress") as? String ?? "0" == json["address"].string {
                //this means user address has been regisred
                print("user has been registered")
                print("stored address \(userAddress)")
                print("api address \(json["address"].string)")
                print(" \(UserDefaults.standard.string(forKey: "currentAddress") as? String ?? "0" == json["address"].string)")
            }
            else{
                //Define new address
                 UserDefaults.standard.set(json["address"].string, forKey: "currentAddress")
                
                if (json["distance"]) < 200
                {
                   //user can now be notified
                    print("notify user")
                    
                }
                
                print("user has not been registered")
                print("stored address \(userAddress)")
                print("api address \(json["address"].string)")
                print(" \(UserDefaults.standard.string(forKey: "currentAddress") as? String ?? "0" == json["address"].string)")
                
            }
      
       
            
        }
            
            //else just collect the result infomation and redirect him to the public page
            
        else{
            
        }
    }
        
        
    
    }

   



