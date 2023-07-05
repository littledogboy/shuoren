//
//  LongPictureView.swift
//  shuoren
//
//  Created by littledogboy on 2023/7/2.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import SwiftUI
import Kingfisher
import Photos

struct LongPictureView: View {
    @State var snapshot: UIImage?
    @State private var showingSaveHUD = false
    @State private var isGeneratingImage = false
    @State var scrollViewContentSize: CGSize?
    
//    private let compressionQueue = OperationQueue()

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
            debugLog(object: "存储长图失败:\($0)")
        }
        Task {
            if let image = await generateSnapshot(size: size) {
                
                /*
                let doubleFileSize = Double(image.getSizeIn(.megabyte))!
                let imageFileMaxSize = 40.0 // MB
                debugLog(object: "原始图片大小 %f: \(doubleFileSize) MB")
                
                compressionQueue.addOperation {
                  do {
                      let percent: Double = imageFileMaxSize / doubleFileSize
                      let ceilTruePercent = Double(Int(percent * 100)) / 100.0
                      let data = try image.heicData(compressionQuality: ceilTruePercent)
                      debugLog(object: ceilTruePercent)
                      debugLog(object: data.prettySize)
                      let heicImage = UIImage(data: data)
                      DispatchQueue.main.async {
                          self.isGeneratingImage = false
                          imageSaver.writeToPhotoAlbum(image: heicImage ?? image)
                      }
                  } catch {
                    print("Error creating HEIC data: \(error.localizedDescription)")
                  }
                }
                 */
                
                
                // Save 48MP ProRaw to PhotoLibrary may fail
                // https://developer.apple.com/forums/thread/716143
                // PHPhotosErrorDomain error 3303
                // https://www.youtube.com/watch?v=T6P-u0R5as8
                var resizedImage: UIImage?
                let doubleFileSize = Double(image.getSizeIn(.megabyte))!
                let imageFileMaxSize = 40.0 // MB
                debugLog(object: "原始图片大小 %f: \(doubleFileSize) MB")
                
                if doubleFileSize > imageFileMaxSize {
                    let percent: Double = imageFileMaxSize / doubleFileSize
                    let truePercent = sqrt(percent)
                    let ceilTruePercent = Double(Int(truePercent * 100)) / 100.0
                    debugLog(object: "ceilPercent : \(ceilTruePercent) ")
                    if let resultImage = image.resized(withPercentage: ceilTruePercent) {
                        debugLog(object: "调整后的图片大小 %f: \(Double(resultImage.getSizeIn(.megabyte))!) MB")
                        resizedImage = resultImage
                    }
                }
                
                self.isGeneratingImage = false
                imageSaver.writeToPhotoAlbum(image: resizedImage ?? image)
            }
        }
    }
    
    func generateSnapshot(size: CGSize) async -> UIImage? {
        let extraHeight: CGFloat = 32 + 44 + 20
        let height: CGFloat = extraHeight + size.height
        let renderer = await ImageRenderer(content: scrollView, size: CGSize(width: size.width, height: height))
        return await renderer.uiImage
    }
    
    /*
    func saveResizedImageToPhotoLibrary(imageData: Data) {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            let options = PHAssetResourceCreationOptions()
            creationRequest.addResource(with: .photo, data: imageData, options: options)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Image saved successfully")
                    // Show a success message or perform any additional actions
                } else {
                    if let error = error {
                        print("Error saving image: \(error.localizedDescription)")
                        // Show an error message or handle the error appropriately
                    } else {
                        print("Unknown error occurred while saving image")
                        // Show an error message or handle the error appropriately
                    }
                }
            }
        }
    }
    */
}



struct LongPictureView_Previews: PreviewProvider {
    static var previews: some View {
        LongPictureView(imageItems: [])
    }
}
