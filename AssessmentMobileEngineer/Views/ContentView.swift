//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var photoModel: PhotoViewModel
    var gridItemLayout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            
            if photoModel.showPhotoList {
                ScrollView(.vertical) {
                    LazyVGrid(columns: gridItemLayout) {
                        
                        ForEach(photoModel.listOfPhotoModels ?? []) { photo in
                            WebImageView(url: (photo.urls?.regular?.encodedUrl())!)
                        }
                        
                    }
                }
                .padding(5)
                .navigationTitle("Photo Gallery")
                
            }
            else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
            }
        }
        .onAppear {
            photoModel.getPhotos()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotoViewModel())
    }
}
