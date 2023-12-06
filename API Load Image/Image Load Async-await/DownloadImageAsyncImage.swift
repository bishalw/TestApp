//
//  DownloadImageAsyncImageLoader.swift
//  TestApp
//
//  Created by Bishalw on 10/13/22.
//

import SwiftUI
import Combine
import Observation

struct DownloadImageAsyncImage: View {
    
    @StateObject var viewModel = DownloadImageAsyncImageViewModel()
    
    var body: some View {
        VStack{
            Text("Downloaded Image with Async")
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        
    }
}

class DownloadImageAsyncImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let url = URL(string: "https://picsum.photos/200")!
    
    init(){
        Task {
            await fetchImage()
        }
    }
    func fetchImage() async {
       let image = try? await downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data,response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data: data, response: response)
            return image
        } catch  {
            throw error
        }
        
    }
    func handleResponse(data:Data?, response: URLResponse) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        return image
        
    }
  
}
   

struct DownloadImageAsyncImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsyncImage()
    }
}
