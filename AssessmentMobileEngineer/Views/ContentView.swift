//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var photoModel: PhotoViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if photoModel.showPhotoList {
                    ForEach(photoModel.listOfPhotoModels ?? []) { photo in
                        WebImageView(url: (photo.urls?.regular?.encodedUrl())!)
                    }
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                }
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
