//
//  shuorenApp.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/29.
//   
//  
    
import SwiftUI
import Kingfisher

@main
struct shuorenApp: App {
    
    init() {
        configKingfisher()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
    
    func configKingfisher() {
        ImageDownloader.default.trustedHosts = ["cdn4.mmdb.cc"]
    }
}
