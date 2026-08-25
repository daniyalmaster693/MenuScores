//
//  Leading.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactLeading: View {
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @ObservedObject var notchViewModel: NotchViewModel

    var sport: String {
        notchViewModel.sport
    }

    var league: String {
        notchViewModel.league
    }

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "F1" && sport != "Racing" && sport != "Golf" {
                HStack {
                    AsyncImage(
                        url: URL(string: {
                            let team = game.competitions[0].competitors?[1].team

                            if sport == "volleyball" {
                                return darkLogoURL(
                                    from: team?.logo,
                                    teamID: team?.id,
                                    league: league
                                ) ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                            } else {
                                return darkLogoURL(
                                    from: team?.logo,
                                    teamID: team?.id,
                                    league: league
                                ) ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport.lowercased()).png&h=80&w=80&scale=crop&cquality=40"
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
                    Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))
                }
//                .onChange(of: game.competitions[0].competitors?[1].score) { newScore in
//                    guard newScore != nil else { return }
//                    guard sport != "Basketball" else { return }
//
//                    NotchViewModel.shared.triggerAlert()
//                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                            Text(screen.localizedName)
                                .tag(index)
                        }
                    }
                    .onChange(of: notchScreenIndex) { newIndex in
                        let screens = NSScreen.screens
                        guard screens.indices.contains(newIndex) else { return }

                        let targetScreen = screens[newIndex]

                        Task {
                            await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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
                    AsyncImage(
                        url: URL(
                            string:
                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                        )
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
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                            Text(screen.localizedName)
                                .tag(index)
                        }
                    }
                    .onChange(of: notchScreenIndex) { newIndex in
                        let screens = NSScreen.screens
                        guard screens.indices.contains(newIndex) else { return }

                        let targetScreen = screens[newIndex]

                        Task {
                            await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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

        if sport == "F1" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                    )
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
            .contextMenu {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                        Text(screen.localizedName)
                            .tag(index)
                    }
                }
                .onChange(of: notchScreenIndex) { newIndex in
                    let screens = NSScreen.screens
                    guard screens.indices.contains(newIndex) else { return }

                    let targetScreen = screens[newIndex]

                    Task {
                        await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
                    )
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
            .contextMenu {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                        Text(screen.localizedName)
                            .tag(index)
                    }
                }
                .onChange(of: notchScreenIndex) { newIndex in
                    let screens = NSScreen.screens
                    guard screens.indices.contains(newIndex) else { return }

                    let targetScreen = screens[newIndex]

                    Task {
                        await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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

        if sport == "Tennis" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40"
                    )
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
            .contextMenu {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                        Text(screen.localizedName)
                            .tag(index)
                    }
                }
                .onChange(of: notchScreenIndex) { newIndex in
                    let screens = NSScreen.screens
                    guard screens.indices.contains(newIndex) else { return }

                    let targetScreen = screens[newIndex]

                    Task {
                        await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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

        if sport == "Fighting" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-mma.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                    )
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
            .contextMenu {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(Array(NSScreen.screens.enumerated()), id: \.offset) { index, screen in
                        Text(screen.localizedName)
                            .tag(index)
                    }
                }
                .onChange(of: notchScreenIndex) { newIndex in
                    let screens = NSScreen.screens
                    guard screens.indices.contains(newIndex) else { return }

                    let targetScreen = screens[newIndex]

                    Task {
                        await NotchViewModel.shared.notch?.updateScreen(on: targetScreen)
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
