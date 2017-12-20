
import Foundation
import UIKit
import CoreLocation
import UserNotifications
import Alamofire
import SwiftyJSON
import SVProgressHUD

class contactSignedInVIEWControllerView: UIViewController{
     let deviceID = UIDevice.current.identifierForVendor!.uuidString
     var params : [String: String] = ["subject":""]
     var address = Constant_Values()
   
    
    
    

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBAction func sendMessage(_ sender: Any) {
        
        if messageTextField.text.isEmpty || subjectTextField.text == ""
        {
            let alertFailure :UIAlertController = UIAlertController(title: "Oops , it seems you left a field empty ", message: nil, preferredStyle: .alert )
            let actionCancel :UIAlertAction = UIAlertAction (title: "Cancel", style: .cancel) { (_:UIAlertAction) in
                print("This notification disappears")
            }
            // alert user that the field is empty
            alertFailure.addAction(actionCancel)
            self.present(alertFailure, animated: true, completion: {
                print("Alert handler")
            })
          
        }
        else{
            SVProgressHUD.show()
      
            
            
            params   = [
                "message" :   messageTextField.text ,
                "subject" :   subjectTextField.text! ,
                "uniqueID" :   deviceID ,
                "action"     :  "contact_support"]
            
             authenticate(url: address.SEND_MAIL_URL , parameters: params)
        
            
        }
        }
    
    //create method that checks sends user parameters to the API
    func authenticate (url : String , parameters : [String:String])
    {
        Alamofire.request(url, method: .post ,parameters : parameters).responseJSON {
            
            response in
            if response.result.isSuccess{
              
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
        print(result)
        
          if result == 1 {
             SVProgressHUD.dismiss()
            let alertSuccess :UIAlertController = UIAlertController(title: "Thanks for your feedback", message: nil, preferredStyle: .alert )
            let actionCancel :UIAlertAction = UIAlertAction (title: "Dismiss", style: .cancel) { (_:UIAlertAction) in

            }
            // alert user that the field is empty
            alertSuccess.addAction(actionCancel)
            self.present(alertSuccess, animated: true, completion: {

            })
            
      messageTextField.text = ""
            subjectTextField.text = ""
        }

        else{
            let alertSuccess :UIAlertController = UIAlertController(title: "Failed, Please check your internet connection", message: nil, preferredStyle: .alert )
            let actionCancel :UIAlertAction = UIAlertAction (title: "Dismiss", style: .cancel) { (_:UIAlertAction) in

            }

            alertSuccess.addAction(actionCancel)
            self.present(alertSuccess, animated: true, completion: {

            })

            SVProgressHUD.dismiss()


        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
}
