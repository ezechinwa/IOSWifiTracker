import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import Alamofire
import SwiftyJSON
import CoreLocation

class PublicMapViewController: UIViewController,CLLocationManagerDelegate , GMSMapViewDelegate , GMUClusterManagerDelegate ,UISearchBarDelegate ,GMSAutocompleteViewControllerDelegate  {
   // this variable is used for calculate currentLatitide and longitude
    var currentLat:CLLocationDegrees = 0
    var currentLon: CLLocationDegrees = 0
    var distancearray  = [Double]()
    
  
//    var searchResultController : SearchResultsController!
//    var resultArray = [String]()
   
    @IBOutlet weak var mapView: GMSMapView!
   
    //trying to display current location
    var locationManager = CLLocationManager()
    var clusterManager : GMUClusterManager!
    let isClustering : Bool = true
    let isCustom : Bool = true
    
    //initialize the map variables
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
     
        initializeTheLocationManager()
        self.mapView.isMyLocationEnabled = true
        
//        searchResultController = SearchResultsController()
//        searchResultController.delegate = self
        
        //initialize markers
        loadmarkers (url:"http://104.131.101.150/locations.json")
        
        if isClustering{
            var iconGenerator : GMUDefaultClusterIconGenerator!
            //let the default icon generator be that of the framework
            iconGenerator =   GMUDefaultClusterIconGenerator()
            
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer  = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator:  iconGenerator  )
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
            clusterManager.cluster()
            clusterManager.setDelegate(self, mapDelegate: self)
        }
        
       
        
    }
    
    class POIItem :  NSObject , GMUClusterItem{
        var position: CLLocationCoordinate2D
        var name: String
        
        init(position : CLLocationCoordinate2D , name: String ) {
            self.position = position
            self.name = name
        }
        
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position , zoom: mapView.camera.zoom + 1)
        let update    = GMSCameraUpdate.setCamera(newCamera)
//        mapView.moveCamera(update)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        let item = POIItem(position: coordinate , name: "String")
//        clusterManager.add(item)
//        clusterManager.cluster()
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let poiItem = marker.userData as? POIItem
        
        marker.title = poiItem?.name
        
        return false
    }

    
    func initializeTheLocationManager()
    {
        SVProgressHUD.show()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
       
    }
    
    func locationManager(_ manager: CLLocationManager,      didUpdateLocations locations: [CLLocation]) {
        
        var location = locationManager.location?.coordinate
        
//        define current location
        
        currentLat = (location?.latitude)!
        currentLon = (location?.longitude)!
        
        
    }
    
    
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            mapView.settings.myLocationButton = true
        }
    }
    
    //api functions
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
    
    //this function collects the the current location and api location as parameters
    func distanceDifference(currentLatitude : CLLocationDegrees , currentLongitude : CLLocationDegrees , apiLatitude : Double , apiLongitude : Double) -> Double {
        
       let myLocation = CLLocation(latitude: currentLatitude , longitude: currentLongitude )
        
        //start performing calculation
        let coordinate0 =  myLocation
        let coordinate1 = CLLocation(latitude: apiLatitude, longitude: apiLongitude)
        
        let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
        
        return distanceInMeters
    }
    
    func updateMarkersDetails (json : JSON)
    {
        let location = locationManager.location?.coordinate
        
        cameraMoveToLocation(toLocation: location)
        
        
         var i:Int = 0
         distancearray.removeAll()
          repeat {
            let  address  = json["markers"]["marker"][i]["_address"].stringValue
            let lat       = json["markers"]["marker"][i]["_lat"].doubleValue
            let lng       = json["markers"]["marker"][i]["_lng"].doubleValue

            //add pins to map
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.title = address
            marker.snippet = "@Free Wifi.ng Hotspot location"
//            marker.map = mapView
            
            
            //adding markers
            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: address)
            clusterManager.add(item)
            
            
            //after clustering it is time to calcularte the distance between different points
            if currentLat != 0{
                //start comparing distance
                let shortestDistance = distanceDifference(currentLatitude: currentLat , currentLongitude: currentLon, apiLatitude : lat , apiLongitude : lng)
                //print distanceresults
                  distancearray.append(shortestDistance)
            }


            i = i + 1
        }
            while i < 1853
//        time to get the index value
        let indexArray: Int = distancearray.index(of: distancearray.min()!)!
          //time to draw the lines
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLon))
        path.add(CLLocationCoordinate2D(latitude: json["markers"]["marker"][indexArray]["_lat"].doubleValue,
                                        longitude: json["markers"]["marker"][indexArray]["_lng"].doubleValue))
//        path.add(CLLocationCoordinate2D(latitude: -33.73, longitude: 151.41))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        SVProgressHUD.dismiss()
    }

    
    

    
//    func  locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        locationManager.stopUpdatingLocation() // Stop Location Manager - keep here to run just once
        let location = locationManager.location?.coordinate
        
        cameraMoveToLocation(toLocation: location)
        
    }

    
     override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera =  GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.mapView.camera  = camera
        self.dismiss(animated: true, completion:nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error Auto Complete \(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true , completion: nil)
    }
    
    
    //search button pressed
//
//    @IBAction func locationSearchButton(_ sender: Any) {
//
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.present(searchController , animated: true , completion: nil)
//    }
//
//    func searchBar(searchBar: UISearchBar , textDidChange searchText: String){
//        let placesClient = GMSPlacesClient()
//        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: Error?) -> Void in
//          self.resultArray.removeAll()
//            if results == nil {
//                return
//            }
//            for result in results!{
//                if let result  = results as? GMSAutocompletePrediction{
//                    self.resultArray.append(result.attributedFullText.string)
//                }
//            }
//
//            self.searchResultController.reloadDataWithArray(self.resultArray)
//
//        }
//
//
//    }
//
//    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
//       DispatchQueue.main.async{ () -> Void in
//            _ = CLLocationCoordinate2DMake(lat, lon)
////        let marker = GMSMarker(position: position)
//        let camera = GMSCameraPosition.camera(withLatitude:lat, longitude: lon, zoom: 15)
//        self.mapView.camera = camera
//        }
//
//}
}
