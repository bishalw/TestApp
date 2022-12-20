//
//  ContentView.swift
//  TestApp
//
//  Created by Bishalw on 8/29/22.
//

import SwiftUI


struct TestingStateView: View {
    
    @State var count: Int  = 0
    
    @StateObject var state = ContentViewStateObject()
    @ObservedObject var state2 = ContentViewStateObject()
    var body: some View {
//        VStack {
//           Text("Count: \(count)")
//           Button("Button", action: {
//               count += 1
//           })
//
//        }
//        VStack {
//            Text("Count: \(state.count)")
//           Button("Button", action: {
//               let newState = ContentViewStateObject()
//               newState.count = state.count + 1
//               state = newState
//               print("state: \(state.count)")
//           })
//
//        }
//        VStack {
//            Text("Count: \(state2.count)")
//            TextField("Test", text: .init(get: {
//                return state2.textFIeldText
//            }, set: { newValue in
//                state2.textFIeldText = newValue
//            }))
//           Button("Button", action: {
//               state2.count += 1
//           })
//
//        }
        VStack {
            Text("Count: \(state.count)")
            TextField("Test", text: .init(get: {
                return state.textFIeldText
            }, set: { newValue in
                state2.textFIeldText = newValue
            }))
           Button("Button", action: {
               state.count += 1
           })

        }
        .padding()
    }
}

class ContentViewStateObject: ObservableObject {
    
    @Published var count: Int = 0
    @Published var textFIeldText: String = ""

    
}

struct TestingStateView_Previews: PreviewProvider {
    static var previews: some View {
        TestingStateView()
    }
}


