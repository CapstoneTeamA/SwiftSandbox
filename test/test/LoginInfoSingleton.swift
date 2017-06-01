//
//  File.swift
//  test
//
//  Created by PSU2 on 6/1/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import Foundation


class LoginInfo {
    var username = ""
    var password = ""
    
    private init() { }
    
    static let shared = LoginInfo()
}
