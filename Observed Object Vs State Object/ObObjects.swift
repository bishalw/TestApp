//
//  ObObjects.swift
//  TestApp
//
//  Created by Bishalw on 10/14/22.
//

import SwiftUI
import SwiftUI



class UserViewModel2: ObservableObject {

    @Published var user: User

    init(user: User) {
        self.user = user
    }
}

struct User2 {
    var name: String
}
struct UserView2: View {

    @ObservedObject var userViewModel = UserViewModel(user: User(name: "Sean"))

    var body: some View {
        VStack{
            Text("UserView Observable Object")
                .padding()
            HStack{
                Text("Press me: ")
                    .lineSpacing(1.0)
                Text(userViewModel.user.name)
                    .onTapGesture {
                        userViewModel.user.name += "+"
                    }
                    .padding()
                    .border(.red)
            }
        }
    }
}

struct ObObjects: View {
    @State var count = 0
    var body: some View { // bigger view
        VStack {
            UserView2()
                .padding()
                .border(.green)
            VStack{
                Text("Main View")
                Button {
                    count += 1
                } label: {
                    Text("\(count)")
                }
                .padding()
               
            }
            .padding()
            .border(.yellow)
            
        }
                
    }
}

