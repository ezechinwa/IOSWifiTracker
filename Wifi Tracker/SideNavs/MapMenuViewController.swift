//
//  MapMenuViewController.swift
//  Wifi Tracker
//
//  Created by C on 02/11/2017.
//  Copyright © 2017 Tizeti Networks Limited. All rights reserved.
//

import UIKit

class MapMenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
let title_array = ["Home","Connect"]
    @IBOutlet weak var menu_table_View: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu_table_View.delegate = self
        menu_table_View.dataSource=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        return title_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"menu_cell") as! MenuTableViewCell
        cell.labelTitl.text = title_array[indexPath.row]
    }


}
