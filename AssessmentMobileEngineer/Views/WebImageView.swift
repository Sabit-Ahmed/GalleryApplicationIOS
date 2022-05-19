//
//  WebImageView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct WebImageView: View {
    
    var url: URL
    var maxHeight: CGFloat
    var body: some View {
        
        AsyncImage(url: self.url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: maxHeight)
        .cornerRadius(5)
        
        
    }
}

