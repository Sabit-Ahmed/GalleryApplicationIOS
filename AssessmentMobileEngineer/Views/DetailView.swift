//
//  AlternativeDetailView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 19/5/22.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var uiImage: UIImage
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
                ShareIconView()
            }
            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                SaveIconView()
//            }
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
                
//                Text("Back")
            }
        }
    }
    
    @ViewBuilder
    func SaveIconView() -> some View {
        Button {
            DispatchQueue.main.async {
                saveImage()
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
    func ShareIconView() -> some View {
        Button {
            DispatchQueue.main.async {
                showShareSheet(with: [uiImage])
            }
            
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.blue)
                
//                Text("Share")
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
    
    func resetAllViewProperties() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self.uiImage, nil, nil, nil)
        showToastView()
    }
    
    func shareImage() {
        //
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
}

struct AlternativeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uiImage: .constant(UIImage(systemName: "square.and.arrow.up")!))
            .environmentObject(PhotoViewModel())
    }
}
