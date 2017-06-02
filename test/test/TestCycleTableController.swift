//
//  TestRunTableViewController.swift
//  test
//
//  Created by PSU2 on 5/29/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestCycleTableController: UIViewController {

    
    @IBOutlet weak var testCycleTable: UITableView!
    var testPlanId: Int = -1
    var testCycleNames: [String] = []
    var testCycleIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test Cycles"
        let testCyclesModel = TestCycleListModel()
        testCyclesModel.delegate = self
        testCyclesModel.loadTestCycleList(forTestPlanId: testPlanId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TestCycleTableController : UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testCycleNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TestCycleCell")
        cell.textLabel?.text = testCycleNames[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let testRunTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestRunTableController") as! TestRunTableController
        
        testRunTable.testCycleId = (testCycleIds[indexPath.row])
        self.navigationController?.pushViewController(testRunTable, animated: true)
    }
}

//Set up TestCycleTableController to conform to the model's protocol to load in the data
extension TestCycleTableController : EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?) {
        if data != nil {
            for testCycle in data! {
                testCycleIds.append(testCycle["id"] as! Int)
                let fields : [String : AnyObject] = testCycle["fields"] as! Dictionary
                testCycleNames.append(fields["name"] as! String)
            }
            RestHelper.reloadTable(tableView: self.testCycleTable)
        }
    }
}
