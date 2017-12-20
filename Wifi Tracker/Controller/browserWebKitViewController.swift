//
//  browserWebKitViewController.swift
//  Wifi Tracker
//
//  Created by C on 23/11/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class browserWebKitViewController: UIViewController {
    var mac_address : String = ""
    var paystackurl : String = ""
    
    //make status bar disappear
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func terminateTransaction(_ sender: Any) {
    }
  
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collect storepreferences
        
        UserDefaults.standard.set("98:dd:ea:ab:b8:1f", forKey: "device_mac")
        
        if let payUrl = UserDefaults.standard.object(forKey: "payment_url") as? String{
           paystackurl = payUrl
        }
        
        if let savedmacaddress = UserDefaults.standard.object(forKey: "device_mac") as? String{
          mac_address = savedmacaddress
        }
        
          print("your secret mac address is given \(mac_address)")
        
        //        webView!.bounds = containerView.bounds
        let myURL = URL(string: paystackurl)
        let myRequest = URLRequest(url: myURL!)
        _ = webView?.load(myRequest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
   
        
//        /* Create a configuration for our preferences */
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences = preferences
//
//       webView = WKWebView(frame: self.containerView.bounds, configuration: configuration)
         webView!.bounds = containerView.bounds
    }
    
    override func loadView() {
        super.loadView()
        
        
        webView = WKWebView()
        
        if (webView != nil) {
            webView!.frame = containerView.frame
            containerView.addSubview(webView!)
        }
        
//
//        self.webView = WKWebView()
//        self.view = self.webView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

