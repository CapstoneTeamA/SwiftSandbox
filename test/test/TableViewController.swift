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
    
    @IBOutlet weak var tableView: UITableView!
    var projects: [[String: AnyObject]] = []
    var projNames : [String]? = []
    var projIds : [Int]? = []

    private let projectModel = ProjectListModel()
    
    let unauthorizedMessage = "Error, unauthorized"
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projNames!.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = projNames?[indexPath.row]
        //For un authorized, disable selection and color background red
        if cell.textLabel?.text == unauthorizedMessage {
            cell.backgroundColor = UIColor.red
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.textLabel?.text == unauthorizedMessage {
            return
        }
        let testPlanViewController : TestPlanTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestPlanTableViewController") as! TestPlanTableViewController
        
        testPlanViewController.projId = (projIds?[indexPath.row])!
        
      
        self.navigationController?.pushViewController(testPlanViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"
        //load projects into class with api call.
        projectModel.delegate = self

        projectModel.loadProjectList(username:LoginInfo.shared.username,password:LoginInfo.shared.password)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ProjectTableViewController : ProjectListDelegate {
    func didLoadProjectList(data: [[String : AnyObject]]?) {
        if let projects = data {
            for project in projects {
                if let error : String = project["autherror"] as? String {
                    projNames?.append(error)
                    continue
                }
                let fields: [String : AnyObject] = project["fields"] as! Dictionary
                projNames?.append(fields["name"] as! String)
                projIds?.append(project["id"] as! Int)
            }
        }
        
         RestHelper.reloadTable(tableView: self.tableView)
    }
}
