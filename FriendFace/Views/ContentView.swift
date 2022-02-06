//
//  ContentView.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/5/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userTracker: UserTracker = UserTracker()
    
    let sortArray: [String] = ["circle.fill", "character"]
    @State var sortSelection: String = "circle.fill"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(sortFunction()) { user in
                        NavigationLink(destination: {
                            FriendDetailView(user: user)
                                .environmentObject(userTracker)
                        }, label: {
                            HStack {
                                Image(systemName: (user.isActive ? "circle.fill" : "circle"))
                                    .foregroundColor(user.isActive ? .green : .gray)
                                
                                VStack(alignment: .leading) {
                                    Text(user.name)
                                    Text(user.registered.formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                }
                            }
                        })
                    }
                }
            }.onAppear {
                if userTracker.users.isEmpty {
                    Task {
                        userTracker.users = await userTracker.fetchUsers()
                    }
                }
            }
            .navigationTitle("FriendFace")
            //.environmentObject(userTracker)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Select sort", selection: $sortSelection) {
                        ForEach(sortArray, id:\.self) { sortFilter in
                            Image(systemName: sortFilter)
                                .foregroundColor(sortSelection == "character" ? .primary : .green)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
    
    func sortFunction() -> [User] {
        if sortSelection == "circle.fill" {
            return userTracker.users.sorted(by: { $0.isActive && !$1.isActive })
        } else {
            return userTracker.users.sorted(by: { $0.name < $1.name })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
