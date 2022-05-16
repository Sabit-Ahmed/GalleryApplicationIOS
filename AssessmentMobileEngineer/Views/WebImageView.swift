//
//  WebImageView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageView: View {
    
    var url: URL
    var width: CGFloat = 100
    var height: CGFloat = 170
    
    var body: some View {
        
        WebImage(url: self.url)
            .onFailure(perform: { error in
                // Error
            })
            .playbackRate(1.5) // Playback speed rate
            .playbackMode(.normal)
            .placeholder(content: {
                ProgressView()
                    .progressViewStyle(.circular)
//                LocalAnimatedImageView()
            })
            .resizable()
            .frame(width: self.width, height: self.height, alignment: .center)
            .cornerRadius(2)
            .transition(.fade)
        
    }
}

