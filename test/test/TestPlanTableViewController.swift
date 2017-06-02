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
    private let testPlanList = TestPlanListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Test Plans"
        testPlanList.delegate = self
        testPlanList.loadTestPlanList(forProjectId: self.projId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

}

extension TestPlanTableViewController : TestPlanListDelegate {
    func didLoadTestPlanList(data: [[String : AnyObject]]?){
        if let testPlans = data {
            for testPlan in testPlans {
                if let error : String = testPlan["autherror"] as? String {
                    testPlanNames?.append(error)
                    continue
                }
                let fields: [String : AnyObject] = testPlan["fields"] as! Dictionary
                testPlanNames?.append(fields["name"] as! String)
                testPlanIds?.append(testPlan["id"] as! Int)
            }
        }
        
        RestHelper.reloadTable(tableView: self.testPlanTable)
    }
}
