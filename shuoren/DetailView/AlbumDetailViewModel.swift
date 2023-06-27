//
//  AlbumDetailViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/14.
//

import SwiftUI

class AlbumDetailViewModel: NSObject, ObservableObject, URLSessionDataDelegate, LoadableObject {
    @Published private(set) var state: LoadingState<AlbumDetail> = .idle
    @Published var item: HomeItem
    var tapUrlString: String?
    var receivedData: Data = Data()
    
    init(item: HomeItem) {
        self.item = item
    }
    
    func load() {
        self.state = .loading
        
        var urlComp = URLComponents(string: kDetail)
        let urlQueryItems = [URLQueryItem(name: "href", value: item.href)]
        urlComp?.queryItems = urlQueryItems
        let url = urlComp?.url
        let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        let session = URLSession(configuration: .default, delegate: self as URLSessionDataDelegate, delegateQueue: OperationQueue.main)
        self.checkCachedData(with: session.configuration.urlCache!, with: request)
        let dask = session.dataTask(with: request)
        dask.resume()
    }
    
    // MARK: URLSessionDataDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.receivedData = Data()
        return completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                self.state = .failed(error)
            }
            debugLog(object: "网络请求出错: \(error.localizedDescription)")
        } else {
            do {
                
                let modelObject = try JSONDecoder().decode(AlbumDetail.self, from: self.receivedData)
                DispatchQueue.main.async {
                    self.state = .loaded(modelObject)
                }
            } catch {
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
                debugLog(object: "解析出错: \(error)")
                debugLog(object: String(decoding: self.receivedData, as: UTF8.self))
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        do {
            let modelObject = try JSONDecoder().decode(AlbumDetail.self, from: proposedResponse.data)
            if (modelObject.images!.isEmpty) {
                completionHandler(nil)
            } else {
                
                completionHandler(proposedResponse)
            }
        } catch  {
            completionHandler(nil)
            debugLog(object: "解析出错: \(error)")
        }
    }
    
    // MARK: Other Logic
    func checkCachedData(with cache: URLCache, with request: URLRequest) {
        let cachedResponse = cache.cachedResponseForRequestByFollowingRedirects(request: request)
        if let cachedResponse = cachedResponse {
            do {
                let modelObject = try JSONDecoder().decode(AlbumDetail.self, from: cachedResponse.data)
                if (modelObject.images!.isEmpty) {
                    /// remove empty image cache, so can re request
                    cache.removeCachedResponse(for: request)
                }
            } catch  {
                debugLog(object: "解析出错: \(error)")
            }
        }
    }
    
    func checkItem() {
        do {
            if (try CoreDataManager.shared.contains(item: self.item) != nil) {
                self.item.isFavorite = true
            } else {
                self.item.isFavorite = false
            }
        } catch {
            debugLog(object: "检查出错 \(error)")
        }
    }
}
