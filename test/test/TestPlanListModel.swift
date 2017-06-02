//
//  File.swift
//  test
//
//  Created by PSU2 on 6/1/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation

protocol TestPlanListDelegate : class {
    func didLoadTestPlanList(data: [[String : AnyObject]]?)
}

class TestPlanListModel {
    weak var delegate : TestPlanListDelegate?
    var testPlans : [[String : AnyObject]] = []
    
    func loadTestPlanList(forProjectId: Int) {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Test Plans")
        
         endpoint = endpoint.replacingOccurrences(of: "{projectId}", with: "\(forProjectId)")
        
        //Create a url from the endpoint string
        guard let url = URL(string: endpoint) else {
            print("Bad string for url")
            return
        }
        
        //Get a URLRequest with basic auth
        let request = RestHelper.basicAuth(url: url)
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
                    self.testPlans = []
                    self.testPlans.append(["autherror":"Error, unauthorized" as AnyObject])
                    
                } else {
                    //user authorized, parse data section of response and print greeting
                    let testPlanData: [[String:AnyObject]] = jsonData["data"] as! Array
                    self.testPlans = testPlanData
                }
                self.delegate?.didLoadTestPlanList(data: self.testPlans)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
        
    }
}
