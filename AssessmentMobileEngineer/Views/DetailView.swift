//
//  AlternativeDetailView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 19/5/22.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var uiImage: UIImage
    @State private var isToastShown: Bool = false
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(.black)
            
            VStack {
                GeometryReader { geometry in
                    ZoomableView(uiImage: uiImage, viewSize: geometry.size)
                }
                
                ToastView()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
                
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
        UIImageWriteToSavedPhotosAlbum(self.uiImage, nil, nil, nil)
        showToastView()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uiImage: UIImage(systemName: "checkmark")!)
            .environmentObject(PhotoViewModel())
    }
}
