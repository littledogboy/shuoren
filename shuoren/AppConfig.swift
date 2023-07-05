//
//  AppConfig.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/5.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

public class AppConfig {
    static let shared = AppConfig()
    var serverDomain: String
    
    init() {
        serverDomain = "http://192.168.0.10:8080"
    }
}
