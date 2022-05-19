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
    @State private var zoomed:Bool = false
    @State var scale: CGFloat = 1.0
    @State var isTapped: Bool = false
    @State var pointTaped: CGPoint = CGPoint.zero
    @State var draggedSize: CGSize = CGSize.zero
    @State var previousDraged: CGSize = CGSize.zero
    
    var body: some View {
        
        GeometryReader { geo in
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
                                .gesture(TapGesture(count: 2)
                                    .onEnded({ value in
                                        self.isTapped = !self.isTapped
                                    })
                                    .simultaneously(with: DragGesture(minimumDistance: 0, coordinateSpace: .global)  .onChanged { (value) in
                                        self.pointTaped = value.startLocation
                                        self.draggedSize = CGSize(width: value.translation.width + self.previousDraged.width, height: value.translation.height + self.previousDraged.height)
                                    }
                                    .onEnded({ (value) in
                                        let offSetWidth = (geo.frame(in :.global).maxX * self.scale) - (geo.frame(in :.global).maxX) / 2
                                        let newDraggedWidth = self.previousDraged.width * self.scale
                                        if (newDraggedWidth > offSetWidth){
                                            self.draggedSize = CGSize(width: offSetWidth / self.scale, height: value.translation.height + self.previousDraged.height)
                                        }
                                        else if (newDraggedWidth < CGFloat(-offSetWidth)){
                                            self.draggedSize = CGSize(width:  CGFloat(-offSetWidth) / self.scale, height: value.translation.height + self.previousDraged.height)
                                        }
                                        else{
                                            self.draggedSize = CGSize(width: value.translation.width + self.previousDraged.width, height: value.translation.height + self.previousDraged.height)
                                        }
                                        self.previousDraged =  self.draggedSize
                                    })))

                                .gesture(MagnificationGesture()
                                    .onChanged { (value) in
                                        self.scale = value.magnitude

                                }.onEnded { (val) in
                                    //self.scale = 1.0
                                    self.scale = val.magnitude
                                    }
                            )
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 10, minHeight: 0, maxHeight: 350)
                        .cornerRadius(5)
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
