//
//  Soccer.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import SwiftUI

struct SoccerMenu: View {
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
                    Button {
                        currentTitle = displayText(for: game, league: league)
                        currentGameID = game.id
                        currentGameState = game.status.type.state
                    } label: {
                        AsyncImage(
                            url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")
                        ) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)

                        Text(displayText(for: game, league: league))
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
