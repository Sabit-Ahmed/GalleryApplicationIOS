//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var photoModel: PhotoViewModel
    @State private var midY: Double = 0
    @State private var isLastItem: Bool = false
    @State private var isImageTapped: Bool = false
    @State var isImageLoaded: Bool = false
    var gridItemLayout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            
            if photoModel.showPhotoList {
                ScrollView(.vertical) {
                    ZStack {
                        LazyVGrid(columns: gridItemLayout) {
                            
                            ForEach(0..<photoModel.listOfImages.count, id: \.self) { item in
                                NavigationLink (
                                destination: DetailView(uiImage: photoModel.listOfImages[item]),
                                isActive: $isImageTapped,
                                label: {
                                    
                                    Image(uiImage: photoModel.listOfImages[item])
                                        .resizable()
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                                        .cornerRadius(5)
                                        .onAppear {
                                            DispatchQueue.main.async {
                                                if item == photoModel.listOfImages.count - 1 {
                                                    isLastItem = true
                                                }
                                            }
                                        }
                                        .onDisappear {
                                            DispatchQueue.main.async {
                                                if item == photoModel.listOfImages.count - 1 {
                                                    isLastItem = false
                                                }
                                            }
                                        }
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                isImageTapped = true
                                            }
                                        }
                                    
                                })

                            }
                            
                        }
                        
                    }
                }
                .simultaneousGesture(
                    DragGesture().onChanged({
                        let isScrollDown = 0 < $0.translation.height
                        print(isScrollDown)
                        if !isScrollDown && isLastItem {
                            photoModel.getApiResponse(linkType: "default")
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
            photoModel.getApiResponse(linkType: "default")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PhotoViewModel())
    }
}
