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
    @AppStorage("enableHNCAAM") private var enableHNCAAM = true
    @AppStorage("enableHNCAAF") private var enableHNCAAF = true

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableCFL") private var enableCFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = true

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = true
    @AppStorage("enableSNCAA") private var enableSNCAA = true

    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enableMotoGP") private var enableMotoGP = true

    @AppStorage("enableUFC") private var enableUFC = true

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = true

    @AppStorage("enableUEFA") private var enableUEFA = true
    @AppStorage("enableEPL") private var enableEPL = true
    @AppStorage("enableESP") private var enableESP = true
    @AppStorage("enableGER") private var enableGER = true
    @AppStorage("enableITA") private var enableITA = true

    @AppStorage("enableATP") private var enableATP = true
    @AppStorage("enableWTA") private var enableWTA = true

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = true
    @AppStorage("enableLNCAAM") private var enableLNCAAM = true
    @AppStorage("enableLNCAAF") private var enableLNCAAF = true

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

                Section("Racing") {
                    Toggle(isOn: $enableF1) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("F1")
                        }
                    }

                    Toggle(isOn: $enableMotoGP) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("Moto GP")
                        }
                    }
                }

                Section("Tennis") {
                    Toggle(isOn: $enableATP) {
                        HStack {
                            Image(systemName: "tennis.racket")
                                .foregroundColor(.secondary)
                            Text("ATP Tour")
                        }
                    }

                    Toggle(isOn: $enableWTA) {
                        HStack {
                            Image(systemName: "tennis.racket")
                                .foregroundColor(.secondary)
                            Text("WTA Tour")
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

                Section("Fighting") {
                    Toggle(isOn: $enableUFC) {
                        HStack {
                            Image(systemName: "figure.boxing")
                                .foregroundColor(.secondary)
                            Text("UFC")
                        }
                    }
                }
            }
        }.formStyle(.grouped)
    }
}
