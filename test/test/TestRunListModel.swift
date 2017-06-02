//
//  TestRunListModel.swift
//  test
//
//  Created by PSU2 on 6/2/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation

class TestRunListModel {
    weak var delegate : EndpointDelegate?
    var testRuns : [[String : AnyObject]] = []
    var testCycleId = -1
    
    func loadTestRuns(forCycleId: Int) {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
       
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Cycle Runs")
        endpoint = endpoint.replacingOccurrences(of: "{testCycleId}", with: "\(forCycleId)")
        
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: delegate!)
    }
}
