//
//  ConcurrencySwift.swift
//  TestApp
//
//  Created by Bishalw on 10/13/22.
//

import SwiftUI

class ConcurrencySwiftViewModel:ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addAuthor1() async {
        let author1 = "Author1 : "
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
       
        await MainActor.run(body: {
            let author2 = "Author2 : "
            self.dataArray.append(author2)
            
            let author3 = "Author3 : "
            self.dataArray.append(author3)
        })
        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1: "
        
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "Something2: "
            self.dataArray.append(something2)
        })
    }
    
}

struct ConcurrencySwift: View {
    
    @StateObject private var vm = ConcurrencySwiftViewModel()
    
    var body: some View {
        List{
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
            Task {
                await vm.addAuthor1()
            }
        }
    }
}

struct ConcurrencySwift_Previews: PreviewProvider {
    static var previews: some View {
        ConcurrencySwift()
    }
}
