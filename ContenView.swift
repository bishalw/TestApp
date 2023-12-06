//
//  ContenView.swift
//  TestApp
//
//  Created by Bishalw on 12/28/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = CombineSearchViewModel(postservice: PostService())
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            CombineSearch(searchText: searchText)
            ForEach(vm.searchResults, id: \.self) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct ContenView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
