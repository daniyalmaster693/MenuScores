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
    @AppStorage("alertsTimer") private var alertsTimer: Double = 10.0

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

                        Slider(value: self.$alertsTimer, in: 5 ... 15.0, step: 0.5)
                            .disabled(!enableNotch || !enableNotchAlerts)
                    }
                }

                Section("Notifications") {
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
                }
            }
            .formStyle(.grouped)
        }
    }
}
