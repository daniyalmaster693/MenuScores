//
//  GeneralSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("showInDock") private var showInDock = false
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    @AppStorage("showDefaultText") private var showDefaultText = false
    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    let refreshOptions = ["10 seconds", "15 seconds", "20 seconds", "30 seconds", "40 seconds", "50 seconds", "1 minute", "2 minutes", "5 minutes"]

    var refreshInterval: Double {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
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
                            UserDefaults.standard.set(newValue, forKey: "showInDock")

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
                        Label("Refresh Interval", systemImage: "timer")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $selectedOption) {
                            ForEach(refreshOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 150)
                    }

                    Toggle(isOn: $showDefaultText) {
                        HStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(.secondary)
                            Text("Show Default Select a Game Text")
                        }
                    }
                }

                Section("Notifications") {
                    Toggle(isOn: $notiGameStart) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.secondary)
                            Text("Enable notifications for game start")
                        }
                    }

                    Toggle(isOn: $notiGameComplete) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.secondary)
                            Text("Enable notifications upon game completion")
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}
