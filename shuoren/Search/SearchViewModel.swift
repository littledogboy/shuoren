//
//  SearchViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/31.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

class SearchViewModel: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<[SearchTag]> = .idle
    
    func load() {
        self.state = .loading
        Task {
            do {
                let request = URLRequest(url: URL(string: kTags)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async {
                        self.state = .failed(URLError(.badServerResponse))
                    }
                    return
                }
                let jsonData = try JSONDecoder().decode(SearchTagData.self, from: data)
                DispatchQueue.main.async {
                    self.state = .loaded(jsonData.searchTags)
                }
            } catch  {
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
            }
        }
    }
}

