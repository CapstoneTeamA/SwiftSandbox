//
//  TestCycleListModel.swift
//  test
//
//  Created by PSU2 on 6/2/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation

class TestCycleListModel {
    weak var delegate: EndpointDelegate?
    var testCycles : [[String : AnyObject]] = []
    
    func loadTestCycleList(forTestPlanId: Int) {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Plan Cycles")
        endpoint = endpoint.replacingOccurrences(of: "{testPlanId}", with: "\(forTestPlanId)")
        
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: delegate!)
    }
}
