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
    @AppStorage("showInDock") private var showInDock = false

    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
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
            }
            .formStyle(.grouped)
        }
    }
}
