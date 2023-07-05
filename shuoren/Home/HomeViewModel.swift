//
//  HomeViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/2/26.
//

import SwiftUI
import Combine

class HomeViewModel:LoadableObject, ObservableObject {
    var desURL: String

    @Published private(set) var state = LoadingState<[HomeItem]>.idle
    private var currentPage = 1
    private var hasMore = true
    private var cancellable: AnyCancellable?
    
    init(desURL: String) {
        self.desURL = desURL
    }
    
    deinit {
        cancellable?.cancel()
    }

    func load() {
        self.state = .loading
        updateDesURL()
        
        Task {
            var isServerON = false
            
            debugLog(object: "检查服务器健康")

            do {
                let (_, response) = try await URLSession.shared.data(for: URLRequest(url: URL(string:kPing)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3))
                if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                    isServerON = true
                }
            } catch {
                debugLog(object: "检查服务器出错: \(error.localizedDescription)")
            }
            
            debugLog(object: "检查服务器健康检查完毕")
            debugLog(object: "服务器是否在线：\(isServerON), 进行下一步请求")

            let url = URL(string: desURL)
            let request = URLRequest(url: url!, cachePolicy: isServerON ? .useProtocolCachePolicy : .returnCacheDataElseLoad, timeoutInterval: 10)
            do {
                let (data, response) = try await URLSession.shared.data(for:request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        self.state = .failed(URLError(.badServerResponse))
                    }
                    return
                }
                
                let decodeData = try JSONDecoder().decode(HomeData.self, from: data)
                DispatchQueue.main.async {
                    self.state = .loaded(decodeData.recommends ?? [])
                }
                self.currentPage = 1
                self.hasMore = decodeData.recommends?.count ?? 0 > 0
            } catch {
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func loadMore() {
        guard self.hasMore else {
            return
        }
        
        let nextPage = currentPage + 1
        
        var urlComp = URLComponents(string: desURL)
        let urlQueryItems = [URLQueryItem(name: "page", value: String(nextPage))]
        if urlComp?.queryItems != nil {
            urlComp?.queryItems! += urlQueryItems
        } else {
            urlComp?.queryItems = urlQueryItems
        }
        
        let url = urlComp?.url
        let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        cancellable = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap({ (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                                
                            }
                return data
            })
            .decode(type: HomeData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print ("Received completion: \($0).")
            }, receiveValue: { homeData in
                if let recommends = homeData.recommends {
                    if case .loaded(let items) = self.state {
                        let newArray: [HomeItem] = items + recommends
                        DispatchQueue.main.async {
                            self.state = .loaded(newArray)
                        }
                        self.currentPage += 1
                        self.hasMore = true
                    }
                } else {
                    self.hasMore = false
                }
            })
    }
    
    func reload() async {
        self.state = .loading
        let url = URL(string: desURL)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        do {
            let (data, _) = try await URLSession.shared.data(for:request)
            let decodeData = try JSONDecoder().decode(HomeData.self, from: data)
            DispatchQueue.main.async {
                self.state = .loaded(decodeData.recommends ?? [])
            }
            self.currentPage = 1
            self.hasMore = decodeData.recommends?.count ?? 0 > 0
        } catch {
            DispatchQueue.main.async {
                self.state = .failed(error)
            }
        }
    }
    
    func updateDesURL() {
        if !desURL.contains(kServerDomain) {
            if let oldHost = URL(string: desURL)?.host {
                if let newHost = URL(string: kServerDomain)?.host {
                    desURL = desURL.replacingOccurrences(of: oldHost, with: newHost)
                }
            }
        }
    }
}

 

