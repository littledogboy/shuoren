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

#if os(iOS)
import SwiftUI

public extension View {
    
    func snapshot(origin: CGPoint = .zero, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}

private extension UIView {
    
    var renderedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
#endif


