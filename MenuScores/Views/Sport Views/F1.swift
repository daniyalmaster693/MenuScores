//
//  F1.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-03.
//

import DynamicNotchKit
import SwiftUI

struct F1Menu: View {
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
            F1MenuContent(
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

private struct F1MenuContent: View {
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
            if !viewModel.games.isEmpty {
                ForEach(Array(viewModel.games.enumerated()), id: \.1.id) { _, game in
                    if let country = game.circuit?.address.country {
                        Menu(country) {
                            Text(formattedDate(from: game.endDate ?? "Invalid Date"))
                                .font(.headline)
                            Divider().padding(.bottom)
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
                                        Text("Pin Race to Menubar")
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
                                                Info(notchViewModel: notchViewModel, sport: "F1", league: "\(league)")
                                            } compactLeading: {
                                                CompactLeading(notchViewModel: notchViewModel, sport: "F1")
                                            } compactTrailing: {
                                                CompactTrailing(notchViewModel: notchViewModel, sport: "F1")
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
                                            Text("Pin Race to Notch")
                                        }
                                    }
                                }

                                Divider()

                                if game.competitions[4].status.type.state == "in" || game.competitions[4].status.type.state == "post" {
                                    Menu {
                                        let competitors = game.competitions[4].competitors ?? []

                                        ForEach(competitors.filter { $0.order != nil }, id: \.id) { competitor in
                                            Button {} label: {
                                                HStack {
                                                    Text("\(competitor.order ?? 0). \(competitor.athlete?.displayName ?? "Unknown")")
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                }
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "flag.checkered")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("Leaderboard")
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
                                        Text("View Race Details")
                                    }
                                }
                            } label: {
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
                                    .frame(width: 40, height: 40)

                                    Text(displayText(for: game, league: league))
                                }
                            }
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
