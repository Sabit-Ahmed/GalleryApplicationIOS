//
//  DetailView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 18/5/22.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var url: URL
    @State private var image: Image?
    @State private var isToastShown: Bool = false
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(.black)
            
            VStack {
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    AsyncImage(url: self.url) { image in
                        image.resizable()
                            .onAppear {
                                self.image = image
                            }
                            .scaleEffect(scale)
                            .gesture(MagnificationGesture().onChanged { val in
                                let delta = val / self.lastScaleValue
                                self.lastScaleValue = val
                                var newScale = self.scale * delta
                                if newScale < 1.0
                                {
                                    newScale = 1.0
                                }
                                scale = newScale
                            }.onEnded{val in
                                lastScaleValue = 1
                            })
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 10, minHeight: 0, maxHeight: 250)
                .cornerRadius(5)
                }
                
                ToastView()
            }
                
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // hides the "back" or previous view title button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                SaveIconView()
            }
        }
        
    }
    
    @ViewBuilder
    func BackButtonView() -> some View {
        Button {
            DispatchQueue.main.async {
                resetAllViewProperties()
            }
            
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                
                Text("Back")
            }
        }
    }
    
    @ViewBuilder
    func SaveIconView() -> some View {
        Button {
            DispatchQueue.main.async {
                savePhoto()
            }
            
        } label: {
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                
                Text("Save")
            }
        }
    }
    
    @ViewBuilder
    func ToastView() -> some View {
        Text("Successfully saved to photo gallery")
            .padding()
            .background(.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .opacity(isToastShown ? 1 : 0)

    }
    
    func showToastView() {
        withAnimation(.easeIn(duration: 1)) {
            isToastShown = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
            withAnimation(.easeOut(duration: 1)) {
                isToastShown = false
            }
        }
    }
    
    func resetAllViewProperties() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func savePhoto() {
        let image = self.image.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showToastView()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: URL(string: "https://images.unsplash.com/photo-1652600673200-1cbe0567b579?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzMjkwODJ8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTI4ODc2Nzk&ixlib=rb-1.2.1&q=80&w=1080")!)
            .environmentObject(PhotoViewModel())
    }
}
