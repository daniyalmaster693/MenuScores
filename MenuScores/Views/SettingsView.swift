//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI

struct SettingsView: View {
    @State private var showLineNumbers = true
    @State private var selectedOption = "15 seconds"
    let refreshOptions = ["10 seconds", "15 seconds","20 seconds", "30 seconds", "40 seconds", "50 seconds", "1 minute", "2 minutes", "5 minutes"]
    
    var body: some View {
        TabView {
            Form {
                VStack(alignment: .leading, spacing: 40) {
                    LabeledContent("Notifications") {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Enable notifications for game start", isOn: $showLineNumbers)
                            Text("Recieve notifications when games start")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                            Toggle("Enable notifications for score updates", isOn: $showLineNumbers)
                            Text("Receive notifications for important game events")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                            Toggle("Enable notifications for completed games", isOn: $showLineNumbers)
                            Text("Receive notifications when a game ends with its final score")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    LabeledContent("Auto Refresh Interval") {
                        VStack(alignment: .leading, spacing: 4) {
                            Picker("", selection: $selectedOption) {
                                ForEach(refreshOptions, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 140, alignment: .leading)

                            Text("Control how often games and scores will update")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                                .padding(.top, 2)
                        }
                    }
                    
                    LabeledContent("Application") {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Start at login", isOn: $showLineNumbers)
                            Toggle("Show icon in dock", isOn: $showLineNumbers)
                            
                            Button("Check for Updates") {
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 8)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .tabItem {
                Label("General", systemImage: "gearshape")
            }

            Text("Leagues Settings")
                .tabItem {
                    Label("Leagues", systemImage: "list.bullet.rectangle")
                }
        }
        .frame(maxWidth: 500, maxHeight: 625)
        .onDisappear {
            NSApp.setActivationPolicy(.accessory)
            NSApp.deactivate()
        }
    }
}
