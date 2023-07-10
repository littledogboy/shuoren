//
//  AppConfig.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/5.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

let defaultServerDomainKey = "kServerDomain"
let defaultServerDomain = "http://localhost:8080"

public class AppConfig {
    static let shared = AppConfig()
    var serverDomain: String {
        didSet {
            UserDefaults.standard.set(serverDomain, forKey: defaultServerDomainKey)
        }
    }
    
    init() {
        if let defaultServerDomain = UserDefaults.standard.value(forKey: defaultServerDomainKey) {
            serverDomain = defaultServerDomain as! String
        } else {
            serverDomain = defaultServerDomain
        }
    }
}
