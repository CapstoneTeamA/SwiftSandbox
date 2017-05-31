//
//  TestRunViewController.swift
//  test
//
//  Created by PSU2 on 5/31/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestRunViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var testStepTable: UITableView!
    var username = ""
    var password = ""
    var testRunName = ""
    var testSteps: [[String : String]] = []
    var testRunId = -1
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = testRunName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return testSteps.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestRunCell")
        let cell = self.testStepTable.dequeueReusableCell(withIdentifier: "TestRunExecutionCell") as! TestRunExecutionCell
        
        if !testSteps.isEmpty {
            cell.nameLabel.text = testSteps[indexPath.row]["action"]
            cell.statusLabel.text = testSteps[indexPath.row]["status"]
            cell.resultsLabel.text = testSteps[indexPath.row]["result"]
            cell.notesText.text = testSteps[indexPath.row]["notes"]
            cell.expectedResultsText.text = testSteps[indexPath.row]["expectedResult"]
        }
        return cell
    }
}
