//
//  DownloadWithCombine.swift
//  TestApp
//
//  Created by Bishalw on 12/19/22.
//

import SwiftUI
import Combine

struct DownloadWithCombine: View {
    @StateObject var vm = DownloadingWithCombineViewModel()
    var body: some View {
        VStack {
            Text("Download Using Combine")
            List {
                ForEach(vm.posts, content: { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
        }
    }
}

class DownloadingWithCombineViewModel: ObservableObject {
    @Published var posts:[PostModel] = []
    var subscription: AnyCancellable?
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        subscription = downloadData(url: url)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { returnedPosts in
                self.posts = returnedPosts
            })
    
    }

    func downloadData(url: URL) -> AnyPublisher<Data, Error> {
            URLSession
            .shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                    // check the status code of the response
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .eraseToAnyPublisher()
        }
       
}

struct DownloadWithCombine_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombine()
    }
}
