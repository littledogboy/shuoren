//
//  AsyncContentView.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/23.
//

import Foundation
import SwiftUI

enum LoadingState<Value>: Equatable {
    static func == (lhs: LoadingState<Value>, rhs: LoadingState<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        default:
            return false
        }
    }
    
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
    
    
    var value: Value? {
        switch self {
        case .idle: return nil
        case .loading: return nil
        case .loaded(let value): return value
        case .failed(_): return nil
        }
    }
}

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content
    
    init(source: Source, @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
    }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform:source.load)
        case .loading:
            ProgressView()
        case .failed(let error):
            ErrorView(error: error, retryHandler:source.load)
        case .loaded(let output):
            content(output)
        }
    }
}
