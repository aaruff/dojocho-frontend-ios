//
//  ContentView.swift
//  dojocho-frontend-ios
//
//  Created by Anwar Ruff on 1/7/23.
//

import SwiftUI

struct User: Hashable, Codable {
    let id: Int
    let email: String
    let name: String
}

class UserCollection: ObservableObject {
    @Published var users: [User] = []
    
    func fetch() {
        guard let url = URL(string: "http://127.0.0.1:8000/users") else {
            print("Invalid URL")
            return
        }
        
        let requestURL = URLRequest(url: url)
       
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let data = data {
                if let users = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = users
                    }
                    
                    return
                }
                else {
                    print("Failed to decode response from data")
                }
            }
            else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown Error")")
            }
            print(self.users)
        }
        .resume()
        
    }
}


struct ContentView: View {
    @State var email = ""
    @StateObject var userCollection = UserCollection()
    
    var body: some View {
        VStack {
            TextField("Email", text: $email, onCommit: {})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Submit"){
                print(userCollection.users)
            }
            .buttonStyle(.bordered)
        }
        .onAppear(perform: userCollection.fetch)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
