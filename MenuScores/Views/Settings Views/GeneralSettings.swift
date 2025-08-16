//
//  GeneralSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import KeyboardShortcuts
import LaunchAtLogin
import Sparkle
import SwiftUI

struct GeneralSettingsView: View {
    let updater: SPUUpdater
    @StateObject private var updateViewModel: CheckForUpdatesViewModel

    final class CheckForUpdatesViewModel: ObservableObject {
        @Published var canCheckForUpdates = false

        init(updater: SPUUpdater) {
            updater.publisher(for: \.canCheckForUpdates)
                .assign(to: &$canCheckForUpdates)
        }
    }

    @AppStorage("showInDock") private var showInDock = false

    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    init(updater: SPUUpdater) {
        self.updater = updater
        _updateViewModel = StateObject(
            wrappedValue: CheckForUpdatesViewModel(updater: updater))
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("General")
                .font(.title2)
                .bold()

            Form {
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.secondary)
                        LaunchAtLogin.Toggle()
                    }

                    HStack {
                        Toggle(isOn: $showInDock) {
                            HStack {
                                Image(systemName: "dock.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Show in Dock")
                            }
                        }
                        .onChange(of: showInDock) { newValue in
                            UserDefaults.standard.set(
                                newValue, forKey: "showInDock"
                            )

                            if newValue {
                                NSApp.setActivationPolicy(.regular)
                            } else {
                                NSApp.setActivationPolicy(.accessory)
                            }
                        }
                    }
                }

                Section {
                    HStack {
                        Label("Updates", systemImage: "arrow.2.circlepath")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Check for Updates") {
                            updater.checkForUpdates()
                        }
                        .buttonStyle(.bordered)
                        .disabled(!updateViewModel.canCheckForUpdates)
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
