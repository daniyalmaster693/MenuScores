//
//  Baseball.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import DynamicNotchKit
import KeyboardShortcuts
import SwiftUI

struct BaseballMenu: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
    let league: String
    let fetchURL: () -> URL

    @State private var pinnedByNotch = false
    @State private var pinnedByMenubar = false

    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    private var refreshInterval: TimeInterval {
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

    var body: some View {
        Menu(title) {
            let groupedGames = Dictionary(grouping: viewModel.games) { game in
                formattedDate(from: game.date)
            }

            let sortedDates = groupedGames.keys.sorted()

            if sortedDates.isEmpty {
                Text("No Games Scheduled")
            } else {
                ForEach(sortedDates, id: \.self) { date in
                    if let gamesForDate = groupedGames[date] {
                        Menu(date) {
                            ForEach(gamesForDate, id: \.id) { game in
                                Menu {
                                    Button {
                                        currentTitle = displayText(for: game, league: league)
                                        currentGameID = game.id
                                        currentGameState = game.status.type.state

                                        pinnedByMenubar = true
                                        pinnedByNotch = false
                                    } label: {
                                        HStack {
                                            Image(systemName: "menubar.rectangle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("Pin Game to Menubar")
                                        }
                                    }

                                    if enableNotch {
                                        Button {
                                            currentGameID = game.id
                                            currentGameState = game.status.type.state

                                            pinnedByNotch = true
                                            pinnedByMenubar = false

                                            Task {
                                                await NotchViewModel.shared.pinGame(
                                                    game: game,
                                                    sport: "Baseball",
                                                    league: league,
                                                    gameID: game.id,
                                                    gameState: game.status.type.state
                                                )
                                            }

                                        } label: {
                                            HStack {
                                                Image(systemName: "macbook")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                Text("Pin Game to Notch")
                                            }
                                        }
                                    }

                                    Button {
                                        if let urlString = game.links?.first?.href, let url = URL(string: urlString) {
                                            NSWorkspace.shared.open(url)
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "info.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("View Game Details")
                                        }
                                    }
                                } label: {
                                    HStack {
                                        AsyncImage(
                                            url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-baseball.png&h=80&w=80&scale=crop&cquality=40")
                                        ) { image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)

                                        Text(displayText(for: game, league: league))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            RefreshManager.shared.registerRefreshAction(
                for: league,
                currentGameID: $currentGameID,
                currentGameState: $currentGameState,
                currentTitle: $currentTitle
            ) {
                Task {
                    await RefreshManager.shared.performRefresh(
                        viewModel: viewModel,
                        league: league,
                        fetchURL: fetchURL,
                        currentTitle: $currentTitle,
                        currentGameID: $currentGameID,
                        currentGameState: $currentGameState,
                        previousGameState: $previousGameState,
                        type: .standard,
                        pinnedByMenubar: $pinnedByMenubar,
                        pinnedByNotch: $pinnedByNotch,
                        notchViewModel: NotchViewModel.shared
                    )
                }
            }
        }
        .onDisappear {
            RefreshManager.shared.unregisterRefreshAction(for: league)
        }
    }
}
