//
//  AppDelegate.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//
import UIKit
import FirebaseCore
import FirebaseAppCheck
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import FirebaseStorage

@MainActor
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // App Check FIRST
        #if DEBUG
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #else
        AppCheck.setAppCheckProviderFactory(AppAttestProviderFactory())
        #endif

        // Then configure Firebase (once)
        FirebaseApp.configure()

        #if USE_FIREBASE_EMULATORS
        connectEmulators()
        #endif

        let repo = FirebaseAuthService(auth: Auth.auth(), database: Firestore.firestore())
        Env.current = AppEnvironment(authRepo: repo)

        return true
    }
}

private func connectEmulators() {
    let host = "192.168.56.1"

    Auth.auth().useEmulator(withHost: host, port: 9099)

    let firestoreDB = Firestore.firestore()
    let server = firestoreDB.settings
    server.host = "\(host):8088"
    server.isSSLEnabled = false
    firestoreDB.settings = server

    Functions.functions(region: "us-central1").useEmulator(withHost: host, port: 5001)
    Storage.storage().useEmulator(withHost: host, port: 9199)

    // Build DI AFTER emulator settings applied
    Env.current = AppEnvironment(
        authRepo: FirebaseAuthService(auth: Auth.auth(), database: Firestore.firestore())
    )

    print("Firebase Emulators configured successfully")
}
