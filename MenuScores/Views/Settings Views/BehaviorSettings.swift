//
//  BehaviorSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-16.
//

import KeyboardShortcuts
import SwiftUI
import UserNotifications

struct BehaviorSettingsView: View {
    @State private var notificationStatusMessage: String?
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    let refreshOptions = [
        "10 seconds", "15 seconds", "20 seconds", "30 seconds", "40 seconds",
        "50 seconds", "1 minute", "2 minutes", "5 minutes",
    ]

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
            Text("Behavior")
                .font(.title2)
                .bold()

            Form {
                Section("Notch") {
                    Toggle(isOn: $enableNotch) {
                        HStack {
                            Image(systemName: "macbook")
                                .foregroundColor(.secondary)
                            Text("Notch Integration")
                        }
                    }

                    HStack {
                        Label("Notch Display", systemImage: "display")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $notchScreenIndex) {
                            ForEach(NSScreen.screens.indices, id: \.self) { index in
                                Text(NSScreen.screens[index].localizedName ?? "Screen \(index + 1)")
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 180)
                        .disabled(!enableNotch)
                    }

                    HStack {
                        Label("Expand Notch", systemImage: "keyboard")
                            .foregroundColor(.primary)
                        Spacer()
                        KeyboardShortcuts.Recorder(for: .notchActivation)
                            .frame(width: 130)
                            .disabled(enableNotch == false)
                    }
                }

                Section("Score Updates") {
                    VStack(alignment: .leading, spacing: 2) {
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
                    }
                }

                Section {
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
                } header: {
                    HStack(spacing: 4) {
                        HStack {
                            Text("Notifications")
                                .font(.headline)
                            Spacer()

                            if let message = notificationStatusMessage {
                                Text(message)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Button(action: {
                                UNUserNotificationCenter.current()
                                    .requestAuthorization(options: [
                                        .alert, .sound, .badge,
                                    ]) { granted, error in
                                        DispatchQueue.main.async {
                                            if let error = error {
                                                notificationStatusMessage =
                                                    "\(error.localizedDescription)"
                                            } else if granted {
                                                notificationStatusMessage =
                                                    "Permissions granted!"
                                            }
                                        }
                                    }
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            .controlSize(.small)
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .help("Request notification permissions")
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
