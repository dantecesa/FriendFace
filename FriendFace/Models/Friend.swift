//
//  Friend.swift
//  FriendFace
//
//  Created by Dante Cesa on 2/5/22.
//

import Foundation

struct Friend: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
}
