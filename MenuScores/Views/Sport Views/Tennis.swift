//
//  Tennis.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-11-22.
//

import DynamicNotchKit
import SwiftUI

struct TennisMenu: View {
    let title: String
    @ObservedObject var viewModel: TennisListView
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
            if !viewModel.tennisGames.isEmpty {
                ForEach(Array(viewModel.tennisGames.enumerated()), id: \.1.id) { _, game in
                    Menu {
                        ForEach(game.groupings, id: \.grouping.id) { group in
                            Menu(group.grouping.displayName) {
                                let groupedGames = Dictionary(grouping: group.competitions) { competition in
                                    formattedDate(from: competition.date)
                                }

                                let sortedDates = groupedGames.keys.sorted()

                                if sortedDates.isEmpty {
                                    Text("No Games Scheduled")
                                } else {
                                    ForEach(sortedDates, id: \.self) { date in
                                        if let gamesForDate = groupedGames[date] {
                                            Menu(date) {
                                                ForEach(gamesForDate, id: \.id) { competition in
                                                    Menu {} label: {
                                                        HStack {
                                                            AsyncImage(
                                                                url: URL(string: competition.competitors?.first?.athlete?.flag?.href ?? competition.competitors?.first?.roster?.athletes?.first?.flag?.href ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40")
                                                            ) { image in
                                                                image.resizable().scaledToFit()
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                            .frame(width: 40, height: 40)

                                                            Text("\(competition.competitors?.first?.athlete?.shortName ?? competition.competitors?.first?.roster?.shortDisplayName ?? "Player 1") - \(competition.competitors?.dropFirst().first?.athlete?.shortName ?? competition.competitors?.dropFirst().first?.roster?.shortDisplayName ?? "Player 2")")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(string: "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40")
                            ) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(game.shortName ?? "")
                        }
                    }
                }
            } else {
                Text("Loading games...")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            LeagueSelectionModel.shared.currentLeague = league
            Task {
                await viewModel.populateTennis(from: fetchURL)
            }
        }
//        .onReceive(
//            Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()
//        ) { _ in
//            Task {
//                await viewModel.populateTennis(from: fetchURL)
//                if let updatedGame = viewModel.tennisGames.first(where: { $0.id == currentGameID }) {
//                    if pinnedByMenubar {
//                        currentTitle = displayText(for: updatedGame, league: league)
//                    } else if pinnedByNotch {
//                        currentTitle = ""
//                    }
//
//                    let newState = updatedGame.status.type.state
//
//                    if notiGameStart && previousGameState != "in" && newState == "in" {
//                        gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
//                    }
//                    if notiGameComplete && previousGameState != "post" && newState == "post" {
//                        gameCompleteNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
//                    }
//
//                    previousGameState = newState
//                    currentGameState = newState
//
//                    if pinnedByNotch {
//                        notchViewModel.game = updatedGame
//                    }
//                }
//            }
//        }
    }
}
