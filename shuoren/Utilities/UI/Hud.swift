//
//  Hud.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/2.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import SwiftUI

struct Hud<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
       content
            .padding(.horizontal, 12)
            .padding(16)
            .background{
                Capsule()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 5)
            }
    }
}

struct Hud_Previews: PreviewProvider {
    static var previews: some View {
        Hud {
            Text("Example")
        }
    }
}
