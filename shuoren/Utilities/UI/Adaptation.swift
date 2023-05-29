//
//  Adaptation.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/17.
//

import Foundation
import SwiftUI

enum PixelType {
    case cssFont, mobile
}

func Pixel(_ type: PixelType,_ value: CGFloat) -> CGFloat {
    let scale = UIScreen.main.bounds.size.width / 375.0
    switch type {
    case .cssFont:
        return value * 72.0 / 96.0 * scale
    case .mobile:
        return value / 2.0 * scale
    }
}
