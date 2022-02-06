//
//  UserTracker.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/5/22.
//

import Foundation

class UserTracker: ObservableObject {
    @Published var users: [User] = [] {
        didSet {
            if let encodedUsers = try? JSONEncoder().encode(users) {
                UserDefaults.standard.set(encodedUsers, forKey: "users")
            }
        }
    }
    
    init() {
        if let savedUsers = UserDefaults.standard.data(forKey: "users") {
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: savedUsers) {
                users = decodedUsers
                return
            }
        }
        users = []
    }
    
    func fetchUsers() async -> [User] {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let decodedResponse = try? decoder.decode([User].self, from: data) {
                print(decodedResponse)
                return decodedResponse
            }
        } catch {
            print("We had a problem fetching the data.")
        }
        
        return []
    }
}
