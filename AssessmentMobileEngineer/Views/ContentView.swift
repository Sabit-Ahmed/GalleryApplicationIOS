//
//  ContentView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var service: ViewModel
    @State private var midY: Double = 0
    @State private var isLastItem: Bool = false
    private var gridItemLayout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            
            if service.showPhotoList {
                ScrollView(.vertical) {
                    ZStack {
                        LazyVGrid(columns: gridItemLayout) {
                            
                            ForEach(0..<service.listOfImages.count, id: \.self) { item in
                                NavigationLink (
                                destination: DetailView(uiImage: service.listOfImages[item]),
                                label: {
                                    
                                    Image(uiImage: service.listOfImages[item])
                                        .resizable()
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                                        .cornerRadius(5)
                                        .onAppear {
                                            DispatchQueue.main.async {
                                                if item == service.listOfImages.count - 1 {
                                                    isLastItem = true
                                                }
                                            }
                                        }
                                        .onDisappear {
                                            DispatchQueue.main.async {
                                                if item == service.listOfImages.count - 1 {
                                                    isLastItem = false
                                                }
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
                            service.getResponseFromRemote(linkType: "default")
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
        .onReceive(service.$listOfImages) { _ in
            if !service.showPhotoList {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                    withAnimation {
                        service.showPhotoList = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel(appConfig: AppConfig(appName: "AssessmentMobileEngineer", appFlavor: "dev")))
    }
}
