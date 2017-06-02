//
//  File.swift
//  test
//
//  Created by PSU2 on 6/1/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation

class TestPlanListModel {
    weak var delegate : EndpointDelegate?
    var testPlans : [[String : AnyObject]] = []
    
    func loadTestPlanList(forProjectId: Int) {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Plans")
        endpoint = endpoint.replacingOccurrences(of: "{projectId}", with: "\(forProjectId)")
        
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: delegate!)
    }
}
