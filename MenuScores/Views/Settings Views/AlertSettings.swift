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

    @AppStorage("playAlerts") private var enablePlayAlerts = true
    @AppStorage("notificationAlerts") private var enableNotificationAlerts = true

    @AppStorage("notchAlerts") private var enableNotchAlerts = false
    @AppStorage("alertsTimer") private var alertsTimer: Double = 10.0

    @AppStorage("scoreChanges") private var enableScoreChanges = true
    @AppStorage("periodStartAlert") private var enablePeriodStartAlert = false
    @AppStorage("periodEndAlert") private var enablePeriodEndAlert = false
    @AppStorage("penaltyAlert") private var enablePenaltyAlert = false
    @AppStorage("timeoutAlert") private var enableTimeoutAlert = false

    @State private var notificationStatusMessage: String?

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section {
                    Toggle(isOn: $enablePlayAlerts) {
                        HStack {
                            Image(systemName: "play.display")
                                .foregroundColor(.primary)
                            Text("Enable Play Alerts")
                        }
                    }

                    Toggle(isOn: $enableNotificationAlerts) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.primary)
                            Text("Receive notifications for play alerts")
                        }
                    }.disabled(!enablePlayAlerts)

                    Toggle(isOn: $enableNotchAlerts) {
                        HStack {
                            Image(systemName: "macbook")
                                .foregroundColor(.primary)
                            Text("Expand notch automatically for major plays")
                        }
                    }.disabled(!enableNotch || !enablePlayAlerts)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("Notch Alert Duration: \(String(format: "%.1f", self.alertsTimer))s")
                        }

                        Slider(value: self.$alertsTimer, in: 5 ... 15.0, step: 0.5)
                            .disabled(!enablePlayAlerts || !enableNotch || !enableNotchAlerts)
                    }
                } header: {
                    HStack(spacing: 4) {
                        HStack {
                            Text("Play Alerts")
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

                Section("Alert Types") {
                    Toggle(isOn: $enableScoreChanges) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.primary)
                            Text("Score Changes")
                        }
                    }
                    .disabled(!enablePlayAlerts)

                    Toggle(isOn: $enablePeriodStartAlert) {
                        HStack {
                            Image(systemName: "play.circle")
                                .foregroundColor(.primary)
                            Text("Start of Game Segment")
                        }
                    }
                    .disabled(!enablePlayAlerts)

                    Toggle(isOn: $enablePeriodEndAlert) {
                        HStack {
                            Image(systemName: "stop.circle")
                                .foregroundColor(.primary)
                            Text("End of Game Segment")
                        }
                    }
                    .disabled(!enablePlayAlerts)

                    Toggle(isOn: $enablePenaltyAlert) {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.primary)
                            Text("Penalties & Fouls")
                        }
                    }
                    .disabled(!enablePlayAlerts)

                    Toggle(isOn: $enableTimeoutAlert) {
                        HStack {
                            Image(systemName: "stopwatch")
                                .foregroundColor(.primary)
                            Text("Timeouts")
                        }
                    }
                    .disabled(!enablePlayAlerts)
                }
            }
            .formStyle(.grouped)
        }
    }
}
