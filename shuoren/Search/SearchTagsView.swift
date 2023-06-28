//
//  SearchTagsView.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/28.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import SwiftUI
import WrappingHStack


struct SearchTagsView: View {
    var tags: [SearchTag]
    
    init(tags: [SearchTag]) {
        self.tags = tags
    }
    
    var body: some View {
        ScrollView {
            WrappingHStack(tags) { tag in
                NavigationLink {
                    HomeView(tag: tag)
                } label: {
                    let vSpacing = 3.0
                    let hSpacing = 5.0
                    Text("\(tag.title)")
                        .foregroundColor(Color(hex: tag.color))
                        .font(.system(size: Pixel(.cssFont,CGFloat(tag.fontSize))))
                        .padding(EdgeInsets(top: vSpacing, leading: hSpacing, bottom: vSpacing, trailing: hSpacing))
                }
            }
            .padding()
        }
        .background(Color(hex: "F0F0F0"))
    }
}
