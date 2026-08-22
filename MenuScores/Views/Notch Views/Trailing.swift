//
//  Trailing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactTrailing: View {
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @ObservedObject var notchViewModel: NotchViewModel
    var sport: String

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "F1" && sport != "Racing" && sport != "Golf" {
                HStack {
                    Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))

                    AsyncImage(
                        url: URL(string: {
                            if sport == "volleyball" {
                                return game.competitions[0].competitors?[0].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                            } else {
                                return game.competitions[0].competitors?[0].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport.lowercased()).png&h=80&w=80&scale=crop&cquality=40"
                            }
                        }())
                    ) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .interpolation(.high)
                                .scaledToFit()
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        } else {
                            Color.clear
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .onChange(of: game.competitions[0].competitors?[0].score) { newScore in
                    guard newScore != nil else { return }

                    guard NotchViewModel.shared.currentGameID == game.id else {
                        return
                    }

                    guard NotchViewModel.shared.sport != "Basketball" else {
                        return
                    }

                    NotchViewModel.shared.triggerAlert()
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "Golf" {
                HStack {
                    if let round = game.competitions[0].status.period {
                        Text("R\(round)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("R -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let race = notchViewModel.racingCompetition {
            if sport == "F1" {
                HStack {
                    if let lap = race.fullStatus.period {
                        Text("L\(lap)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("L -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "Racing" {
                HStack {
                    if let lap = race.fullStatus.period {
                        Text("L\(lap)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("L -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let tennisGame = notchViewModel.tennisCompetition {
            if sport == "Tennis" {
                HStack {
                    if let set = tennisGame.status?.period {
                        Text("S\(set)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("S -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let fight = notchViewModel.fightCompetition {
            if sport == "Fighting" {
                HStack {
                    if let round = fight.status.period {
                        Text("R\(round)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("R -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }
    }
}
