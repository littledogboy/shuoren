//
//  AlbumDetailView.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/14.
//

import SwiftUI
import Kingfisher


struct AlbumDetailView: View {
    var homeItem: HomeItem
    @StateObject var vm: AlbumDetailViewModel
    @State var shareSheet: Bool = false
    
    @State private var scale = 1.0
    @State private var lastScale = 1.0
    
    private let minScale = 1.0
    private let maxScale = 3.0
    
    @State private var isImagePresented = false
    
    init(homeItem: HomeItem) {
        self.homeItem = homeItem
        self._vm = StateObject(wrappedValue: AlbumDetailViewModel(item: homeItem))
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
                                self.vm.getTappedImageWithURLString(url: self.vm.tapUrlString)
                                if self.vm.tappedImage != nil {
                                    isImagePresented = true
                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .clipped()
                            .listRowSeparatorTint(.white)
                            .listRowInsets(EdgeInsets(top:4, leading: 4, bottom: 4, trailing: 4))
                    }
                    
                    if !albumDetail.images!.isEmpty && image == albumDetail.images!.last {
                        shareButton
                        longPictureButton(items: albumDetail.images!)
                    }
                }
                .scaleEffect(scale)
                .gesture(makeMagnificationGesture(size: geometryreader.size))
                .fullScreenCover(isPresented: $isImagePresented) {
                    ZoomImageView(uiImage: self.vm.tappedImage!)
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(self.homeItem.title ?? "", displayMode: .inline)
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
                            do {
                                try CoreDataManager.shared.deleteItem(item: vm.item)
                                vm.item.isFavorite = false
                            } catch {
                                debugLog(object: "删除失败 \(error)")
                            }
                        }
                    } label: {
                        let isFavorite = vm.item.isFavorite
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                }
            }
            .sheet(isPresented: $shareSheet) {
                ShareSheetView(activityItems: vm.shareImages)
            }
        }
        .onAppear {
            vm.checkItem()
        }
    }
    
    var shareButton: some View {
        Button {
            vm.getShareImages()
            if !vm.shareImages.isEmpty {
                shareSheet = true
            }
        } label: {
            Label(title: {
                Text("分享")
                .foregroundColor(.blue)
                .font(.system(size:24))
                }, icon: {
                    Image(systemName: "link")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.blue)
                    .aspectRatio(contentMode: .fit)
                })
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
        }
        .listRowSeparatorTint(.white)
    }
    
    func longPictureButton(items: [ImageModel]) -> some View {
        NavigationLink {
            LongPictureView(imageItems: items)
        } label: {
            Label(title: {
                Text("分享长图")
                .foregroundColor(.blue)
                .font(.system(size:24))
                }, icon: {
                    Image(systemName: "link")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.blue)
                    .aspectRatio(contentMode: .fit)
                })
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(5)
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

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [UIImage]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

