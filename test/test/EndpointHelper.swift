//
//  EndpointHelper.swift
//  test
//
//  Created by PSU2 on 5/27/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation

public class EndpointHelper {
    public static func getInstance() -> String{
        //Get the Endpoints plist, grab and return the value from the "Instance" key
        if let path = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            let instance :String = dict["Instance"] as! String
            return instance
        }
        return ""
    }
    
    public static func getEndpoint(httpMethod:String, endpointKey:String) -> String {
        //Get the Endpoints plist, using the http method string select the correct dictionary of endpoints, then grab and return the endpoint
        if let path = Bundle.main.path(forResource: "Endpoints", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
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
}
