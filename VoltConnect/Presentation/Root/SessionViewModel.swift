//
//  SessionViewModel.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

import Foundation
import Combine

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var uid: String?
    @Published var profile: UserProfile?
    @Published var status: String = "Idle"

    private let auth: AuthRepository

    init(auth: AuthRepository) {
        self.auth = auth
        Task { await observeAuth() }
    }

    private func observeAuth() async {
        for await maybeUID in auth.authState() {
            self.uid = maybeUID
            if let muid = maybeUID {
                do {
                    if let uprofile = try await auth.fetchUserProfile(uid: muid) {
                        self.profile = uprofile
                    } else {
                        let nprofile = UserProfile(id: muid, createdAt: Date())
                        try await auth.upsertUserProfile(nprofile)
                        self.profile = nprofile
                    }
                    self.status = "Signed in"
                } catch {
                    self.status = "Error: \(error.localizedDescription)"
                }
            } else {
                self.profile = nil
                self.status = "Signed out"
            }
        }
    }

    func ensureAuth() async {
        do {
            let uid = try await auth.ensureAnonymousSignIn()
            self.status = "Signed in (anon): \(uid.prefix(6))…"
        } catch {
            self.status = "Sign-in failed: \(error.localizedDescription)"
        }
    }
}
