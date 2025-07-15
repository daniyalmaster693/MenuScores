//
//  GeneralSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import LaunchAtLogin
import Sparkle
import SwiftUI
import UserNotifications

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
    
    @State private var notificationStatusMessage: String?
    @AppStorage("showInDock") private var showInDock = false
    
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false
    
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
    
    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    init(updater: SPUUpdater) {
        self.updater = updater
        _updateViewModel = StateObject(wrappedValue: CheckForUpdatesViewModel(updater: updater))
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
                
                Section("Behavior") {
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
                                    .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                        DispatchQueue.main.async {
                                            if let error = error {
                                                notificationStatusMessage = "\(error.localizedDescription)"
                                            } else if granted {
                                                notificationStatusMessage = "Permissions granted!"
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
