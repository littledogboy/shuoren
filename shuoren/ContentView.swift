//
//  ContentView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/29.
//   
//  
    
import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
      }
    
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView(home: kHome)
                .tabItem {
                    Label("首页", systemImage: "house")
                }
                .tag(0)
            
            GroupView()
                .tabItem {
                    Label("发现", systemImage: "globe.asia.australia")
                }
                .tag(1)
            
            SearchView()
                .tabItem {
                    Label("搜索", systemImage: "magnifyingglass")
                }
                .tag(2)

            
            SettingView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
                .tag(3)
        }
        .accentColor(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
