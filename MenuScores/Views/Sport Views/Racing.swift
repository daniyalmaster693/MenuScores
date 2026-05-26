//
//  Racing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-22.
//

import DynamicNotchKit
import SwiftUI

struct RacingMenu: View {
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
            RacingMenuContent(
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

private struct RacingMenuContent: View {
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
            Text(formattedDate(from: viewModel.games.first?.date ?? "Invalid Date"))
                .font(.headline)
            Divider().padding(.bottom)

            if !viewModel.games.isEmpty {
                ForEach(Array(viewModel.games.enumerated()), id: \.1.id) { _, game in
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
                                        Info(notchViewModel: notchViewModel, sport: "Racing", league: "\(league)")
                                    } compactLeading: {
                                        CompactLeading(notchViewModel: notchViewModel, sport: "Racing")
                                    } compactTrailing: {
                                        CompactTrailing(notchViewModel: notchViewModel, sport: "Racing")
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

                        if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                            Menu {
                                let competitors = game.competitions[0].competitors ?? []

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

                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(
                                    string:
                                    "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
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
            } else {
                Text("Loading games...")
                    .foregroundColor(.gray)
                    .padding()
            }
    }
}
