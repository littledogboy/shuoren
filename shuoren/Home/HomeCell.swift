//
//  HomeCell.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/3.
//

import SwiftUI
import Kingfisher

struct HomeCell: View {
    @State var item: HomeItem?

    var body: some View {
        
        GeometryReader { geo in
            
            ZStack(alignment: .bottomTrailing) {
                // imageView
                if let img = item?.img {
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL(string: urlString!)
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(kReferer, forHTTPHeaderField: "referer")
                        return r
                    }
                                        
                    KFImage.url(url)
                        .requestModifier(modifier)
                        .cacheOriginalImage()
                        .fade(duration: 0.25)
                        .cancelOnDisappear(true)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                
                // model
                let radius = 10.0
                let leadPadding = 3.0
                let trailingPadding = 2.0
                
                if let model = item?.model, !model.isEmpty {
                    Text(model)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .padding(EdgeInsets(top: 2, leading: leadPadding, bottom: 2, trailing: trailingPadding))
                        .padding(.leading, leadPadding)
                        .padding(.trailing, trailingPadding)
                        .background(.black.opacity(0.44))
                        .cornerRadius(radius, corners: [.topLeft, .bottomLeft])
                        .offset(x: 0, y: -80)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    // title
                    let titleVPadding = 4.0
                    let titleHPadding = 3.0
                    if let title = item?.title {
                        Text(title)
                            .padding(EdgeInsets(top: titleVPadding,
                                                leading: titleHPadding,
                                                bottom: titleVPadding,
                                                trailing: titleHPadding))
                            .frame(width:geo.size.width, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .background(.white)
                            .foregroundColor(Color(hex: "#666666"))
                            .font(.system(size: 13))
                            .lineLimit(2)
                    }
                    
                    // line & time
                    if let time = item?.time, !time.isEmpty {
                        let linePadding = Pixel(.mobile, 6)
                        Divider()
                            .padding(EdgeInsets(top: 0,
                                                leading: linePadding,
                                                bottom: 0,
                                                trailing: linePadding))
                        
                        let labelLeading = Pixel(.mobile, 10)
                        let labelBottom = Pixel(.mobile, 6)
                        Label(time, systemImage: "clock")
                            .background(.white)
                            .foregroundColor(Color(hex: "#888686"))
                            .font(.system(size: Pixel(.cssFont, 14)))
                            .padding(EdgeInsets(top: 0,
                                                leading: labelLeading,
                                                bottom: labelBottom,
                                                trailing: 0))
                        
                    }
                }
                .background(.white)
            }
        }
    }
}

struct HomeCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeCell()
    }
}
