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
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 100)
            .cornerRadius(3)
            .transition(.fade)
        
    }
}

