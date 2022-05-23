# AssessmentMobileEngineer

### Installation:
1. Clone the repository
2. Install CocoaPods
3. Install the podfile by `pod install`


### How to install podfile:

1. Install Cocoapods. It is a SDK package manager like npm. It has podfile where the list of sdks are written with version numbers. It also has a lockfile.

2. Navigate to the XCode project

3. Generate the pod file (`pod init`)

4. Edit the podfile by adding pods (list of sdks) to manage

5. Install the pods (`pod install`)


Note:
1. `pod install` for install or delete any pod (sdks and libraries)
2. `pod update` to update the versions of the included pods.


### Important links followed step by step in this project:

1. Grid LayOut (LazyVGrid or LazyHGrid):

* https://www.appcoda.com/learnswiftui/swiftui-gridlayout.html

2. Detect scroll direction (used to implement infinite scroll):

* https://stackoverflow.com/questions/59342384/how-to-detect-scroll-direction-programmatically-in-swiftui-scrollview (Den's answer, Marc T.'s answer is also helpfull)

3. Saving a SwiftUI view to Photo Library: 

* https://swdevnotes.com/swift/2022/saving-a-swiftui-view-to-photos/
* https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image

4. Pinch to zoom implementation with UIViewRepresentable:

* https://stackoverflow.com/questions/58341820/isnt-there-an-easy-way-to-pinch-to-zoom-in-an-image-in-swiftui (antineoSE's answer)

5. Use swift Codable protocol:

* https://www.codingem.com/json-parsing-with-codable-in-swift/
* https://stackoverflow.com/questions/51192270/swift-codable-with-reserved-word

6. Cache/download image:

* https://stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui (without AsyncImage)
* https://stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui (with AsyncImage)

7. Share files with SwuiftUI:

* https://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
* https://stackoverflow.com/questions/56819360/swiftui-exporting-or-sharing-files
