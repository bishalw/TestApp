//
//  FetchOnSearch.swift
//  TestApp
//
//  Created by Bishalw on 1/14/23.
//

import SwiftUI
import Combine

struct FetchOnSearch: View {
    @StateObject private var vm = FetchOnSearchViewModel(postservice: PostService())
    
    
    var body: some View {
        SearchTextView(searchText: $vm.searchText )
            .frame(width: 350, height: 40)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.blue, lineWidth: 1))
        switch vm.postListState {
        case .loading:
            VStack{
                Spacer()
                ProgressView()
                Spacer()
            }
        case .loaded(posts: let posts):
            List {
                ForEach(posts, content: { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
            }
        case .error:
            Text("Error")
        }
      
    }
}

enum PostListState {
    case loading
    case loaded(posts:[PostModel])
    case error
}

class FetchOnSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchedVal: String = ""
    @Published var postListState: PostListState = .loading
    var subscription = Set<AnyCancellable>()
    let postservice: PostService
    
    init(postservice: PostService) {
        self.postservice = postservice
        getPosts()
        addSubscribers()
    }
    
    func addSubscribers(){
        $searchText
            .throttle(for: .seconds(2.5), scheduler: RunLoop.main, latest: true)
            .sink { _ in
                self.getPosts()
            }
            .store(in: &subscription)
    }
    
    func getPosts(){
        self.postListState = .loading
        postservice.getData(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
           .decode(type: [PostModel].self, decoder: JSONDecoder())
           .receive(on: DispatchQueue.main)
           .delay(for: 0.5, scheduler: RunLoop.main)
           .sink(receiveCompletion: { completion in
               print(completion)
           }, receiveValue: { returnedPosts in
               self.postListState = .loaded(posts: returnedPosts)
               
           })
           .store(in: &subscription)
    }
    
}


struct SearchView: View {
    @Binding var searchText: String
    var body: some View {
        TextField("Search", text: $searchText)
    }
}


struct FetchOnSearch_Previews: PreviewProvider {
    static var previews: some View {
        FetchOnSearch()
    }
}
