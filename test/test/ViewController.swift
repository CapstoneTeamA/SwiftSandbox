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
    

    


}

