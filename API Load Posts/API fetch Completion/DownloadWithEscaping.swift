//
//  DownloadWithEscaping.swift
//  TestApp
//
//  Created by Bishalw on 10/24/22.
//

import SwiftUI
struct DownloadWithEscaping: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        VStack {
            Text("Downloading Using Escaping Closure")
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

class DownloadWithEscapingViewModel: ObservableObject {
    
    @Published var posts: [PostModel] = []
    typealias handler =  (_ data: Data?) -> ()
    
    init(){
        getPosts()
    }
    
    func getPosts(){

        guard let url = URL(string:"https://jsonplaceholder.typicode.com/posts") else { return }
        // if url = URL then downloadData
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data) else { return }
                DispatchQueue.main.async { [weak self ] in
                    self?.posts = newPosts
                }
                
            } else {
                print("No data returned")
            }
        }
        
    }
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error downloading data")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }
    
    func downloadData2(fromURL url: URL) async throws -> Data {
        let (data, response ) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode
        }
        
        return data
    }
    
    enum NetworkError: Error {
        case badStatusCode
    }
    
}



struct DownloadWithEscaping_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscaping()
    }
}
