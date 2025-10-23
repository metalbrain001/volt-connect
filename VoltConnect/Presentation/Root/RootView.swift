//
//  RootView.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: SessionViewModel

    init() {
        // Safe: this runs on main and Env.current is @MainActor
        self._viewModel = StateObject(wrappedValue: SessionViewModel(auth: Env.current.authRepo))
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("VoltConnect").font(.title).bold()
            Text(viewModel.status).foregroundStyle(.secondary)
            if let uid = viewModel.uid { Text("UID: \(uid)").font(.footnote).monospaced() }
            Button("Ensure Auth (Emulator)") { Task { await viewModel.ensureAuth() } }
                .buttonStyle(.borderedProminent)
        }
        .padding()

    }
}
