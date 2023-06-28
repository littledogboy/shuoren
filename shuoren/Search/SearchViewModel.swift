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
    @Published private(set) var history: [String] = []
    
    init() {
        getHistory()
    }
    
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
    
    func getHistory() {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let historyURL = documentURL.appendingPathComponent("history.plist")
        
        if FileManager.default.fileExists(atPath: historyURL.path) {
            do {
                let data = try Data(contentsOf: historyURL)
                let array = try PropertyListDecoder().decode([String].self, from: data)
                self.history = array
                debugLog(object: array)
            } catch  {
                debugLog(object: "获取 history 错误 \(error)")
            }
        }
    }
    
    func addHistory(searchKey: String) {
        guard !searchKey.isEmpty else {
            return
        }
        
        if let index = self.history.firstIndex(of: searchKey) {
            self.history.swapAt(index, 0)
        } else {
            self.history.insert(searchKey, at: 0)
        }

        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let historyURL = documentURL.appendingPathComponent("history.plist")
        
        do {
           let data = try PropertyListEncoder().encode(self.history)
           try data.write(to: historyURL)
        } catch {
            debugLog(object: "写入 history 错误 \(error)")
        }
    }
}

