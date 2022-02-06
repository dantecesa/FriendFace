//
//  FriendDetailView.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/6/22.
//

import SwiftUI
import MessageUI

struct FriendDetailView: View {
    var user: User
    @EnvironmentObject var userTracker: UserTracker
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(user.name)
                            .font(.title)
                        Spacer()
                        Text("Born \(2022 - user.age)" as String)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "building")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            
                        Text("\(user.company)")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        Text("Member since: \((user.registered.formatted(date: .abbreviated, time: .omitted)))")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                
            } header: {
                Text("Friend Details")
            }
            
            Section {
                Text(user.about)
                    .textSelection(.enabled)
            } header: {
                Text("Description")
            }
            
            Section {
                Button(action: {
                    EmailHelper.shared.sendEmail(subject: "", body: "", to: "\(user.email)")
                }, label: {
                    Text("\(user.email)")
                })
            } header: {
                Text("Email")
            }
            
            Section {
                Text(user.address)
                    .textSelection(.enabled)
            } header: {
                Text("Address")
            }
                
                Section {
                    ForEach(user.friends, id:\.self) { friend in
                        NavigationLink(destination: {
                            FriendDetailView(user: findUser(forFriend: friend) ?? User(id: UUID(), isActive: true, name: "Unkonwn User", age: 30, company: "Unkonwn Company", email: "Unknown Company", address: "Unknown Address", about: "", registered: Date.now, tags: [], friends: [])).environmentObject(userTracker)
                        }, label: {
                            Text(friend.name)
                        })
                    }
                } header: {
                    Text("Friends")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func findUser(forFriend: Friend) -> User? {
        let allUsers = userTracker.users
        
        for aUser in allUsers {
            if forFriend.id == aUser.id {
                return aUser
            }
        }
        return nil
    }
}

struct FriendDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FriendDetailView(user: User(id: UUID(), isActive: true, name: "Test User", age: 32, company: "Test Company", email: "test@test.com", address: "123 Main St., San Francisco, CA", about: "A string about the user", registered: Date.now, tags: ["tag1", "tag2"], friends: [Friend(id: UUID(), name: "Test Friend 1"), Friend(id: UUID(), name: "Test Friend 2")]))
    }
}

/*
 let id: UUID
 let isActive: Bool
 let name: String
 let age: Int
 let company: String
 let email: String
 let address: String
 let about: String
 let registered: Date
 let tags: [String]
 let friends: [Friend]
 */
