//
//  TableViewController.swift
//  test
//
//  Created by PSU2 on 5/28/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation
import UIKit

class ProjectTableViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var projects: [[String: AnyObject]] = []
    var projNames : [String]? = []
    var projIds : [Int]? = []
    private let projectModel = ProjectListModel()
    let unauthorizedMessage = "Error, unauthorized"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"
        //sets self as a delegate and calls to load projects
        projectModel.delegate = self
        projectModel.loadProjectList()
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

extension ProjectTableViewController : UITableViewDelegate, UITableViewDataSource {
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
        //Pass project id ahead and segue to next view
        testPlanViewController.projId = (projIds?[indexPath.row])!
        self.navigationController?.pushViewController(testPlanViewController, animated: true)
    }
}
