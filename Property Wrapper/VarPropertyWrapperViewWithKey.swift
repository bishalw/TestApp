//
//  VarPropertyWrapper.swift
//  TestApp
//
//  Created by Bishalw on 12/5/23.
//

import SwiftUI
extension FileManager {
    static func documentsPath(_ key: String) -> URL? {
        guard let documentPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentPathURL.appendingPathComponent("\(key).txt", conformingTo: .fileURL)
    }
}

@propertyWrapper
public struct Save: DynamicProperty {
    @State private var title: String = ""
    let key: String?
    
    public var wrappedValue: String {
        get {
            title
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    public init(key: String ) {
        self.key = key
        if let url = FileManager.documentsPath(key) {
                
                do {
                    let savedValue = try String(contentsOf: url, encoding: .utf8)
                    title = savedValue
                    print("Read Successfully")
                } catch {
                    title = "Starting text"
                    print("Error reading from URL: \(error)")
                }
            }
        }
   
    public func save(newValue: String) {
           if let url = FileManager.documentsPath(key ?? "") {
               do {
                   try newValue.write(to: url, atomically: false, encoding: .utf8)
                   title = newValue
                   print("Saved successfully")
               } catch {
                   print("Unable to save: \(error)")
               }
           }
       }
}


struct VarPropertyWrapperViewWithKey: View {
    
  
    @Save(key:"test") private var title3: String
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title3).font(.largeTitle)
            
            Button("Click me 1") {
                title3 = "title1"
            }
            Button("Click me 2") {
                title3 = "title2"
            }
        }
        
    }
        
}

//#Preview {
//    VarPropertyWrapperView(title: <#Save#>, title2: <#Save#>)
//}
