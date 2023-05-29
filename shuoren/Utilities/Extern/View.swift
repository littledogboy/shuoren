//
//  View.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/17.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct StatusBarStyleModifier: ViewModifier {
    var color: Color
    let material: Material
    let hidden: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            VStack {
                GeometryReader { geo in
                    color
                        .background(material)
                        .frame(height:geo.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
            
            content
        }
        .statusBar(hidden: hidden)
    }
}


extension View {
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func statusBarStyle(color: Color = .clear,
                        material: Material = .bar,
                        hidden: Bool = false) -> some View {
        self.modifier(StatusBarStyleModifier(color: color,
                                             material: material,
                                             hidden: hidden))
    }
}


