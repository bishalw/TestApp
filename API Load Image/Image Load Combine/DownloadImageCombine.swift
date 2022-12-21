//
//  DownloadImageCombine.swift
//  TestApp
//
//  Created by Bishalw on 12/20/22.
//

import SwiftUI
import Combine

struct DownloadImageCombine: View {
    @StateObject private var viewModel = DownloadImageCombineViewModel()
    
    var body: some View {
        VStack{
            Text("Downloaded Image with Combine")
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
    }
}

class DownloadImageCombineViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    var cancellables = Set<AnyCancellable>()
    let url = URL(string: "https://picsum.photos/200")!
    
    init(){
        fetchImage()
    }
    func fetchImage(){
        downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
        
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

struct DownloadImageCombine_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageCombine()
    }
}
