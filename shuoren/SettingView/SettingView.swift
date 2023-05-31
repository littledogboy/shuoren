//
//  SettingView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            ForEach(1...3, id:\.self) { x in
                Text("\(x)")
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
