//
//  Basketball.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import DynamicNotchKit
import SwiftUI

struct BasketballMenu: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
    let league: String
    let fetchURL: URL

    @StateObject private var notchViewModel = NotchViewModel()

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

                                            notchViewModel.game = game

                                            Task {
                                                if let existingNotch = NotchViewModel.shared.notch {
                                                    await existingNotch.hide()
                                                    NotchViewModel.shared.game = nil
                                                    NotchViewModel.shared.currentGameID = ""
                                                    NotchViewModel.shared.currentGameState = ""
                                                    NotchViewModel.shared.previousGameState = ""
                                                    NotchViewModel.shared.notch = nil
                                                }

                                                let newNotch = DynamicNotch(
                                                    hoverBehavior: .all,
                                                    style: .notch
                                                ) {
                                                    Info(notchViewModel: notchViewModel, sport: "Basketball", league: "\(league)")
                                                } compactLeading: {
                                                    CompactLeading(notchViewModel: notchViewModel, sport: "Basketball")
                                                } compactTrailing: {
                                                    CompactTrailing(notchViewModel: notchViewModel, sport: "Basketball")
                                                }

                                                NotchViewModel.shared.notch = newNotch
                                                await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
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
                                            url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-basketball.png&h=80&w=80&scale=crop&cquality=40")
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
            LeagueSelectionModel.shared.currentLeague = league
            Task {
                await viewModel.populateGames(from: fetchURL)
            }
        }
        .onReceive(
            Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()
        ) { _ in
            Task {
                await viewModel.populateGames(from: fetchURL)
                if let updatedGame = viewModel.games.first(where: { $0.id == currentGameID }) {
                    if pinnedByMenubar {
                        currentTitle = displayText(for: updatedGame, league: league)
                    } else if pinnedByNotch {
                        currentTitle = ""
                    }

                    let newState = updatedGame.status.type.state

                    if notiGameStart && previousGameState != "in" && newState == "in" {
                        gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                    }
                    if notiGameComplete && previousGameState != "post" && newState == "post" {
                        gameCompleteNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                    }

                    previousGameState = newState
                    currentGameState = newState

                    if pinnedByNotch {
                        notchViewModel.game = updatedGame
                    }
                }
            }
        }
    }
}
