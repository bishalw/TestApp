//
//  Photos.swift
//  TestApp
//
//  Created by Bishalw on 10/13/22.
//

import SwiftUI
import Photos

struct Photos: View {
    @State var images = [UIImage]()
    
    var body: some View {
        VStack {
            if images.count > 0 {
                Image(uiImage: images[0])
                Image(uiImage: images[1])
                Image(uiImage: images[2])
            } else {
                Text("No Images")
            }
        }
        .onAppear(perform: fetchPhotos)
    }
    
    func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let imageManager = PHImageManager.default()
        
        if fetchResult.count > 0 {
            for i in 0..<3 {
                imageManager.requestImage(for: fetchResult.object(at: i),
                                          targetSize: CGSize(width: 200, height: 200),
                                          contentMode: .aspectFill,
                                          options: nil) { (image, _) in
                    self.images.append(image!)
                }
            }
        }
    }
    
    struct Photos_Previews: PreviewProvider {
        static var previews: some View {
            Photos()
        }
    }
}
