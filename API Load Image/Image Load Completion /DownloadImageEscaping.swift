//
//  DownloadImageEscaping.swift
//  TestApp
//
//  Created by Bishalw on 12/20/22.
//

import SwiftUI

struct DownloadImageEscaping: View {
    @StateObject private var viewModel = DownloadImageEscapingViewModel()
    var body: some View {
        VStack{
            Text("Downloaded Image with Completion Handler")
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        
    }
}

class DownloadImageEscapingViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let url = URL(string: "https://picsum.photos/200")!
    
    init(){
      fetchImage()
    }
    func fetchImage(){
        downloadWithEscaping { [weak self] image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
               
            }
        }
    }
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()){
        let request = URLRequest(url: url)
         let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in

            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    completionHandler(nil, error)
                    return
            }
            completionHandler(image,nil)
        }
        dataTask.resume()
    }
}

struct DownloadImageEscaping_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageEscaping()
    }
}
