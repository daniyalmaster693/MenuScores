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

    @AppStorage("notifyFavoriteGameStart") private var notifyFavoriteGameStart = false
    @AppStorage("notifyFavoriteGameEnd") private var notifyFavoriteGameEnd = false

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    @AppStorage("playAlerts") private var enablePlayAlerts = false
    @AppStorage("alertsTimer") private var alertsTimer: Double = 10.0

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
                                .foregroundColor(.primary)
                            Text("Notch Integration")
                        }
                    }

                    HStack {
                        Label("Notch Display", systemImage: "display")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $notchScreenIndex) {
                            ForEach(NSScreen.screens.indices, id: \.self) { index in
                                Text(NSScreen.screens[index].localizedName)
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 190)
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

                Section("Play Alerts") {
                    Toggle(isOn: $enablePlayAlerts) {
                        HStack {
                            Image(systemName: "play.display")
                                .foregroundColor(.primary)
                            Text("Expand notch automatically for major plays")
                        }
                    }.disabled(!enableNotch)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("Alerts Timer: \(String(format: "%.1f", self.alertsTimer))s")
                        }

                        Text("Controls how long play alerts remain visible")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 25)
                            .padding(.bottom, 10)

                        Slider(value: self.$alertsTimer, in: 2 ... 12.0, step: 0.5)
                            .disabled(!enablePlayAlerts || !enableNotch)
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
                                .foregroundColor(.primary)
                            Text("Notify when a pinned game starts")
                        }
                    }

                    Toggle(isOn: $notiGameComplete) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.primary)
                            Text("Notify when a pinned game ends")
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

                Section {
                    Toggle(isOn: $notifyFavoriteGameStart) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.primary)
                            Text("Notify when favorite team's game starts")
                        }
                    }

                    Toggle(isOn: $notifyFavoriteGameEnd) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.primary)
                            Text("Notify when favorite team's game ends")
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
