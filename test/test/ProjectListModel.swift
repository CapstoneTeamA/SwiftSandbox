//
//  File.swift
//  test
//
//  Created by PSU2 on 6/1/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation
import UIKit

protocol EndpointDelegate : class {
    func didLoadEndpoint(data: [[String : AnyObject]]?)
}

class ProjectListModel {
    
    weak var delegate: EndpointDelegate?
    var projects : [[String : AnyObject]]? = nil
    
    func loadProjectList() {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Projects")
        
        RestHelper.hitEndpoint(atEndpointString: endpoint, withDelegate: delegate!)
    }
}
