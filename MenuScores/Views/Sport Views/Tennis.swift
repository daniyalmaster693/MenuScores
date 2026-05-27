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
    var viewModel: TennisListView
    let league: String
    let fetchURL: URL


    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

       var body: some View {
        LeagueMenuShell(title: title, league: league, onAppearAction: {
            LeagueSelectionModel.shared.currentLeague = league
            Task {
                await viewModel.populateTennis(from: fetchURL)
            }
        }) {
            TennisMenuContent(
                title: title,
                viewModel: viewModel,
                league: league,
                fetchURL: fetchURL,
                currentTitle: $currentTitle,
                currentGameID: $currentGameID,
                currentGameState: $currentGameState,
                previousGameState: $previousGameState
            )
        }
    }
}

private struct TennisMenuContent: View {
    let title: String
    @ObservedObject var viewModel: TennisListView
    let league: String
    let fetchURL: URL


    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

       @StateObject private var notchViewModel = NotchViewModel()

    var body: some View {
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
                                                    let team1 = competition.competitors?.first?.athlete?.shortName ?? competition.competitors?.first?.roster?.shortDisplayName ?? "Player 1"
                                                    let team2 = competition.competitors?.dropFirst().first?.athlete?.shortName ?? competition.competitors?.dropFirst().first?.roster?.shortDisplayName ?? "Player 2"

                                                    let tennisTitle = "\(team1) - \(team2)"

                                                    Menu {
                                                        Button {
                                                            currentTitle = tennisTitle
                                                            currentGameID = game.id
                                                            currentGameState = game.status.type.state
                                                            LeagueSelectionModel.shared.setPinnedDetailURL(from: game)

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

                                                                notchViewModel.tennisCompetition = competition
                                                                NotchViewModel.shared.currentGameID = game.id

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
                                                                        Info(notchViewModel: notchViewModel, sport: "Tennis", league: "\(league)")
                                                                    } compactLeading: {
                                                                        CompactLeading(notchViewModel: notchViewModel, sport: "Tennis")
                                                                    } compactTrailing: {
                                                                        CompactTrailing(notchViewModel: notchViewModel, sport: "Tennis")
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
                                                    } label: {
                                                        HStack {
                                                            AsyncImage(
                                                                url: URL(string: competition.competitors?.first?.athlete?.flag?.href ?? competition.competitors?.first?.roster?.athletes?.first?.flag?.href ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40")
                                                            ) { image in
                                                                image.resizable().scaledToFit()
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                            .frame(width: 40, height: 40)

                                                            Text("\(tennisTitle)")
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
}
