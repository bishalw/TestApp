//
//  Tessssst.swift
//  TestApp
//
//  Created by Bishalw on 12/6/23.
//

import SwiftUI

extension FileManager {
    static func documentsPath(with id: String) -> URL {
        guard let documentPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Document Directory not found")
        }
        return documentPathURL.appendingPathComponent("save2_\(id).txt", isDirectory: false)
    }
}

@propertyWrapper
public struct Save: DynamicProperty {
    
    @State private var title: String = "Starting title"
    private let fileURL: URL
    public var wrappedValue: String {
        get {
            title
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    public init() {
        let userDefaultsKey = "Save2PropertyWrapperKey"
        
        // Creating/Generating ID procedure | refactor later to seperate function
        let id = UserDefaults.standard.string(forKey: userDefaultsKey)
            ?? String(UUID().uuidString.prefix(8))
        UserDefaults.standard.set(id, forKey: userDefaultsKey)

        self.fileURL = FileManager.documentsPath(with: id)

        // Try and read from file or set a default value
        guard let savedValue = try? String(contentsOf: fileURL, encoding: .utf8) else {
            self.title = "Starting text"
            print("Error reading from URL or file not found")
            return
        }

        self.title = savedValue
        print("Read Successfully")
    }
    private func retrieveOrGenerateID() -> String {
            let userDefaultsKey = "Save2PropertyWrapperKey"
            if let storedId = UserDefaults.standard.string(forKey: userDefaultsKey) {
                return storedId
            } else {
                let newId = String(UUID().uuidString.prefix(8))
                UserDefaults.standard.set(newId, forKey: userDefaultsKey)
                return newId
            }
        }
    private func save(newValue: String) {
           do {
               try newValue.write(to: fileURL, atomically: true, encoding: .utf8)
               print("Saved successfully")
           } catch {
               print("Unable to save: \(error)")
           }
    }
}
struct VarPropertyWrapperView: View {
    
    @Save private var title: String
    @Save private var title2: String
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title).font(.largeTitle)
            
            Button("Click me 1") {
                title = "title1"
                print(NSHomeDirectory())
            }
            Button("Click me 2") {
                title = "title2"
            }
        }
    }
        
}

#Preview {
    VarPropertyWrapperView()
}
