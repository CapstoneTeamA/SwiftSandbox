//
//  TableViewController.swift
//  test
//
//  Created by PSU2 on 5/28/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation
import UIKit

class ProjectTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var projNames : [String]? = []
    var projId : [Int]? = []
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projNames!.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = projNames?[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
