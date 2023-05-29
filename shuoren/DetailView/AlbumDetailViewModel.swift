//
//  AlbumDetailViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/14.
//

import SwiftUI

class AlbumDetailViewModel: NSObject, ObservableObject, URLSessionDataDelegate {
    @Published private(set) var albumDetail: AlbumDetail = AlbumDetail()
    @Published var isLoading = false
    var tapUrlString: String?

    func loadData(with href: String?) {
        self.isLoading = true

        guard href != "" else {
            debugLog(object: "链接为空")
            self.isLoading = false
            return
        }
        
        var urlComp = URLComponents(string: kDetail)
        let urlQueryItems = [URLQueryItem(name: "href", value: href)]
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
        return completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.isLoading = false

        do {
            let modelObject = try JSONDecoder().decode(AlbumDetail.self, from: data)
            DispatchQueue.main.async {
                self.albumDetail = modelObject
            }
        } catch {
            debugLog(object: "网络请求出错: \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.isLoading = false
        if let error = error {
            debugLog(object: "网络请求出错: \(error.localizedDescription)")
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
            debugLog(object: "网络请求出错: \(error.localizedDescription)")
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
                debugLog(object: "网络请求出错: \(error.localizedDescription)")
            }
        }
    }
}
