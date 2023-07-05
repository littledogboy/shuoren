//
//  Data.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/3.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

extension Data {
  var prettySize: String {
    let formatter = ByteCountFormatter()
    formatter.countStyle = .binary
    return formatter.string(fromByteCount: Int64(count))
  }
}
