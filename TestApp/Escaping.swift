//
//  Escaping.swift
//  TestApp
//
//  Created by Bishalw on 10/24/22.
//

import SwiftUI

class EscapingViewModel: ObservableObject {
    
    @Published var text: String = "Hello"
    
    func getData() {
        
        
        downloadData5 { [weak self] (returnedResult) in
            self?.text = returnedResult.data
        }
        
        
    }
    
    func downloadData() -> String {
        return "New Data"
    }
    
    func downloadData2(completeionHandler: (_ data: String) -> ()) {
        
        completeionHandler("New data!")
    }
    
    func downloadData3(completeionHandler: @escaping (_ data: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completeionHandler("New data!")
        }
        
    }
    func downloadData4(completeionHandler: @escaping  (DownloadResult) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let result = DownloadResult(data: "New data")
            completeionHandler(result)
        }
        
    }
    func downloadData5(completeionHandler: @escaping (DownloadCompleteion)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let result = DownloadResult(data: "New data")
            completeionHandler(result)
        }
        
    }
   
}

typealias DownloadCompleteion = (DownloadResult) -> ()

struct DownloadResult {
    let data: String
}
struct Escaping: View {
    
    @StateObject var vm = EscapingViewModel()
    
    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
    }
}

struct Escaping_Previews: PreviewProvider {
    static var previews: some View {
        Escaping()
    }
}
