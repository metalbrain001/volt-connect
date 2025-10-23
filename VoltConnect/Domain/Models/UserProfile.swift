//
//  UserProfile.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

import Foundation

public struct UserProfile: Codable, Identifiable, Equatable, Sendable {
    public let id: String            // == uid
    public var email: String?
    public var displayName: String?
    public var createdAt: Date?

    public init(id: String, email: String? = nil, displayName: String? = nil, createdAt: Date? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.createdAt = createdAt
    }
}
