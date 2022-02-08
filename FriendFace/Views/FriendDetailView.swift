//
//  FriendDetailView.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/6/22.
//

import SwiftUI
import MessageUI

struct FriendDetailView: View {
    var user: CachedUser
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var allUsers: FetchedResults<CachedUser>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(user.wrappedName)
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
                            
                        Text("\(user.wrappedCompany)")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        Text("Member since: \((user.wrappedRegistered.formatted(date: .abbreviated, time: .omitted)))")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                
            } header: {
                Text("Friend Details")
            }
            
            Section {
                Text(user.wrappedAbout)
                    .textSelection(.enabled)
            } header: {
                Text("Description")
            }
            
            Section {
                Button(action: {
                    EmailHelper.shared.sendEmail(subject: "", body: "", to: "\(user.wrappedEmail)")
                }, label: {
                    Text("\(user.wrappedEmail)")
                })
            } header: {
                Text("Email")
            }
            
            Section {
                Text(user.wrappedAddress)
                    .textSelection(.enabled)
            } header: {
                Text("Address")
            }
                
                Section {
                    ForEach(user.wrappedFriends, id:\.self) { friend in
                        NavigationLink(destination: {
                            FriendDetailView(user: findUser(forFriend: friend) ?? CachedUser(context: moc) )
                        }, label: {
                            Text(friend.wrappedName)
                        })
                    }
                } header: {
                    Text("Friends")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func findUser(forFriend: CachedFriend) -> CachedUser? {
        for aUser in allUsers {
            if forFriend.id == aUser.id {
                return aUser
            }
        }
        return nil
    }
}
