//
//  TestRunTableViewController.swift
//  test
//
//  Created by PSU2 on 5/30/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestRunTableController: UIViewController {

    @IBOutlet weak var testRunTable: UITableView!
    var testCycleId = -1
    var testRunNames: [String] = []
    var testRunIds: [Int] = []
    var testRunSteps: [String : [[String : String]]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test Runs"
        
        let testRunListModel = TestRunListModel()
        testRunListModel.delegate = self
        testRunListModel.loadTestRuns(forCycleId: testCycleId)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TestRunTableController : EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?) {
        if data != nil {
            for testRun in data! {
                self.testRunIds.append(testRun["id"] as! Int)
                let fields : [String : AnyObject] = testRun["fields"] as! Dictionary
                let name = fields["name"] as! String
                self.testRunNames.append(name)
                
                if let steps : [[String : String]] = fields["testRunSteps"] as? Array {
                    self.testRunSteps.updateValue(steps as [[String : String]], forKey: name)
                }
                else {
                    self.testRunSteps.updateValue([], forKey: name)
                }
            }
            RestHelper.reloadTable(tableView: self.testRunTable)
        }
    }
}

extension TestRunTableController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
}
