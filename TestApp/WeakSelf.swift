//
//  WeakSelf.swift
//  TestApp
//
//  Created by Bishalw on 10/24/22.
//

import SwiftUI

struct WeakSelf: View {
    
    @AppStorage("count") var count: Int?
    
    init(){
        count = 0
    }
    
    var body: some View {
        NavigationView {
            NavigationLink("Navigate", destination:
                                        WeakSelfSecondScreen())
                .navigationTitle("Screen 1 ")
        }
        .overlay(
            Text("\(count ?? 0)")
                .font(.largeTitle)
                .padding()
                .background(Color.green.cornerRadius(10))
            ,alignment: .topTrailing
        )
    }
}
struct WeakSelfSecondScreen: View {
    
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    
    var body: some View {
        VStack{
            Text("Second View")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            if let data = vm.data {
                Text(data)
            }
        }
        
    }
}
class WeakSelfSecondScreenViewModel: ObservableObject {
    
    @Published var data: String? = nil
    
    init() {
        print("INITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("DEINITIALIZE NOW")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData(){
        // until 500 seconds complete class will not deinitialize, the self will always stay alive
        DispatchQueue.main.asyncAfter(deadline: .now() + 500){ [weak self] in
            self?.data = "NEW DATA"
        }
    }
    func getData2(){
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 500){
            self.data = "NEW DATA" // will never be deallocated
        }
        
    }
}

struct WeakSelf_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelf()
    }
}
