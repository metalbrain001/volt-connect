//
//  Environment.swift
//  VoltConnect
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

import Foundation

/// Application-wide dependency container
public struct AppEnvironment: Sendable {
    public var authRepo: AuthRepository
    // Add more repositories/services later:
    // public var firestoreRepo: FirestoreRepository
    // public var analytics: AnalyticsService
}

@MainActor
enum Env {
    static var current: AppEnvironment!
}

/// Static access to build-time and runtime environment constants
public enum Environment {

    private enum Keys {
        static let apiKey = "API_KEY"
        static let baseURL = "BASE_URL"
    }

    // MARK: - Info.plist dictionary
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("❌ Info.plist not found in main bundle.")
        }
        return dict
    }()

    // MARK: - Config values
    public static let baseURL: String = {
        guard let urlString = infoDictionary[Keys.baseURL] as? String, !urlString.isEmpty else {
            fatalError("❌ Missing or empty BASE_URL in Info.plist.")
        }
        return urlString
    }()

    public static let apiKey: String = {
        guard let keyString = infoDictionary[Keys.apiKey] as? String, !keyString.isEmpty else {
            fatalError("❌ Missing or empty API_KEY in Info.plist.")
        }
        return keyString
    }()
}
