//
//  Image.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/12.
//

import Foundation
import SwiftUI
import Kingfisher
import UIKit

extension Image {
    init(kfImage: KFCrossPlatformImage) {
        self.init(uiImage: kfImage)
    }
}


