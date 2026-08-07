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

    @AppStorage("playAlerts") private var enablePlayAlerts = false
    @AppStorage("alertsTimer") private var alertsTimer: Double = 10.0

    @AppStorage("notchAlerts") private var enableNotchAlerts = false

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section {
                    Toggle(isOn: $enableNotchAlerts) {
                        HStack {
                            Image(systemName: "macbook")
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

                        Slider(value: self.$alertsTimer, in: 5 ... 15.0, step: 0.5)
                            .disabled(!enablePlayAlerts || !enableNotch)
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
