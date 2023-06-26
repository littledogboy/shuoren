//
//  AlbumDetailView.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/14.
//

import SwiftUI
import Kingfisher


struct AlbumDetailView: View {
    var homeItem: HomeItem?
    @StateObject var vm: AlbumDetailViewModel
    
    @State private var scale = 1.0
    @State private var lastScale = 1.0
    
    private let minScale = 1.0
    private let maxScale = 3.0
    
    @State private var isImagePresented = false
    
    init(homeItem: HomeItem?) {
        self.homeItem = homeItem
        self._vm = StateObject(wrappedValue: AlbumDetailViewModel(item: homeItem!))
    }
    
    var body: some View {
        AsyncContentView(source: self.vm) { albumDetail in
            GeometryReader { geometryreader in
                List (albumDetail.images ?? []) { image in
                    // imageView
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
                            .onSuccess { result in
                            }
                            .resizable()
                            .onTapGesture {
                                self.vm.tapUrlString = urlString
                                isImagePresented.toggle()
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .clipped()
                            .listRowSeparatorTint(.white)
                            .listRowInsets(EdgeInsets(top:4, leading: 4, bottom: 4, trailing: 4))
                        
                    }
                }
                .scaleEffect(scale)
                .gesture(makeMagnificationGesture(size: geometryreader.size))
                .fullScreenCover(isPresented: $isImagePresented) {
                    let image = ImageCache.default.retrieveImageInMemoryCache(forKey: self.vm.tapUrlString!)
                    if let image = image {
                        ZoomImageView(image: Image(kfImage: image))
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(self.homeItem!.title ?? "", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        vm.item.isFavorite.toggle()
                        if vm.item.isFavorite {
                            do {
                                try                             CoreDataManager.shared.saveNewItem(item: vm.item)

                            } catch {
                                debugLog(object: "存储失败 \(error)")
                            }
                        } else {
                            
                        }
                    } label: {
                        let isFavorite = vm.item.isFavorite
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                }
            }
        }
    }
    
    func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { state in
                let delta = state / lastScale
                scale *= delta
                lastScale = state
            }
            .onEnded { state in
                withAnimation {
                    scale = min(scale, maxScale)
                    scale = max(scale, minScale)
                }
                lastScale = 1.0
            }
    }
}



struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(homeItem: nil)
    }
}
