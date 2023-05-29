//
//  ErrorView.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/23.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryHandler: () -> Void
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            Button(action: retryHandler, label: { Text("Retry").bold() })
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError(domain: "", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Something went wrong"]),
                  retryHandler: { })
    }
}
