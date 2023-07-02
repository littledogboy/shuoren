//
//  LongPictureView.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/2.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import SwiftUI
import Kingfisher

struct LongPictureView: View {
    @State var snapshot: UIImage?
    @State private var showingSaveHUD = false
    @State private var isGeneratingImage = false
    @State var scrollViewContentSize: CGSize?

    var imageItems: [ImageModel]
    
    init(imageItems: [ImageModel]) {
        self.imageItems = imageItems
    }
    
    var body: some View {
        scrollView
    }
    
    var scrollView: some View {
        GeometryReader { geometryreader in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(imageItems) { image in
                        if let img = image.src {
                            let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            let url = URL(string: urlString!)
                            let modifier = AnyModifier { request in
                                var r = request
                                r.setValue(kReferer, forHTTPHeaderField: "referer")
                                return r
                            }
                            
                            let padding = 4.0
                            let width = geometryreader.size.width - 2.0 * padding
                            let ratio = CGFloat(image.width) / CGFloat(image.height)
                            let height = width / ratio
                            
                            KFImage.url(url)
                                .requestModifier(modifier)
                                .cacheOriginalImage()
                                .fade(duration: 0.25)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: height)
                                .clipped()
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical)
                .background(
                                GeometryReader { proxy in
                                    Color.clear.onAppear {
                                        let top = proxy.safeAreaInsets.top
                                        let newSize = CGSize(width: proxy.size.width, height: proxy.size.height + top)
                                        self.scrollViewContentSize = newSize
                                        debugLog(object: proxy.size)
                                        debugLog(object: top)
                                    }
                                }
                            )
            }
            .overlay {
                if showingSaveHUD {
                    Hud {
                        Label("保存长图", systemImage: "photo")
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
            .overlay(content: {
                if isGeneratingImage {
                    Hud {
                        Label("生成图片中...", systemImage: "circle.dotted")
                    }
                    .zIndex(1)
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        shareLongPicture(size: self.scrollViewContentSize!)
                    } label: {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                    }
                }
            }
        }
    }
    
    func shareLongPicture(size: CGSize) {
        self.isGeneratingImage = true
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            withAnimation {
                self.showingSaveHUD = true
            }
        }
        imageSaver.errorHandler = {
            debugLog(object: "存储长图失败:\($0.localizedDescription)")
        }
        Task {
            if let image = await generateSnapshot(size: size) {
                self.isGeneratingImage = false
                imageSaver.writeToPhotoAlbum(image: image)
            }
        }
    }
    
    func generateSnapshot(size: CGSize) async -> UIImage? {
        let extraHeight: CGFloat = 32 + 44 + 20
        let renderer = await ImageRenderer(content: scrollView, size: CGSize(width: size.width, height: size.height + extraHeight))
        return await renderer.uiImage
    }
}


struct LongPictureView_Previews: PreviewProvider {
    static var previews: some View {
        LongPictureView(imageItems: [])
    }
}
