//
//  ZoomableView.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 19/5/22.
//

import SwiftUI

struct ZoomableView: UIViewRepresentable {
    let uiImage: UIImage
    let viewSize: CGSize

    private enum Constraint: String {
        case top
        case leading
    }
    
    private var minimumZoomScale: CGFloat {
        let widthScale = viewSize.width / uiImage.size.width
        let heightScale = viewSize.height / uiImage.size.height
        return min(widthScale, heightScale)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = minimumZoomScale * 50
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.bouncesZoom = true
        
        let imageView = UIImageView(image: uiImage)
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        topConstraint.identifier = Constraint.top.rawValue
        topConstraint.isActive = true
        
        let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        leadingConstraint.identifier = Constraint.leading.rawValue
        leadingConstraint.isActive = true
        
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        guard let imageView = scrollView.subviews.first as? UIImageView else {
            return
        }
        
        // Inject dependencies into coordinator
        context.coordinator.zoomableView = imageView
        context.coordinator.imageSize = uiImage.size
        context.coordinator.viewSize = viewSize
        let topConstraint = scrollView.constraints.first { $0.identifier == Constraint.top.rawValue }
        let leadingConstraint = scrollView.constraints.first { $0.identifier == Constraint.leading.rawValue }
        context.coordinator.topConstraint = topConstraint
        context.coordinator.leadingConstraint = leadingConstraint

        // Set initial zoom scale
        scrollView.zoomScale = minimumZoomScale
    }
}

// MARK: - Coordinator

extension ZoomableView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        var zoomableView: UIView?
        var imageSize: CGSize?
        var viewSize: CGSize?
        var topConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            zoomableView
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let zoomScale = scrollView.zoomScale
            print("zoomScale = \(zoomScale)")
            guard
                let topConstraint = topConstraint,
                let leadingConstraint = leadingConstraint,
                let imageSize = imageSize,
                let viewSize = viewSize
            else {
                return
            }
            topConstraint.constant = max((viewSize.height - (imageSize.height * zoomScale)) / 2.0, 0.0)
            leadingConstraint.constant = max((viewSize.width - (imageSize.width * zoomScale)) / 2.0, 0.0)
        }
    }
}
