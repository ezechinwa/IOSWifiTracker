import Foundation
import UIKit
import CoreLocation
import UserNotifications
import Alamofire
import SwiftyJSON


class connectControllerView: UIViewController, CLLocationManagerDelegate {
    
    var currentLat1 : String = "0"
    var currentLat2 : String = "0"
     var params : [String: String]  = ["action" : "nearestDistance"]
    
  

    var isgranted = false
    
    @IBAction func connect(_ sender: Any) {
//        openSettings()
        let url2 = URL(string: "App-Prefs:root=WIFI")
        
        if UIApplication.shared.canOpenURL(url2!){
            UIApplication.shared.openURL(url2!)
            
        }
      
    }
    @IBAction func calibrateButton(_ sender: Any) {
        
        if (currentLat1 == "0"){
            //notify user to turn on location services
        }
        else{
            authenticate(url: "http://104.131.101.150/tizetiwebsite/testing.php", parameters: params)
            
        }
    }
    func openSettings() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
        
    }
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            self.isgranted = granted
            
        }
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            
            
        }
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            
            //update user current information
            
            UserDefaults.standard.set(location.coordinate.latitude,  forKey: "currentLatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "currentLongitude")
            
            currentLat1 = String(location.coordinate.latitude)
            currentLat2 = String(location.coordinate.longitude)
            
            
            params   = ["action"       :   "nearestDistance" ,
                        "latitude"     :    currentLat1,
                        "longitude"    :    currentLat2
            ]
            
//            findLabel.text = "\(location.coordinate.latitude)"
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "in order to verify the nearest Hotspot location, we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
 
    
    
    //create method that checks sends user parameters to the API
    func authenticate (url : String , parameters : [String:String])
    {
        Alamofire.request(url, method: .post ,parameters : parameters).responseJSON {
            
            response in
            if response.result.isSuccess{
                
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
            
     json["address"].string
            
            addressLabel.text  = json["address"].string
            distanceLabel.text = " \(json["distance"].stringValue) Meters"
          
            
        }
            
    }
    
    
    
    
}





