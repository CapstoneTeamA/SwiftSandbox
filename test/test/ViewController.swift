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
        restCall()
    }
    
    func restCall() {
        let user = username.text
        let pass = password.text
        let loginString = user! + ":" + pass!
        let loginData = loginString.data(using: String.Encoding.utf8)
        let base64LoginString = loginData?.base64EncodedString()
        
        let endpoint: String = "https://capstone-sandbox.jamacloud.com/rest/latest/users/current"
        guard let url = URL(string: endpoint) else {
            print("Bad string for url")
            return
        }
        
        //let cred = URLCredential(user: "dwagg", password: "Bewithyou23", persistence: .none)
    
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Basic \(base64LoginString ?? "")", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
  
        let task = session.dataTask(with: urlRequest) {
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
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert to JSON")
                        return
                }
                var meta: [String:AnyObject] = jsonData["meta"] as! Dictionary
                
                let status = meta["status"] as! String
                if (status == "Unauthorized") {
                    print("Authorization failed")
                    return
                }
                else {
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

}

