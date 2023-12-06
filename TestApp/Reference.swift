//
//  Reference.swift
//  TestApp
//
//  Created by Bishalw on 8/21/23.
//

import Foundation
import SwiftUI
@MainActor final class Group: ObservableObject {
    @Published var people = [Person]()
}

struct Person: Identifiable, Equatable {
    let id = UUID()  // Adding a unique identifier
    var name: String
    var age: Int
    // ... Add more properties as needed ...
}

struct ContentView: View {
    @StateObject var group: Group = Group()

    var body: some View {
        NavigationView {
            VStack {
                Button("Add People") {
                    for i in 0...2 {
                       let newPerson = (Person(name: "Person\(i)", age: 20+i))
                        print("Adding \(newPerson.name) to the group.")
                        group.people.append(newPerson)
                    }
                }
                Form {
                    ForEach(group.people.indices, id: \.self) { index in
                        NavigationLink(group.people[index].name, destination: SomeOtherView(person: $group.people[index])).onTapGesture {
                            print("Navigating to \(group.people[index].name)'s details.")
                        }
                    }
                }
            }
        }
    }
}
struct SomeOtherView: View {
    @Binding var person: Person
    
    var body: some View {
        VStack {
            TextField("Name", text: $person.name)
                           .onChange(of: person.name) { newValue in
                               print("Name changed to \(newValue).")
                           }
                       Stepper("Age: \(person.age)", value: $person.age)
                           .onChange(of: person.age) { newValue in
                               print("Age changed to \(newValue).")
                           }
        }
        .padding()
    }
}
