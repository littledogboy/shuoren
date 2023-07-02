//
//  ImageRenderer.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/2.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

#if os(iOS) && compiler(<5.7)
import SwiftUI

public class ImageRenderer<Content: View> {

    @MainActor
    public init(
        content: Content,
        size: CGSize,
        scale: CGFloat? = nil
    ) {
        self.content = content
        self.size = size
        self.scale = scale ?? UIScreen.main.scale
    }

    private let content: Content
    private let size: CGSize

    @MainActor
    public var scale: CGFloat
    
    @MainActor
    public var uiImage: UIImage? {
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        let hosting = UIHostingController(rootView: content)
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

