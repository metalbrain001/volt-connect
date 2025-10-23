//
//  AuthService.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
public final class FirebaseAuthService: AuthRepository {
    private let auth: Auth
    private let firestoreDB: Firestore

    public init(auth: Auth, database: Firestore) {
        self.auth = auth
        self.firestoreDB = database
    }

    @MainActor public var currentUID: String? { auth.currentUser?.uid }

    @MainActor
    public func authState() -> AsyncStream<String?> {
        let auth = self.auth // bind local to avoid capturing self
        return AsyncStream { continuation in
            let handle = auth.addStateDidChangeListener { _, user in
                continuation.yield(user?.uid)
            }
            continuation.onTermination = { _ in
                auth.removeStateDidChangeListener(handle)
            }
        }
    }

    // MARK: Auth
    @MainActor
    public func ensureAnonymousSignIn() async throws -> String {
        if let uid = auth.currentUser?.uid { return uid }
        let result = try await auth.signInAnonymously()
        return result.user.uid
    }

    // MARK: Profile
    private func profileRef(_ uid: String) -> DocumentReference {
        firestoreDB.collection("users").document(uid)
    }

    @MainActor
    public func fetchUserProfile(uid: String) async throws -> UserProfile? {
        let snap = try await profileRef(uid).getDocument()
        guard snap.exists else { return nil }
        return try snap.data(as: UserProfile.self)
    }

    @MainActor
    public func upsertUserProfile(_ profile: UserProfile) async throws {
        try profileRef(profile.id).setData(from: profile, merge: true)
    }
}
