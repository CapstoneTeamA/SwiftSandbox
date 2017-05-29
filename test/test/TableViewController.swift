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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projNames!.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = projNames?[indexPath.row]
        if cell.textLabel?.text == "Error, unauthorized" {
            cell.backgroundColor = UIColor.red
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"
        getProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getProjects() {
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
                
                //If user isn't authorized print an auth failed message
                if (status == "Unauthorized") {
                    print("Authorization failed")
                    self.projNames?.append("Error, unauthorized")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    //self.navigationController?.popViewController(animated: false)
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    let projectsData: [[String:AnyObject]] = jsonData["data"] as! Array
                    
                    print("projects count = " + String(projectsData.count))
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
        
    }
}
