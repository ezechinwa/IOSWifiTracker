//
//  MainMapwithNavigationViewController.swift
//  Wifi Tracker
//
//  Created by C on 06/11/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import UIKit
import MapKit
//Json calls
import Alamofire
import SwiftyJSON
//import SWRevealViewController



class MainMapwithNavigationViewController: UIViewController ,MKMapViewDelegate, CLLocationManagerDelegate{
    

    
    
    
    //location manager
    
    let regionRadius: CLLocationDistance = 1000
    
    //this is the main menu button
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //this is mapView component
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    
    
 
    
    
    //adjusting the camara
    var camera = MKMapCamera()
    private let session:URLSession = .shared
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        mapView.showAnnotations([userLocation], animated: true)
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        let center   = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
//        self.map.setRegion(center,animated:true)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //call the side menu
         sideMenu()
        mapInitialize()

//       loadmarkers (url:"http://104.131.101.150/locations.json")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    

    }
    
    func mapInitialize(){
        mapView.delegate = self
        //
       var coordinate2D = CLLocationCoordinate2DMake(6.435394,3.441067)
        
        //
        //let VictoriaIsland = MKCoordinateRegionMake(coordinate2D,MKCoordinateSpanMake(50, 50))
        //mapView.setRegion(VictoriaIsland, animated: true)
        UpdateMapRegion(coordinate2D:coordinate2D, rangeSpan:100)
    }
    
    func UpdateMapRegion(coordinate2D:CLLocationCoordinate2D,  rangeSpan:CLLocationDistance){
        let region = MKCoordinateRegionMakeWithDistance(coordinate2D, rangeSpan ,rangeSpan)
        mapView.region = region
        
        loadmarkers (url:"http://104.131.101.150/locations.json")
        
    }


    
    func sideMenu(){
        
//        if revealViewController() != nil
//        {
//            menuButton.target  = revealViewController()
//            menuButton.action  = #selector(SWRevealViewController.revealToggle(_:))
//            revealViewController().rearViewRevealWidth = 275
//            revealViewController().rightViewRevealWidth = 0
//
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        
    }
    
    func loadmarkers (url : String)
    {
        Alamofire.request(url, method: .get).responseJSON {
            
            response in
            if response.result.isSuccess{
                
                print("Success. Data was fetched successfully")
                let jsonResponse : JSON = JSON(response.result.value!)
                self.updateMarkersDetails( json: jsonResponse)
               // self.updateMarkersDetails(json: jsonResponse)
            }
            else{
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    func updateMarkersDetails (json : JSON)
    {
        var length = 1853
        var i:Int = 0

        
        //markers
    
       
        repeat {
            let  address  = json["markers"]["marker"][i]["_address"].stringValue
            let lat       = json["markers"]["marker"][i]["_lat"].doubleValue
            let lng       = json["markers"]["marker"][i]["_lng"].doubleValue
            
    
            
            
            //add pins to map
            let newCoordinate = CLLocationCoordinate2DMake(lat,lng)
            let markerPin = MKPointAnnotation()
                markerPin.coordinate = newCoordinate
                markerPin.title   = address
                markerPin.subtitle   = "You can connect to @Free Wifi.com.ng"
                mapView.addAnnotation(markerPin)
            
//             print("\(lat)")
            
            //adding clustering
           
           
            
            i = i + 1
            
            
        
        }
            while i < 1853
        
    
    
    }
}
