//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/7/22.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var relationship: CachedUser?
    
    public var wrappedName: String {
        return name ?? "Unknown Name"
    }
}

extension CachedFriend : Identifiable {

}
