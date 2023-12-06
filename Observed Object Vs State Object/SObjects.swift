//
//  SOstates.swift
//  TestApp
//
//  Created by Bishalw on 10/14/22.
//

import SwiftUI

class UserViewModel: ObservableObject {

    @Published var user: User

    init(user: User) {
        self.user = user
    }
}

struct User {
    var name: String
}
struct UserView: View {

//    @StateObject var userViewModel : UserViewModel
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        VStack{
            Text("UserView State Object")
            Text("Child View")
                .padding()
            HStack{
                Text("Press -> ")
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

struct SObjects: View {
    @State var count = 0
    @StateObject var userViewModel = UserViewModel(user: User(name: "sean")) // parent is holding the reference even though its a  User view is a ObservedObject
    var body: some View {
        VStack {
            UserView(userViewModel: userViewModel)
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
        }
        .padding()
        .border(.yellow)
    }
        
}

