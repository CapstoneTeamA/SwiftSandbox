//
//  TestRunTableViewController.swift
//  test
//
//  Created by PSU2 on 5/30/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestRunTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var testRunTable: UITableView!
    var testCycleId = -1
    var testRunNames: [String] = []
    var testRunIds: [Int] = []
    var testRunSteps: [String : [[String : String]]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test Runs"
        fillTestRunList()
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
        return testRunNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestRunCell")
        
        cell.textLabel?.text = testRunNames[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testRun = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestRunExecutionController") as! TestRunExecutionController
        
        testRun.testRunName = (testRunNames[indexPath.row])
        testRun.testRunId = (testRunIds[indexPath.row])
        testRun.testSteps = testRunSteps[testRun.testRunName]!
        self.navigationController?.pushViewController(testRun, animated: true)
    }
    
    func fillTestRunList() {
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Cycle Runs")
        
        endpoint = endpoint.replacingOccurrences(of: "{testCycleId}", with: "\(self.testCycleId)")
        
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
                    self.testRunNames.append("Error, unauthorized")
                    RestHelper.reloadTable(tableView: self.testRunTable)
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    let runData: [[String:AnyObject]] = jsonData["data"] as! Array
                    
                    //Clear out data about projects to load in new data
                    self.testRunIds = []
                    self.testRunNames = []
                    for run in runData {
                        let fields : [String : AnyObject] = run["fields"] as! Dictionary
                        let name : String = fields["name"] as! String
                        
                        self.testRunNames.append(name)
                        self.testRunIds.append(run["id"] as! Int)
                        
                        if let steps : [[String : String]] = fields["testRunSteps"] as? Array {
                            self.testRunSteps.updateValue(steps as [[String : String]], forKey: name)
                        }
                        else {
                            self.testRunSteps.updateValue([], forKey: name)
                        }
                    }
                }
                
            } catch {
                print("error trying to convert to json")
            }
            //After api call returns, reload data
            RestHelper.reloadTable(tableView: self.testRunTable)
        }
        
        RestHelper.reloadTable(tableView: self.testRunTable)
        task.resume()
        
    }

}
