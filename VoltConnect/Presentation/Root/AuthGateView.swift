//
//  AuthGateView.swift
//  VoltConnect
//
//  Created by Babatunde Kalejaiye on 22/10/2025.
//

import SwiftUI

struct AuthGateView: View {
    @StateObject private var viewModel: AuthGateViewModel

    init(auth: AuthRepository) {
        _viewModel = StateObject(wrappedValue: AuthGateViewModel(auth: auth))
    }

    var body: some View {
        Group {
            switch viewModel.route {
            case .splash:
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Starting up…").foregroundStyle(.secondary)
                }
            case .offline(let message):
                VStack(spacing: 12) {
                    Text("Offline").font(.title2).bold()
                    Text(message).multilineTextAlignment(.center)
                    Button("Try Again") { viewModel.start() }
                        .buttonStyle(.borderedProminent)
                }
                .padding()
            case .home:
                RootView() // your existing home/root screen with SessionViewModel
            }
        }
        .task { viewModel.start() }
        .padding()
    }
}
