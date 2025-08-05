//
//  LeagueSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-07-10.
//

import SwiftUI

struct LeagueSettingsView: View {
    // Toggled League Settings

    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableHNCAAM") private var enableHNCAAM = false
    @AppStorage("enableHNCAAF") private var enableHNCAAF = false

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = false
    @AppStorage("enableNCAAM") private var enableNCAAM = false
    @AppStorage("enableNCAAF") private var enableNCAAF = false

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableCFL") private var enableCFL = false
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableF1") private var enableF1 = true

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = false

    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = false
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    // League Settings View

    var body: some View {
        VStack(spacing: 4) {
            Text("Leagues")
                .font(.title2)
                .bold()

            Form {
                Section("Hockey") {
                    Toggle(isOn: $enableNHL) {
                        HStack {
                            Image(systemName: "hockey.puck")
                                .foregroundColor(.secondary)
                            Text("NHL")
                        }
                    }

                    Toggle(isOn: $enableHNCAAM) {
                        HStack {
                            Image(systemName: "hockey.puck")
                                .foregroundColor(.secondary)
                            Text("Men's College Hockey")
                        }
                    }

                    Toggle(isOn: $enableHNCAAF) {
                        HStack {
                            Image(systemName: "hockey.puck")
                                .foregroundColor(.secondary)
                            Text("Women's College Hockey")
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

                Section("Football") {
                    Toggle(isOn: $enableNFL) {
                        HStack {
                            Image(systemName: "football")
                                .foregroundColor(.secondary)
                            Text("NFL")
                        }
                    }

                    Toggle(isOn: $enableCFL) {
                        HStack {
                            Image(systemName: "football")
                                .foregroundColor(.secondary)
                            Text("CFL")
                        }
                    }

                    Toggle(isOn: $enableFNCAA) {
                        HStack {
                            Image(systemName: "football")
                                .foregroundColor(.secondary)
                            Text("College Football")
                        }
                    }
                }

                Section("Baseball") {
                    Toggle(isOn: $enableMLB) {
                        HStack {
                            Image(systemName: "baseball")
                                .foregroundColor(.secondary)
                            Text("MLB")
                        }
                    }

                    Toggle(isOn: $enableBNCAA) {
                        HStack {
                            Image(systemName: "baseball")
                                .foregroundColor(.secondary)
                            Text("College Baseball")
                        }
                    }

                    Toggle(isOn: $enableSNCAA) {
                        HStack {
                            Image(systemName: "baseball")
                                .foregroundColor(.secondary)
                            Text("College Softball")
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

                    Toggle(isOn: $enableMLS) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("MLS")
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
                            Text("La Liga")
                        }
                    }

                    Toggle(isOn: $enableGER) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Bundesliga")
                        }
                    }

                    Toggle(isOn: $enableITA) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Serie A")
                        }
                    }

                    Toggle(isOn: $enableMEX) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Liga MX")
                        }
                    }

                    Toggle(isOn: $enableFRA) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Ligue 1")
                        }
                    }

                    Toggle(isOn: $enableNED) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Eredivisie")
                        }
                    }

                    Toggle(isOn: $enablePOR) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("Primeira Liga")
                        }
                    }
                }

                Section("Racing") {
                    Toggle(isOn: $enableF1) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("F1")
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

                Section("Lacrosse") {
                    Toggle(isOn: $enableNLL) {
                        HStack {
                            Image(systemName: "figure.lacrosse")
                                .foregroundColor(.secondary)
                            Text("NLL")
                        }
                    }

                    Toggle(isOn: $enablePLL) {
                        HStack {
                            Image(systemName: "figure.lacrosse")
                                .foregroundColor(.secondary)
                            Text("PLL")
                        }
                    }

                    Toggle(isOn: $enableLNCAAM) {
                        HStack {
                            Image(systemName: "figure.lacrosse")
                                .foregroundColor(.secondary)
                            Text("Men's College Lacrosse")
                        }
                    }

                    Toggle(isOn: $enableLNCAAF) {
                        HStack {
                            Image(systemName: "figure.lacrosse")
                                .foregroundColor(.secondary)
                            Text("Women's College Lacrosse")
                        }
                    }
                }

                Section("Volleyball") {
                    Toggle(isOn: $enableVNCAAM) {
                        HStack {
                            Image(systemName: "volleyball")
                                .foregroundColor(.secondary)
                            Text("Men's College Volleyball")
                        }
                    }

                    Toggle(isOn: $enableVNCAAF) {
                        HStack {
                            Image(systemName: "volleyball")
                                .foregroundColor(.secondary)
                            Text("Women's College Volleyball")
                        }
                    }
                }
            }
        }.formStyle(.grouped)
    }
}
