//
//  Api.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/1.
//

import Foundation

let kReferer = "https://meirentu.cc"

var kServerDomain: String {
    AppConfig.shared.serverDomain
}

var kPing: String {
    debugLog(object: kServerDomain)
    return kServerDomain + "/ping"
}

var kHome: String {
    kServerDomain + "/home"
}

var kDetail: String {
    kServerDomain + "/detail"
}

var kMenu: String {
    kServerDomain + "/menuItems"
}

var kGroup: String {
    kServerDomain + "/group"
}


var kTags: String {
    kServerDomain + "/tags"
}

var kTagPage: String {
    kServerDomain + "/tag"
}

var kSearch: String {
    kServerDomain + "/search"
}


