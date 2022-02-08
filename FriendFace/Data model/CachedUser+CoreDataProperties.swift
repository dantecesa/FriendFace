//
//  CachedUser+CoreDataProperties.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/7/22.
//
//

import Foundation
import CoreData


extension CachedUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUser> {
        return NSFetchRequest<CachedUser>(entityName: "CachedUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var friend: NSSet?
    
    public var wrappedIsActive: Bool {
        return isActive
    }
    
    public var wrappedName: String {
        return name ?? "Unkonwn Name"
    }
    
    public var wrappedAge: Int {
        return Int(age)
    }
    
    public var wrappedCompany: String {
        return company ?? "Unknown Company"
    }
    
    public var wrappedAddress: String {
        return address ?? "Unknown Address"
    }
    
    public var wrappedEmail: String {
        return email ?? "Unknown Email"
    }
    
    public var wrappedAbout: String {
        return about ?? "Unknown About"
    }
    
    public var wrappedRegistered: Date {
        return registered ?? Date.now
    }
    
    public var wrappedFriends: [CachedFriend] {
        let set = friend as? Set<CachedFriend> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for friend
extension CachedUser {

    @objc(addFriendObject:)
    @NSManaged public func addToFriend(_ value: CachedFriend)

    @objc(removeFriendObject:)
    @NSManaged public func removeFromFriend(_ value: CachedFriend)

    @objc(addFriend:)
    @NSManaged public func addToFriend(_ values: NSSet)

    @objc(removeFriend:)
    @NSManaged public func removeFromFriend(_ values: NSSet)
    
}

extension CachedUser : Identifiable {

}
