//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var photoModel: PhotoViewModel
    @State var midY: Double = 0
    @State var isLastItem: Bool = false
    var gridItemLayout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            
            if photoModel.showPhotoList {
                ScrollView(.vertical) {
                    ZStack {
                        LazyVGrid(columns: gridItemLayout) {
                            
                            ForEach(0..<photoModel.listOfPhotoModels.count, id: \.self) { item in
                                NavigationLink {
                                    DetailView(url: (photoModel.listOfPhotoModels[item].urls?.regular?.encodedUrl())!)
                                } label: {
                                    WebImageView(url: (photoModel.listOfPhotoModels[item].urls?.regular?.encodedUrl())!, maxHeight: 150)
                                        .onAppear {
                                            if item == photoModel.listOfPhotoModels.count - 1 {
                                                isLastItem = true
                                            }
                                        }
                                        .onDisappear {
                                            if item == photoModel.listOfPhotoModels.count - 1 {
                                                isLastItem = false
                                            }
                                        }
                                }

                            }
                            
                        }
                        
                    }
                }
                .simultaneousGesture(
                    DragGesture().onChanged({
                        let isScrollDown = 0 < $0.translation.height
                        print(isScrollDown)
                        if !isScrollDown && isLastItem {
                            photoModel.getPhotos(linkType: "default")
                        }
                    })
                )
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
            photoModel.getPhotos(linkType: "default")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotoViewModel())
    }
}
