//
//  VarPropertyWrapper.swift
//  TestApp
//
//  Created by Bishalw on 12/5/23.
//

import SwiftUI

struct VarPropertyWrapper: View {
    @State private var title:String = "Starting Title"
    var body: some View {
        VStack {
            Text(title).font(.largeTitle)
            
            Button("Click me 1") {
                title = "title 1"
            }
            Button("Click me 2") {
                title = "title 2"
            }
        }
        
    }
}

#Preview {
    VarPropertyWrapper()
}
