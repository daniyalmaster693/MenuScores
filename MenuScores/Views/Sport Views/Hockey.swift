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
                                Text("Pin Game to Menubar")
                            }
                        }

                        Button {
                            Task {
                                let notch = DynamicNotch(
                                    hoverBehavior: .all,
                                    style: .notch
                                ) {
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
                                                        Color.gray
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

                                        HStack(spacing: 4) {
                                            if game.status.type.state == "post" {
                                                Text("Final")
                                                    .font(.system(size: 19, weight: .semibold))
                                            } else if game.status.type.state == "pre" {
                                                Text("Pre")
                                                    .font(.system(size: 19, weight: .semibold))
                                            } else {
                                                Text("P\(game.status.period ?? 0) \(game.status.displayClock ?? "")")
                                                    .font(.system(size: 19, weight: .semibold))
                                            }
                                        }
                                        .padding(.leading, 30)
                                        .padding(.trailing, 30)

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
                                                        Color.gray
                                                    }
                                                    .frame(width: 32, height: 32)
                                                    .padding(.leading, 3)
                                                }
                                            }
                                        }
                                    }
                                } compactLeading: {
                                    HStack(spacing: 4) {
                                        AsyncImage(
                                            url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")
                                        ) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 18, height: 18)
                                        .padding(.trailing, 3)

                                        Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                } compactTrailing: {
                                    HStack(spacing: 4) {
                                        Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                                            .font(.system(size: 14, weight: .semibold))

                                        AsyncImage(
                                            url: URL(string: game.competitions[0].competitors?[0].team?.logo ?? "")
                                        ) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 18, height: 18)
                                        .padding(.leading, 3)
                                    }
                                }

                                DynamicNotchManager.shared.currentNotch = notch

                                await notch.expand()
                                try await Task.sleep(for: .seconds(2))
                                await notch.compact()
                                try await Task.sleep(for: .seconds(2))
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

                    if notiGameStart && previousGameState != "in" && newState == "in" {
                        gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                    }
                    if notiGameComplete && previousGameState != "post" && newState == "post" {
                        gameCompleteNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                    }

                    previousGameState = newState
                    currentGameState = newState
                }
            }
        }
    }
}
