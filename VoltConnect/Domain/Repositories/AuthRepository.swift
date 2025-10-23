//
//  AuthRepository.swift
//  VoltConnect
//
//  Created by Babatunde Kalejaiye on 22/10/2025.
//

import Foundation

public protocol AuthRepository: Sendable {
    @MainActor var currentUID: String? { get }
    @MainActor func authState() -> AsyncStream<String?>
    @MainActor func fetchUserProfile(uid: String) async throws -> UserProfile?
    @MainActor func upsertUserProfile(_ profile: UserProfile) async throws
    @MainActor func ensureAnonymousSignIn() async throws -> String
}
