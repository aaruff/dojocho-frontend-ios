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

class UsersCache: ObservableObject {
    @Published var users: [User] = []
    
    func loadUsers() {
        guard let url = URL(string: "http://127.0.0.1:8000/users") else {
            return
        }
        
        let requestURL = URLRequest(url: url)
       
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let data = data {
                if let users = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = users
                    }
                }
            }
        }
        .resume()
    }
    
    func emails() -> [String] {
        var userEmails = [String]()
        for user in users {
            userEmails.append(user.email)
        }
       return userEmails
    }
}


struct ContentView: View {
    @State var email = ""
    @StateObject var userCollection = UsersCache()
    
    var body: some View {
        VStack {
            TextField("Email", text: $email, onCommit: {})
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Submit"){
                print(userCollection.users)
            }
            .buttonStyle(.bordered)
            List(userCollection.emails(), id: \.self) { email in
                Text(email)
            }
        }
        .onAppear(perform: userCollection.loadUsers)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
