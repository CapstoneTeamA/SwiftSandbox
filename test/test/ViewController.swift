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
    
    var projectNames : [String] = []
    var projectIds : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = RestHelper.getInstance()
        
        fillLoginInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTouchUp(_ sender: Any) {
        //Get the project table view controller and pass the username and password forward before navigating.
        let projTableViewController : ProjectTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectTableViewController") as! ProjectTableViewController
        projTableViewController.username = username.text!
        projTableViewController.password = password.text!
        self.navigationController?.pushViewController(projTableViewController, animated: true)
    }
    
    func fillLoginInfo() {
        if let login = Bundle.main.path(forResource: "login", ofType: "plist"), let dict = NSDictionary(contentsOfFile: login) as? [String: AnyObject] {
            var authString = ""
            if let path = Bundle.main.path(forResource: "login", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                authString = dict["authString"] as! String
                
            }
            let data = Data(base64Encoded: authString)
            let plain :String = String(data: data!, encoding: String.Encoding.utf8)!
            
            var loginInfo = plain.components(separatedBy: ":")
            self.username.text = loginInfo[0]
            self.password.text = loginInfo[1]
        }
    }
    
}

