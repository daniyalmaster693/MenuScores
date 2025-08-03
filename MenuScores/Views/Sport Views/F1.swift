//
//  F1.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-03.
//

import SwiftUI

struct F1Menu: View {
    let title: String
    @ObservedObject var viewModel: GamesListView
    let league: String
    let fetchURL: URL

    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

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
                        } label: {
                            HStack {
                                Image(systemName: "pin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Pin Race to Menubar")
                            }
                        }

                        Button {
                            // Add your notch pinning logic here
                        } label: {
                            HStack {
                                Image(systemName: "macbook")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Pin Race to Notch")
                            }
                        }

                        Divider()

                        Menu {
                            let competitors = game.competitions[4].competitors ?? []

                            ForEach(competitors, id: \.id) { competitor in
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
            } else {
                Text("Loading games...")
                    .foregroundColor(.gray)
                    .padding()
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
                    currentTitle = displayText(for: updatedGame, league: league)
                    let newState = updatedGame.status.type.state

                    if notiGameStart {
                        if previousGameState != "in" && newState == "in" {
                            gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                        }
                    }

                    if notiGameComplete {
                        if previousGameState != "post" && newState == "post" {
                            gameCompleteNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                        }
                    }

                    previousGameState = newState
                    currentGameState = newState
                }
            }
        }
    }
}
