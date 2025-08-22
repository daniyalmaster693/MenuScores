//
//  Trailing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import Sparkle
import SwiftUI

struct CompactTrailing: View {
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @ObservedObject var notchViewModel: NotchViewModel
    var sport: String

    // Sparkle Updater Closure

    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    private var updater: SPUUpdater {
        updaterController.updater
    }

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "F1" && sport != "Racing" && sport != "Golf" {
                HStack {
                    Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                        .font(.system(size: 14, weight: .semibold))

                    AsyncImage(
                        url: URL(string: game.competitions[0].competitors?[0].team?.logo ?? "")
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.black
                    }
                    .frame(width: 18, height: 18)
                }.contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "F1" {
                HStack {
                    if let lap = game.competitions[4].status.period {
                        Text("L\(lap)")
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("L -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }.contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

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
                    if let lap = game.competitions[0].status.period {
                        Text("L\(lap)")
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("L -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }.contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

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
                    if let lap = game.competitions[0].status.period {
                        Text("R\(lap)")
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("R -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }.contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

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
