//
//  URLCache+LSP.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/28.
//

import Foundation

extension URLCache {
    
    /// Note: this solution could cause infinite recursion (and stack overflow) in case of a redirect loop.
    func cachedResponseForRequestByFollowingRedirects(request: URLRequest) -> CachedURLResponse? {
        let cachedResponse = self.cachedResponse(for: request)
        let urlHttpResponse = cachedResponse?.response as? HTTPURLResponse
        
        if [301, 302, 303, 307, 308].contains(urlHttpResponse?.statusCode) {
            let redirectedURL = urlHttpResponse?.allHeaderFields["Location"] as! String
            if redirectedURL.count > 0 {
                let url = URL(string:redirectedURL)
                let newRequset = URLRequest(url: url!)
                return self.cachedResponseForRequestByFollowingRedirects(request: newRequset)
            } else {
                debugLog(object: "Warning: got a redirected URL response, but without a 'Location' field to redirect to. Headers: \(String(describing: urlHttpResponse?.allHeaderFields))")
                return cachedResponse
            }
        }
        
        return cachedResponse
    }
}
