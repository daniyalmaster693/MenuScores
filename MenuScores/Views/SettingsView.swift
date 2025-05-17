//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @State private var notiGameStart = false
    @State private var notiGameUpdate = false
    @State private var notiGameComplete = false
    
    @AppStorage("showIconInDock") private var showIconInDock = false
    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    let refreshOptions = ["10 seconds", "15 seconds","20 seconds", "30 seconds", "40 seconds", "50 seconds", "1 minute", "2 minutes", "5 minutes"]
    
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
    
    @State private var enableNHL = true
    @State private var enableNBA = true
    @State private var enableNCAAM = true
    @State private var enableNCAAF = true
    @State private var enableNFL = true
    @State private var enableMLB = true
    @State private var enableWNBA = true
    @State private var enableF1 = true
    @State private var enableUFC = true
    @State private var enableNASCAR = true
    @State private var enableNLL = true
    @State private var enablePGA = true
    @State private var enableLPGA = true
    @State private var enableUEFA = true
    @State private var enableEPL = true
    @State private var enableBOXING = true
    @State private var enableATP = true
    @State private var enableWTA = true
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 40) {
                LabeledContent("Notifications") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Enable notifications for game start", isOn: $notiGameStart)
                        Text("Recieve notifications 15 minutes before games start")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        
                        Toggle("Enable notifications for score updates", isOn: $notiGameUpdate)
                        Text("Receive notifications for important game events")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        
                        Toggle("Enable notifications for completed games", isOn: $notiGameComplete)
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
                
                LabeledContent("Enabled Leagues") {
                    HStack(alignment: .top, spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("NHL", isOn: $enableNHL)
                            Toggle("NBA", isOn: $enableNBA)
                            Toggle("WNBA", isOn: $enableWNBA)
                            Toggle("NCAA M", isOn: $enableNCAAM)
                            Toggle("NCAA F", isOn: $enableNCAAF)
                            Toggle("NFL", isOn: $enableNFL)
                            
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("UFC", isOn: $enableUFC)
                            Toggle("Boxing", isOn: $enableBOXING)
                            Toggle("F1", isOn: $enableF1)
                            Toggle("Nascar", isOn: $enableNASCAR)
                            Toggle("PGA", isOn: $enablePGA)
                            Toggle("LPGA", isOn: $enableLPGA)
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("MLB", isOn: $enableMLB)
                            Toggle("NLL", isOn: $enableNLL)
                            Toggle("UEFA", isOn: $enableUEFA)
                            Toggle("EPL", isOn: $enableEPL)
                            Toggle("ATP", isOn: $enableATP)
                            Toggle("WTA", isOn: $enableWTA)
                        }
                    }
                }
                
                LabeledContent("Application") {
                    VStack(alignment: .leading, spacing: 8) {
                        LaunchAtLogin.Toggle()
                        Toggle("Show icon in dock", isOn: $showIconInDock)
                        
                        Button("Check for Updates") {
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: 500, minHeight: 565, idealHeight: 800, maxHeight: .infinity)
        .onDisappear {
            NSApp.deactivate()
        }
    }
}
