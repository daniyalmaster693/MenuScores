//
//  AlertSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-07.
//

import KeyboardShortcuts
import SwiftUI
import UserNotifications

struct AlertSettingsView: View {
    @AppStorage("enableNotch") private var enableNotch = true

    @AppStorage("notchAlerts") private var enableNotchAlerts = true
    @AppStorage("alertsTimer") private var alertsTimer: Double = 7.0

    @AppStorage("scoreChanges") private var enableScoreChanges = true
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    @State private var notificationStatusMessage: String?

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section("Score Changes") {
                    Toggle(isOn: $enableNotchAlerts) {
                        HStack {
                            Image(systemName: "macbook")
                                .foregroundColor(.primary)
                            Text("Auto Expand Notch for Score Changes")
                        }
                    }.disabled(!enableNotch)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("Notch Alert Duration: \(String(format: "%.1f", self.alertsTimer))s")
                        }

                        Slider(value: self.$alertsTimer, in: 5 ... 15.0, step: 1)
                            .disabled(!enableNotch || !enableNotchAlerts)
                    }
                }

                Section {
                    Toggle(isOn: $notiGameStart) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.primary)
                            Text("Game Start")
                        }
                    }

                    Toggle(isOn: $notiGameComplete) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.primary)
                            Text("Game End")
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
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    DispatchQueue.main.async {
                                        switch settings.authorizationStatus {
                                        case .authorized:
                                            notificationStatusMessage = "Notifications Enabled"

                                        case .denied:
                                            let alert = NSAlert()
                                            alert.messageText = "Notifications Disabled"
                                            alert.informativeText = "Enable notifications for MenuScores in System Settings."
                                            alert.alertStyle = .warning

                                            alert.addButton(withTitle: "Open Settings")
                                            alert.addButton(withTitle: "Cancel")

                                            if alert.runModal() == .alertFirstButtonReturn {
                                                if let url = URL(string: "x-apple.systempreferences:com.apple.Notifications-Settings") {
                                                    NSWorkspace.shared.open(url)
                                                }
                                            }

                                        case .notDetermined:
                                            notificationStatusMessage = "Notifications Not Configured"

                                            let alert = NSAlert()
                                            alert.messageText = "Notifications Not Configured"
                                            alert.informativeText = "Request permission for MenuScores to send notifications."
                                            alert.alertStyle = .warning

                                            alert.addButton(withTitle: "Request Permission")
                                            alert.addButton(withTitle: "Cancel")

                                            if alert.runModal() == .alertFirstButtonReturn {
                                                Task {
                                                    try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                                                }
                                            }

                                        default:
                                            notificationStatusMessage = "Notifications Unavailable"
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "questionmark.circle")
                            }
                            .controlSize(.small)
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .help("Check notification settings")
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
