//
//  LeagueSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import SwiftUI

struct LeagueSettingsView: View {
    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true
    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = true
    @AppStorage("enableUEFA") private var enableUEFA = true
    @AppStorage("enableEPL") private var enableEPL = true
    @AppStorage("enableESP") private var enableESP = true
    @AppStorage("enableGER") private var enableGER = true
    @AppStorage("enableITA") private var enableITA = true
    @AppStorage("enableNLL") private var enableNLL = true

    var body: some View {
        VStack(spacing: 4) {
            Text("Leagues")
                .font(.title2)
                .bold()

            Form {
                Section("Major Leagues") {
                    Toggle(isOn: $enableNHL) {
                        HStack {
                            Image(systemName: "hockey.puck")
                                .foregroundColor(.secondary)
                            Text("NHL")
                        }
                    }
                    
                    Toggle(isOn: $enableNFL) {
                        HStack {
                            Image(systemName: "football")
                                .foregroundColor(.secondary)
                            Text("NFL")
                        }
                    }
                                  
                    Toggle(isOn: $enableMLB) {
                        HStack {
                            Image(systemName: "baseball")
                                .foregroundColor(.secondary)
                            Text("MLB")
                        }
                    }
                                  
                    Toggle(isOn: $enableF1) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("F1")
                        }
                    }
                                  
                    Toggle(isOn: $enableNLL) {
                        HStack {
                            Image(systemName: "figure.lacrosse")
                                .foregroundColor(.secondary)
                            Text("NLL")
                        }
                    }
                }
                
                Section("Basketball") {
                    Toggle(isOn: $enableNBA) {
                        HStack {
                            Image(systemName: "basketball")
                                .foregroundColor(.secondary)
                            Text("NBA")
                        }
                    }
                    
                    Toggle(isOn: $enableWNBA) {
                        HStack {
                            Image(systemName: "basketball")
                                .foregroundColor(.secondary)
                            Text("WNBA")
                        }
                    }
                    
                    Toggle(isOn: $enableNCAAM) {
                        HStack {
                            Image(systemName: "basketball")
                                .foregroundColor(.secondary)
                            Text("Men's College Basketball")
                        }
                    }
                    
                    Toggle(isOn: $enableNCAAF) {
                        HStack {
                            Image(systemName: "basketball")
                                .foregroundColor(.secondary)
                            Text("Women's College Basketball")
                        }
                    }
                }

                Section("Soccer") {
                    Toggle(isOn: $enableUEFA) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Champions League")
                        }
                    }
                    
                    Toggle(isOn: $enableEPL) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Premier League")
                        }
                    }
                    
                    Toggle(isOn: $enableESP) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("LALIGA")
                        }
                    }
                    
                    Toggle(isOn: $enableGER) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("German Bundesliga")
                        }
                    }
                    
                    Toggle(isOn: $enableITA) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Italian Serie A")
                        }
                    }
                }
                
                Section("Golf") {
                    Toggle(isOn: $enablePGA) {
                        HStack {
                            Image(systemName: "figure.golf")
                                .foregroundColor(.secondary)
                            Text("PGA")
                        }
                    }

                    Toggle(isOn: $enableLPGA) {
                        HStack {
                            Image(systemName: "figure.golf")
                                .foregroundColor(.secondary)
                            Text("LPGA")
                        }
                    }
                }
            }
        }.formStyle(.grouped)
    }
}
