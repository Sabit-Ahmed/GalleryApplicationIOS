//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var photoModel: PhotoViewModel
    @State var showPhotoList: Bool = false
    
    var body: some View {
        ScrollView {
            LazyHStack {
                if showPhotoList {
                    ForEach(photoModel.listOfPhotoModels ?? []) { photo in
                        WebImageView(url: (photo.urls?.regular?.encodedUrl())!)
                    }
                }
            }
        }
        .onAppear {
            photoModel.getPhotos()
        }
        .onReceive(photoModel.$listOfPhotoModels) { response in
            showPhotoList = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
