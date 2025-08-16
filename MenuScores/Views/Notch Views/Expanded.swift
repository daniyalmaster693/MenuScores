//
//  Expanded.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import Sparkle
import SwiftUI

struct Info: View {
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
            if sport != "Racing" && sport != "Golf" {
                HStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                AsyncImage(
                                    url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.black
                                }
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 3)

                                VStack {
                                    Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                                        .font(.system(size: 22, weight: .medium))

                                    Text("\(game.competitions[0].competitors?[1].team?.abbreviation ?? "")")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                        }
                    }

                    if sport == "Baseball" || sport == "Soccer" {
                        HStack(spacing: 4) {
                            if game.status.type.state == "post" {
                                Text("Final")
                                    .font(.system(size: 19, weight: .semibold))
                            } else if game.status.type.state == "pre" {
                                Text(formattedTime(from: game.date))
                                    .font(.system(size: 19, weight: .semibold))
                            } else {
                                Text("\(game.status.type.detail ?? "")")
                                    .font(.system(size: 19, weight: .semibold))
                            }
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                    }

                    if sport != "Baseball" && sport != "Soccer" {
                        HStack(spacing: 4) {
                            if game.status.type.state == "post" {
                                Text("Final")
                                    .font(.system(size: 19, weight: .semibold))
                            } else if game.status.type.state == "pre" {
                                Text(formattedTime(from: game.date))
                                    .font(.system(size: 19, weight: .semibold))
                            } else {
                                Text("P\(game.status.period ?? 0) \(game.status.displayClock ?? "")")
                                    .font(.system(size: 19, weight: .semibold))
                            }
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                    }

                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                VStack {
                                    Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                                        .font(.system(size: 22, weight: .medium))

                                    Text("\(game.competitions[0].competitors?[0].team?.abbreviation ?? "")")
                                        .font(.system(size: 12, weight: .medium))
                                }

                                AsyncImage(
                                    url: URL(string: game.competitions[0].competitors?[0].team?.logo ?? "")
                                ) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Color.black
                                }
                                .frame(width: 32, height: 32)
                                .padding(.leading, 3)
                            }
                        }
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
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string:
                                        "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 3)

                                Text("\(game.shortName)")
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.bottom, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)

                            if game.competitions[4].status.type.state == "in" || game.competitions[4].status.type.state == "post" {
                                HStack {
                                    Text("Current Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let lap = game.competitions[4].status.period {
                                        Text("L\(lap)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                VStack {
                                    let competitors = game.competitions[4].competitors ?? []

                                    ForEach(competitors.prefix(5), id: \.id) { competitor in
                                        HStack {
                                            if let flagURLString = competitor.athlete?.flag.href,
                                               let flagURL = URL(string: flagURLString)
                                            {
                                                AsyncImage(url: flagURL) { image in
                                                    image.resizable().scaledToFit()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 16, height: 16)
                                                .padding(.trailing, 3)
                                                .padding(.leading, 10)
                                            }

                                            Text("\(competitor.order ?? 0). ")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                            Text("\(competitor.athlete?.displayName ?? "Unknown")")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.padding(.top, 10)
                            }

                            if game.competitions[4].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "flag.checkered")
                                        .font(.system(size: 12))

                                    Text("Race Date: \(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
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
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string:
                                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 3)

                                Text("\(game.shortName)")
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.bottom, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)

                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                                HStack {
                                    Text("Current Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let round = game.competitions[0].status.period {
                                        Text("R\(round)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                VStack {
                                    let competitors = game.competitions[0].competitors ?? []

                                    ForEach(competitors.prefix(5), id: \.id) { competitor in
                                        HStack {
                                            HStack {
                                                if let flagURLString = competitor.athlete?.flag.href,
                                                   let flagURL = URL(string: flagURLString)
                                                {
                                                    AsyncImage(url: flagURL) { image in
                                                        image.resizable().scaledToFit()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 16, height: 16)
                                                    .padding(.trailing, 3)
                                                    .padding(.leading, 10)
                                                }

                                                Text("\(competitor.order ?? 0). ")
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)

                                                Text("\(competitor.athlete?.displayName ?? "Unknown")")
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }

                                            Text("\(competitor.score ?? "-")")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.padding(.top, 10)
                            }

                            if game.competitions[0].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "figure.golf")
                                        .font(.system(size: 12))

                                    Text("Tournament Date: \(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
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
