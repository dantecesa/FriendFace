//
//  ContentView.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/5/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUser>
    
    let sortArray: [String] = ["circle.fill", "character"]
    @State var sortSelection: String = "circle.fill"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(sortFunction()) { user in
                        NavigationLink(destination: {
                            FriendDetailView(user: user)
                        }, label: {
                            HStack {
                                Image(systemName: (user.isActive ? "circle.fill" : "circle"))
                                    .foregroundColor(user.isActive ? .green : .gray)
                                
                                VStack(alignment: .leading) {
                                    Text(user.wrappedName)
                                    Text(user.wrappedRegistered.formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                }
                            }
                        })
                    }
                }
            }.onAppear {
                if users.isEmpty {
                    Task {
                        let users = await fetchUsers()
                        await MainActor.run {
                            updateCache(with: users)
                        }
                    }
                }
            }
            .navigationTitle("FriendFace")
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
    
    func sortFunction() -> [CachedUser] {
        if sortSelection == "circle.fill" {
            return users.sorted(by: { $0.isActive && !$1.isActive })
        } else {
            return users.sorted(by: { $0.wrappedName < $1.wrappedName })
        }
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
    
    func updateCache(with downloadedUsers: [User]) {
        for user in downloadedUsers {
            let cachedUser = CachedUser(context: moc)
            
            cachedUser.id = user.id
            cachedUser.isActive = user.isActive
            cachedUser.name = user.name
            cachedUser.age = Int16(user.age)
            cachedUser.company = user.company
            cachedUser.email = user.email
            cachedUser.address = user.address
            cachedUser.about = user.about
            cachedUser.registered = user.registered
            
            for friend in user.friends {
                let cachedFriend = CachedFriend(context: moc)
                
                cachedFriend.id = friend.id
                cachedFriend.name = friend.name
                
                cachedUser.addToFriend(cachedFriend)
            }
        }
        try? moc.save()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
