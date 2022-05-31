//
//  Extensions.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation
import SwiftUI

extension CharacterSet {

    /// Characters valid in at least one part of a URL.
    ///
    /// These characters are not allowed in ALL parts of a URL; each part has different requirements. This set is useful for checking for Unicode characters that need to be percent encoded before performing a validity check on individual URL components.
    static var urlAllowedCharacters: CharacterSet {
        // Start by including hash, which isn't in any set
        var characters = CharacterSet(charactersIn: "#")
        // All URL-legal characters
        characters.formUnion(.urlUserAllowed)
        characters.formUnion(.urlPasswordAllowed)
        characters.formUnion(.urlHostAllowed)
        characters.formUnion(.urlPathAllowed)
        characters.formUnion(.urlQueryAllowed)
        characters.formUnion(.urlFragmentAllowed)

        return characters
    }
}

extension String {

    /// Converts a string to a percent-encoded URL, including Unicode characters.
    ///
    /// - Returns: An encoded URL if all steps succeed, otherwise nil.
    func encodedUrl() -> URL? {
        // Remove preexisting encoding,
        guard let decodedString = self.removingPercentEncoding,
            // encode any Unicode characters so URLComponents doesn't choke,
            let unicodeEncodedString = decodedString.addingPercentEncoding(withAllowedCharacters: .urlAllowedCharacters),
            // break into components to use proper encoding for each part,
            let components = URLComponents(string: unicodeEncodedString),
            // and reencode, to revert decoding while encoding missed characters.
            let percentEncodedUrl = components.url else {
            // Encoding failed
            return nil
        }

        return percentEncodedUrl
    }

}

extension UIDevice {

   class var isPhone: Bool {
       return UIDevice.current.userInterfaceIdiom == .phone
   }

   class var isPad: Bool {
       return UIDevice.current.userInterfaceIdiom == .pad
   }
    
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    /// Show the classic Apple share sheet on iPhone and iPad.
      ///
      func showShareSheet(with activityItems: [Any]) {
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
          return
        }

        let activityVC = UIActivityViewController(
          activityItems: activityItems,
          applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
          popoverController.sourceView = source.view
          popoverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                                y: source.view.bounds.midY,
                                                width: .zero, height: .zero)
          popoverController.permittedArrowDirections = []
        }
        source.present(activityVC, animated: true)
      }
}
