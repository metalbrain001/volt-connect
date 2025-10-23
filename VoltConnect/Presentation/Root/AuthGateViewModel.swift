//
//  AuthGateViewModel.swift
//  VoltConnect
//
//  Created by Babatunde Kalejaiye on 22/10/2025.
//

import Foundation
import Combine

@MainActor
final class AuthGateViewModel: ObservableObject {
    enum Route { case splash, offline(String), home }
    @Published var route: Route = .splash

    private let auth: AuthRepository

    init(auth: AuthRepository) {
        self.auth = auth
    }

    func start() {
        Task {
            // 1) ensure a user
            do { _ = try await auth.ensureAnonymousSignIn() } catch {
                route = .offline("Sign-in failed: \(error.localizedDescription)")
                return
            }

            route = .home

            // 2) probe Firestore (server) with light retry
            let connection = await probeFirestoreConnectivity(retries: 3, delay: 0.5)
            route = connection ? .home : .offline("Firestore appears offline. Is the emulator running?")
        }
    }

    private func probeFirestoreConnectivity(retries: Int, delay: TimeInterval) async -> Bool {
        // Use the profile fetch to test server connectivity
        for attempt in 0...retries {
            do {
                let uid = auth.currentUID ?? ""
                _ = try await auth.fetchUserProfile(uid: uid) // will use server by default
                return true
            } catch {
                // Firestore offline often throws a "client is offline" error
                if attempt < retries {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                } else {
                    return false
                }
            }
        }
        return false
    }
}
