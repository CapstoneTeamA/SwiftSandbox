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
    var projNames : [String]? = []
    var projIds : [Int]? = []
    var username = ""
    var password = ""
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
        
        //These will go away but are useful right now
        testPlanViewController.username = username
        testPlanViewController.password = password
        
        self.navigationController?.pushViewController(testPlanViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"
        //load projects into class with api call.
        fillProjectsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fillProjectsList() {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Projects")
        
        //Create a url from the endpoint string
        guard let url = URL(string: endpoint) else {
            print("Bad string for url")
            return
        }
        
        //Get a URLRequest with basic auth
        let request = RestHelper.basicAuth(url: url, username: username, password: password)
        let session = URLSession.shared
        
        //define the completion handler for the dataTask because this is done async
        let task = session.dataTask(with: request) {
            (data,response,error) in
            guard error == nil else {
                print("error calling endpoint")
                print(error as Any)
                return
            }
            guard let responseData = data else {
                print("Error did not recieve data")
                return
            }
            //Parsing json
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                //Get the meta section of the response to get the status
                var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
                let status = meta["status"] as! String
                
                //If user isn't authorized show an auth failed message
                if (status == "Unauthorized") {
                    self.projNames?.append("Error, unauthorized")
                    RestHelper.reloadTable(tableView: self.tableView)
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    let projectsData: [[String:AnyObject]] = jsonData["data"] as! Array
                    
                    //Clear out data about projects to load in new data
                    self.projIds = []
                    self.projNames = []
                    for project in projectsData {
                        let fields : [String : AnyObject] = project["fields"] as! Dictionary
                        let name : String = fields["name"] as! String
                        
                        self.projNames?.append(name)
                        self.projIds?.append(project["id"] as! Int)
                    }
                }
                
            } catch {
                print("error trying to convert to json")
            }
            //After api call returns, reload data
            RestHelper.reloadTable(tableView: self.tableView)
        }
        task.resume()
    }
}
