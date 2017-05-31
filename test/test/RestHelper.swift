//
//  EndpointHelper.swift
//  test
//
//  Created by PSU2 on 5/27/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation
import UIKit

public class RestHelper {
    
    public static func getInstance() -> String{
        //Get the Endpoints plist, grab and return the value from the "Instance" key
        if let plist = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: plist) as? [String: AnyObject] {
            let instance :String = dict["Instance"] as! String
            return instance
        }
        return ""
    }
    
    public static func getEndpoint(httpMethod:String, endpointKey:String) -> String {
        //Get the Endpoints plist, using the http method string select the correct dictionary of endpoints, then grab and return the endpoint
        if let plist = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: plist) as? [String: AnyObject] {
            guard let httpDict : [String:AnyObject] = dict[httpMethod] as? Dictionary else {
                print("HTTP method does not exist. Ensure method is all caps")
                return ""
            }
            guard let endpoint :String = httpDict[endpointKey] as? String else {
                print("Endpoint key does not exist. Double check spelling")
                return ""
            }
            return endpoint
        }
        return ""
    }
    
    public static func basicAuth(url : URL, username: String, password: String) -> URLRequest {
        //Grab the username and password from UI and build an encoded string for Rest basic auth
        let user = username
        let pass = password
        let loginString = user + ":" + pass
        let loginData = loginString.data(using: String.Encoding.utf8)
        let base64LoginString = loginData?.base64EncodedString()
        
        //Create a URLRequest, add necessary key:values to the header, then return the request
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Basic \(base64LoginString ?? "")", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    //This might belong in a different hepler or this helper should be renamed to better reflect all that it does.
    public static func reloadTable(tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
