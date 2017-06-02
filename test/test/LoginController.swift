//
//  ViewController.swift
//  test
//
//  Created by Devan Cakebread on 5/16/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

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
        let projTableController  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectTableController")

        LoginInfo.shared.username = username.text!
        LoginInfo.shared.password = password.text!
        self.navigationController?.pushViewController(projTableController, animated: true)
    }
    
    func fillLoginInfo() {
        var authString = ""
        
        if let loginInfo = Bundle.main.path(forResource: "login", ofType: "plist"), let dict = NSDictionary(contentsOfFile: loginInfo) as? [String: AnyObject] {
            authString = dict["authString"] as! String
        }
        let data = Data(base64Encoded: authString)
        let plain :String = String(data: data!, encoding: String.Encoding.utf8)!
        
        if plain.contains(":") {
        var loginInfo = plain.components(separatedBy: ":")
        self.username.text = loginInfo[0]
        self.password.text = loginInfo[1]
        }
        
    }
    
}

