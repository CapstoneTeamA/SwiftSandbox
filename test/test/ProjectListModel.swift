//
//  File.swift
//  test
//
//  Created by PSU2 on 6/1/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation
import UIKit

protocol ProjectListDelegate: class {
    func didLoadProjectList(data: [[String : AnyObject]]?)
}

class ProjectListModel {
    
    weak var delegate: ProjectListDelegate?
    var username = ""
    var password = ""
    var projects : [[String : AnyObject]]? = nil
    
    func loadProjectList(username: String, password: String) {
        self.username = username
        self.password = password
        hitProjectEndpoint()
    }
    
    func hitProjectEndpoint() {
        //Build endpoint url
        var endpoint = ""
        let instance = RestHelper.getInstance()
        endpoint += "https://" + instance + "."
        endpoint += RestHelper.getEndpoint(httpMethod: "GET", endpointKey: "Projects")
        
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
                    self.projects = []
                    self.projects?.append(["autherror":"Error, unauthorized" as AnyObject])
                    
                } else {
                    //user authorized, parse data section of response and print greeting
                    let projectsData: [[String:AnyObject]] = jsonData["data"] as! Array
                    self.projects = projectsData
                }
                self.delegate?.didLoadProjectList(data: self.projects)
                
            } catch {
                print("error trying to convert to json")
            }
        }
        task.resume()
    }
}
