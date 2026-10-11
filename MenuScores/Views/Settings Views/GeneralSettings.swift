//
//  GeneralSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @StateObject private var updateManager = UpdateManager()
    @AppStorage("autoUpdate") private var autoUpdate = true

    @AppStorage("showInDock") private var showInDock = false

    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section("General") {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.primary)
                        LaunchAtLogin.Toggle()
                    }

                    HStack {
                        Toggle(isOn: $showInDock) {
                            HStack {
                                Image(systemName: "dock.rectangle")
                                    .foregroundColor(.primary)
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

                Section("Updates") {
                    Toggle(isOn: self.$autoUpdate) {
                        HStack {
                            Image(systemName: "clock.arrow.2.circlepath")
                                .foregroundColor(.primary)
                            Text("Automatically Check for Updates")
                        }
                    }
                    .onChange(of: self.autoUpdate) { isEnabled in
                        if isEnabled {
                            self.updateManager.startTimer {
                                self.updateManager.getUpdateData()
                            }
                        } else {
                            self.updateManager.stopTimer()
                        }
                    }

                    HStack {
                        Label("Updates", systemImage: "arrow.2.circlepath")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Check for Updates") {
                            self.updateManager.getUpdateData(manualCheck: true)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
