//
//  ZoomImageView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/12.
//

import SwiftUI

struct ZoomImageView: View {
    @State private var showingSaveHUD = false
    var uiImage: UIImage

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero

    @Environment(\.dismiss) private var dismiss

    public init(uiImage: UIImage) {
        self.uiImage = uiImage
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.gray
                Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(x: offset.x, y: offset.y)
                .gesture(makeDragGesture(size: proxy.size))
                .gesture(makeMagnificationGesture(size: proxy.size))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topTrailing) {
                closeButton
            }
            .overlay(alignment: .bottomTrailing) {
                saveButton
            }
            .overlay {
                if showingSaveHUD {
                    Hud {
                        Label("保存图片", systemImage: "photo")
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showingSaveHUD = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value

                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }

    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }

    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2

        var newOffsetX = offset.x
        var newOffsetY = offset.y

        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }

        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
}

private extension ZoomImageView {
    
    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.fill.circle)
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .padding(.top, UIDevice.hasHotch ? 50 : 16)
        .padding(.trailing)
    }
    
    var saveButton: some View {
        Button {
            let imageSaver = ImageSaver()
            imageSaver.successHandler = {
                withAnimation {
                    self.showingSaveHUD = true
                }
            }
            imageSaver.errorHandler = {
                debugLog(object: "Oops: \($0.localizedDescription)")
            }
            imageSaver.writeToPhotoAlbum(image: self.uiImage)
        } label: {
            Image(systemName: "square.and.arrow.down")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .padding(.trailing)
        .padding(.bottom)
    }
}

extension UIDevice {
    static var hasHotch: Bool {
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter{ $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene})
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
