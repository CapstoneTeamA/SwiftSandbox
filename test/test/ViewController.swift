//
//  ViewController.swift
//  test
//
//  Created by Devan Cakebread on 5/16/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTouchUp(_ sender: Any) {
        print("Button touched, calling to get current user")
        greetCurrentUser() //Makes rest call to get current user and prints a greeting
    }
    
    func greetCurrentUser() {
        var endpoint = ""
        let instance = EndpointHelper.getInstance()
        
        //Build endpoint
        endpoint+="https://" + instance + "."
        endpoint += EndpointHelper.getEndpoint(httpMethod: "GET", endpointKey: "Current User")
        
        //Create a url from the endpoint string
        guard let url = URL(string: endpoint) else {
            print("Bad string for url")
            return
        }
    
        //Get a URLRequest with basic auth
        let request = basicAuth(url: url)
        let session = URLSession.shared
  
        //define the completion handler for the dataTask because this is done async
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
                
                //If user isn't authorized print an auth failed message
                if (status == "Unauthorized") {
                    print("Authorization failed")
                    return
                } else {
                    //user authorized, parse data section of response and print greeting
                    var currentUser: [String: AnyObject] = jsonData["data"] as! Dictionary
                    let name = currentUser["firstName"] as! String
                    print("Hello " + name)
                }

            } catch {
                print("error trying to convert to json")
            }
        }
        
        task.resume()
    }
    
    func basicAuth(url : URL) ->URLRequest {
        //Grab the username and password from UI and build an encoded string for Rest basic auth
        let user = username.text
        let pass = password.text
        let loginString = user! + ":" + pass!
        let loginData = loginString.data(using: String.Encoding.utf8)
        let base64LoginString = loginData?.base64EncodedString()
        
        //Create a URLRequest, add necessary key:values to the header, then return the request
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Basic \(base64LoginString ?? "")", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }

}

