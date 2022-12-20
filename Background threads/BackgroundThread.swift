//
//  BackgroundThread.swift
//  TestApp
//
//  Created by Bishalw on 10/18/22.
//

import SwiftUI

class BackgroundThreadViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func fetchData() {
        DispatchQueue.global(qos: .background).async {
            // download data in background thread
            let newData = self.downloadData()
            DispatchQueue.main.async {
                // update data in main thread
                self.dataArray = newData
            }
           
        }
       
    }
    
    func downloadData() -> [String]{
        var data:[String] = []
        
        for x in 0..<100 {
            data.append("\(x)")
            print(data)
        }
        return data
    }
    
}
struct BackgroundThread: View {
    @StateObject var vm = BackgroundThreadViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 10){
                Button(action: {
                    vm.fetchData()
                }, label: {
                    Text("Load Data")
                })
                .padding()
                .background(Color(.blue))
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct BackgroundThread_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundThread()
    }
}
