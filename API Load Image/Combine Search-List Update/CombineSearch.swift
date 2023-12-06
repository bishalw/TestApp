//
//  CombineSearch.swift
//  TestApp
//
//  Created by Bishalw on 12/21/22.
//

import SwiftUI
import Combine

//struct CombineSearch: View {
//    @StateObject private var vm = CombineSearchViewModel(postservice: PostService())
//    @State var searchText: String
//    var body: some View {
//        VStack {
//            TextField("Enter search query", text: .constant(""))
//            Text("Hello")
//            frame(maxHeight: .infinity)
//
//            ForEach(vm.searchResults) { post in
//                VStack(alignment: .leading) {
//                    Text(post.title)
//                        .font(.headline)
//                    Text(post.body)
//                        .foregroundColor(.gray)
//                }.frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//    }
//
//}

struct SearchTextView: View {
    
    @Binding var searchText: String
    var body: some View {
        TextField("Search by name or symbol...", text: $searchText)
            .onTapGesture {
                UIApplication.shared.endEditing()
                searchText = ""
            }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct CombineSearch: View {
    @StateObject private var vm = CombineSearchViewModel(postservice: PostService())
    var body: some View {
        VStack {
            SearchTextView(searchText: $vm.searchText)
            
            List {
                ForEach(vm.searchResults, content: { post in
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
protocol NetworkService {
    func getData(url: URL) -> AnyPublisher<Data, Error>
}

class PostService: NetworkService {
    
    func getData(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let httpRespone = response as? HTTPURLResponse,
                      (200...299).contains(httpRespone.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
}
class CombineSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    @Published var searchResults: [PostModel] = []
    var posts:[PostModel] = []
    var subscription = Set<AnyCancellable>()
    let postservice: PostService
    init(postservice: PostService) { // dependency and initliazed varaible
        
        self.postservice = postservice
        getPosts() // gets Posts and stores in the posts:[PostModel]
        addSubscribers()
    }
    
    func addSubscribers(){
          $searchText
              .map { searchText in
                  // check and filter posts based on search results
//                  self.searchResults = self.posts.filter { post in
//                      return post.title.contains(searchText) || post.body.contains(searchText)
//                  }
                  guard !searchText.isEmpty else {return self.posts}
                    return self.posts.filter { post in
                        return post.title.lowercased().contains(searchText.lowercased()) || post.body.lowercased().contains(searchText.lowercased())
                  }
              }
              .receive(on: RunLoop.main)
              .sink(receiveCompletion: { completion in
                  print("completion")
              }, receiveValue: { filteredPosts in
                self.searchResults = filteredPosts
              })
              .store(in: &subscription)
      }
    
    // Decodes data
    func getPosts(){
         postservice.getData(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { returnedPosts in
                self.posts = returnedPosts
                self.searchResults = returnedPosts
            })
            .store(in: &subscription)
    }
    
    
}

struct CombineSearch_Previews: PreviewProvider {
    static var previews: some View {
        CombineSearch()
    }
}
