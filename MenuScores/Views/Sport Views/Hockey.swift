//
//  Hockey.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import DynamicNotchKit
import SwiftUI

struct HockeyMenu: View {
    let title: String
    var viewModel: GamesListView
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
                await viewModel.populateGames(from: fetchURL)
            }
        }) {
            HockeyMenuContent(
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

private struct HockeyMenuContent: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
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

                                            notchViewModel.game = game
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
                                                    Info(notchViewModel: notchViewModel, sport: "Hockey", league: "\(league)")
                                                } compactLeading: {
                                                    CompactLeading(notchViewModel: notchViewModel, sport: "Hockey")
                                                } compactTrailing: {
                                                    CompactTrailing(notchViewModel: notchViewModel, sport: "Hockey")
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
                                            url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-hockey.png&h=80&w=80&scale=crop&cquality=40")
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
}
