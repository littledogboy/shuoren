//
//  String.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/25.
//

import Foundation
import SwiftUI

extension String {
    func addQueryItem(key: String, value: String) -> String {
        var urlComp = URLComponents(string: self)
        let urlQueryItems = [URLQueryItem(name: key, value: value)]
        urlComp?.queryItems = urlQueryItems
        let url = urlComp?.url
        return url!.absoluteString
    }
}
