//
//  DownloadWithAsyncAwait.swift
//  TestApp
//
//  Created by Bishalw on 11/29/23.
//

import SwiftUI

struct DownloadWithAsyncAwait: View {
    @StateObject var vm = DownloadWithAsyncAwaitViewModel()
    var body: some View {
        Text("Downloading Using Async/Await")
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

class DownloadWithAsyncAwaitViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    init()  {
        Task {
             try await getPosts()
        }
    }
    
    func getPosts() async throws   {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        let data = try await downloadData(fromURL: url)
        let stockData = try JSONDecoder().decode([PostModel].self, from: data)
    }
    
    func downloadData(fromURL url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return data
    }
    
    enum NetworkingError: Error {
        case badURLResponse(url: URL)
    }
}

#Preview {
    DownloadWithAsyncAwait(vm: DownloadWithAsyncAwaitViewModel())
}
