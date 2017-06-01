//
//  TestPlanTableViewController.swift
//  test
//
//  Created by PSU2 on 5/29/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestPlanTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var testPlanTable: UITableView!
    var testPlanNames: [String]? = []
    var testPlanIds: [Int]? = []
    var projId : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test Plans"
        fillTestPlansList()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return testPlanNames!.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestPlanCell")
        
        cell.textLabel?.text = testPlanNames?[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testCycleTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestCycleTableViewController") as! TestCycleTableViewController
        

        testCycleTable.testPlanId = (testPlanIds?[indexPath.row])!
        
        self.navigationController?.pushViewController(testCycleTable, animated: true)
    }
    
    func fillTestPlansList() {
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Plans")
        
        endpoint = endpoint.replacingOccurrences(of: "{projectId}", with: "\(self.projId)")
        
        guard let url : URL = URL(string: endpoint) else {
            print("Error")
            return
        }
        
        //Get a URLRequest with basic auth
        let request = RestHelper.basicAuth(url: url)
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
                    self.testPlanNames?.append("Error, unauthorized")
                    RestHelper.reloadTable(tableView: self.testPlanTable)
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    let projectsData: [[String:AnyObject]] = jsonData["data"] as! Array
                    
                    //Clear out data about projects to load in new data
                    self.testPlanIds = []
                    self.testPlanNames = []
                    for project in projectsData {
                        let fields : [String : AnyObject] = project["fields"] as! Dictionary
                        let name : String = fields["name"] as! String
                        
                        self.testPlanNames?.append(name)
                        self.testPlanIds?.append(project["id"] as! Int)
                    }
                }
                
            } catch {
                print("error trying to convert to json")
            }
            //After api call returns, reload data
            RestHelper.reloadTable(tableView: self.testPlanTable)
        }
        
        RestHelper.reloadTable(tableView: self.testPlanTable)
        task.resume()
        
    }



}
