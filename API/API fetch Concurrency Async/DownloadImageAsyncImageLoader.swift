//
//  DownloadImageAsyncImageLoader.swift
//  TestApp
//
//  Created by Bishalw on 10/13/22.
//

import SwiftUI
class DownloadImageAsyncImageloader {
    let url = URL(string: "https://picsum.photos/200")!
    

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
class DownloadImageAsyncImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageloader()
    init(){
        download()
    }
    func download(){
        loader.downloadWithEscaping {[weak self] image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
               
            }
        }
    }
}


struct DownloadImageAsyncImageLoader: View {
    
    @StateObject private var viewModel = DownloadImageAsyncImageViewModel()
    
    var body: some View {
        ZStack{
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        
    }
}

struct DownloadImageAsyncImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsyncImageLoader()
    }
}
