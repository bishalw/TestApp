//
//  DownloadingWithFuture.swift
//  TestApp
//
//  Created by Bishalw on 12/19/22.
//

import SwiftUI
import Combine

struct DownloadingWithFuture: View {
    @StateObject var vm = DownloadingWithFutureViewModel()
    
    var body: some View {
        VStack {
            Text("Downloading Using Future")
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

class DownloadingWithFutureViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    var subscription: AnyCancellable?
    init() {
        getPosts()
    }
    func getPosts() {
      guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
            subscription = fetchPosts(url: url)
            .receive(on: DispatchQueue.main)
            .flatMap(decodePosts).sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Successfully fetched and decoded the posts!")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: { returnedPosts in
        self.posts = returnedPosts
      })
    }

    func fetchPosts(url: URL) -> Future<Data, Error> {
      return Future { promise in
        URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
            return promise(.failure(error))
          }

          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            return promise(.failure(URLError(.badServerResponse)))
          }

          guard let data = data else {
              return promise(.failure(URLError(.badServerResponse)))
          }

          return promise(.success(data))
        }.resume()
      }
    }

    func decodePosts(data: Data) -> Future<[PostModel], Error> {
      return Future { promise in
        do {
          let posts = try JSONDecoder()
                .decode([PostModel].self, from: data)
          return promise(.success(posts))
        } catch {
          return promise(.failure(error))
        }
      }
    }
   
    
}

struct DownloadingWithFuture_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingWithFuture()
    }
}
