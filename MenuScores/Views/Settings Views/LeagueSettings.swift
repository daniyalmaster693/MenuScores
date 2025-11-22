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
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enableNC") private var enableNC = false
    @AppStorage("enableNCS") private var enableNCS = false
    @AppStorage("enableNCT") private var enableNCT = false
    @AppStorage("enableIRL") private var enableIRL = false

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = false

    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableFFWC") private var enableFFWC = false
    @AppStorage("enableFFWCQUEFA") private var enableFFWCQUEFA = false
    @AppStorage("enableCONCACAF") private var enableCONCACAF = false
    @AppStorage("enableCONMEBOL") private var enableCONMEBOL = false
    @AppStorage("enableCAF") private var enableCAF = false
    @AppStorage("enableAFC") private var enableAFC = false
    @AppStorage("enableOFC") private var enableOFC = false

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = true
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    // League Settings View

    var body: some View {
        VStack(spacing: 4) {
            Text("Leagues")
                .font(.title2)
                .bold()

            Form {
                Section {
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
                } header: {
                    HStack(spacing: 4) {
                        HStack {
                            Text("Hockey")
                                .font(.headline)
                            Spacer()

                            Button(action: {
                                enableNHL = false
                                enableHNCAAM = false
                                enableHNCAAF = false
                                enableNBA = false
                                enableWNBA = false
                                enableNCAAM = false
                                enableNCAAF = false
                                enableNFL = false
                                enableFNCAA = false
                                enableMLB = false
                                enableBNCAA = false
                                enableSNCAA = false
                                enableF1 = false
                                enableNC = false
                                enableNCS = false
                                enableNCT = false
                                enableIRL = false
                                enablePGA = false
                                enableLPGA = false
                                enableUEFA = false
                                enableMLS = false
                                enableMEX = false
                                enableFRA = false
                                enableNED = false
                                enablePOR = false
                                enableEPL = false
                                enableESP = false
                                enableGER = false
                                enableITA = false
                                enableNLL = false
                                enablePLL = false
                                enableLNCAAM = false
                                enableLNCAAF = false
                                enableVNCAAM = false
                                enableVNCAAF = false
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle")
                                    Text("Disable All")
                                }
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
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
                    Toggle(isOn: $enableMLS) {
                        HStack {
                            Image(systemName: "soccerball")
                                .foregroundColor(.secondary)
                            Text("MLS")
                        }
                    }

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

                Section("FIFA World Cup") {
                    Toggle(isOn: $enableFFWC) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup")
                        }
                    }

                    Toggle(isOn: $enableFFWCQUEFA) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup UEFA Qualifiers")
                        }
                    }

                    Toggle(isOn: $enableCONMEBOL) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup COMEBOL Qualifiers")
                        }
                    }

                    Toggle(isOn: $enableCONCACAF) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup CONCACAF Qualifiers")
                        }
                    }

                    Toggle(isOn: $enableCAF) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup African Qualifiers")
                        }
                    }

                    Toggle(isOn: $enableAFC) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup Asian Qualifiers")
                        }
                    }

                    Toggle(isOn: $enableOFC) {
                        HStack {
                            Image(systemName: "trophy")
                                .foregroundColor(.secondary)
                            Text("FIFA World Cup Oceanian Qualifiers")
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

                    Toggle(isOn: $enableNC) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("Nascar Premier")
                        }
                    }

                    Toggle(isOn: $enableNCS) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("Nascar Secondary")
                        }
                    }

                    Toggle(isOn: $enableNCT) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("Nascar Truck")
                        }
                    }

                    Toggle(isOn: $enableIRL) {
                        HStack {
                            Image(systemName: "flag.checkered")
                                .foregroundColor(.secondary)
                            Text("IndyCar")
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
