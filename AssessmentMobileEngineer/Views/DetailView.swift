//
//  DetailView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 18/5/22.
//

import SwiftUI

struct DetailView: View {
    
    var url: URL
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(.black)
            
            WebImageView(url: url, maxHeight: 250)
                
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: URL(string: "https://images.unsplash.com/photo-1652600673200-1cbe0567b579?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjkwODJ8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI4ODc2Nzk&ixlib=rb-1.2.1&q=80&w=1080")!)
            .environmentObject(PhotoViewModel())
    }
}
