import SwiftUI

@main
struct VoltConnectApp: App {
    // Make the delegate a property (not inside init)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AuthGateView(auth: Env.current.authRepo)
        }
    }
}
