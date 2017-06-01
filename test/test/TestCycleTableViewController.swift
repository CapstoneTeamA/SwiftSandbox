//
//  TestRunTableViewController.swift
//  test
//
//  Created by PSU2 on 5/29/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestCycleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var testCycleTable: UITableView!
    var testPlanId: Int = -1
    var testCycleNames: [String] = []
    var testCycleIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Test Cycles"
        fillTestCycleList()

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
        return testCycleNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestCycleCell")
        
        cell.textLabel?.text = testCycleNames[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testRunTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestRunTableViewController") as! TestRunTableViewController
        
        testRunTable.testCycleId = (testCycleIds[indexPath.row])
        
        self.navigationController?.pushViewController(testRunTable, animated: true)
    }
    
 
    func fillTestCycleList() {
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Plan Cycles")
        
        endpoint = endpoint.replacingOccurrences(of: "{testPlanId}", with: "\(self.testPlanId)")
        
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
                    self.testCycleNames.append("Error, unauthorized")
                    RestHelper.reloadTable(tableView: self.testCycleTable)
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    let cycleData: [[String:AnyObject]] = jsonData["data"] as! Array
                    
                    //Clear out data about projects to load in new data
                    self.testCycleIds = []
                    self.testCycleNames = []
                    for cycle in cycleData {
                        let fields : [String : AnyObject] = cycle["fields"] as! Dictionary
                        let name : String = fields["name"] as! String
                        
                        self.testCycleNames.append(name)
                        self.testCycleIds.append(cycle["id"] as! Int)
                    }
                }
                
            } catch {
                print("error trying to convert to json")
            }
            //After api call returns, reload data
            RestHelper.reloadTable(tableView: self.testCycleTable)
        }
        
        RestHelper.reloadTable(tableView: self.testCycleTable)
        task.resume()
        
    }

}
