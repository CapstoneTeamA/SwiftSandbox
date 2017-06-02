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
    
    public static func basicAuth(url : URL) -> URLRequest {
        //Grab the username and password from UI and build an encoded string for Rest basic auth
        let user = LoginInfo.shared.username
        let pass = LoginInfo.shared.password
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
    
    static func hitEndpoint(atEndpointString: String, withDelegate: EndpointDelegate, httpMethod: String = "GET" ) {
        //Create a url from the endpoint string
        guard let url = URL(string: atEndpointString) else {
            print("Bad string for url")
            return
        }
        
        //Get a URLRequest with basic auth
        var request = RestHelper.basicAuth(url: url)
        request.httpMethod = httpMethod
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data,response,error) in
            guard error == nil else {
                print("error calling endpoint")
                print(error as Any)
                return
            }
            guard let responseData = data else {
                print("Error did not recieve data")
                return
            }
            var endpointData : [[String: AnyObject]]  = []
            //Parsing json
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                //Get the meta section of the response to get the status
                var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
                let status = meta["status"] as! String
                
                //If user isn't authorized show an auth failed message
                if (status == "Unauthorized") {
                    endpointData = []
                    endpointData.append(["autherror":"Error, unauthorized" as AnyObject])
                    
                } else {
                    //user authorized, parse data section of response and print greeting
                    endpointData = jsonData["data"] as! Array
                }
                withDelegate.didLoadEndpoint(data: endpointData)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
    }
    
    //This might belong in a different hepler or this helper should be renamed to better reflect all that it does.
    public static func reloadTable(tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
