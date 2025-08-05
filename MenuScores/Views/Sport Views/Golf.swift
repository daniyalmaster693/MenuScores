//
//  Golf.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-02.
//

import DynamicNotchKit
import SwiftUI

struct GolfMenu: View {
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
                                    VStack {
                                        HStack(spacing: 4) {
                                            VStack {
                                                HStack {
                                                    AsyncImage(
                                                        url: URL(
                                                            string:
                                                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                                        )
                                                    ) { image in
                                                        image.resizable().scaledToFit()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 32, height: 32)
                                                    .padding(.trailing, 3)

                                                    Text("\(game.shortName)")
                                                        .font(.system(size: 18, weight: .medium))
                                                }.padding(.bottom, 7)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .padding(.leading, 10)

                                                if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                                                    HStack {
                                                        Text("Current Leaders")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .padding(.leading, 10)

                                                        Spacer()

                                                        if let round = game.competitions[0].status.period {
                                                            Text("R\(round)")
                                                                .font(.system(size: 14, weight: .semibold))
                                                                .padding(.trailing, 10)
                                                        }
                                                    }.padding(.top, 5)

                                                    VStack {
                                                        let competitors = game.competitions[0].competitors ?? []

                                                        ForEach(competitors.prefix(5), id: \.id) { competitor in
                                                            HStack {
                                                                HStack {
                                                                    if let flagURLString = competitor.athlete?.flag.href,
                                                                       let flagURL = URL(string: flagURLString)
                                                                    {
                                                                        AsyncImage(url: flagURL) { image in
                                                                            image.resizable().scaledToFit()
                                                                        } placeholder: {
                                                                            ProgressView()
                                                                        }
                                                                        .frame(width: 16, height: 16)
                                                                        .padding(.trailing, 3)
                                                                        .padding(.leading, 10)
                                                                    }

                                                                    Text("\(competitor.order ?? 0). ")
                                                                        .lineLimit(1)
                                                                        .truncationMode(.tail)

                                                                    Text("\(competitor.athlete?.displayName ?? "Unknown")")
                                                                        .lineLimit(1)
                                                                        .truncationMode(.tail)
                                                                }

                                                                Text("\(competitor.score ?? "-")")
                                                                    .lineLimit(1)
                                                                    .truncationMode(.tail)

                                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                                        }
                                                    }.padding(.top, 10)
                                                }

                                                if game.competitions[0].status.type.state == "pre" {
                                                    HStack {
                                                        Image(systemName: "figure.golf")
                                                            .font(.system(size: 12))

                                                        Text("Tournament Date: \(formattedDate(from: game.endDate ?? "Invalid Date"))")
                                                            .font(.system(size: 14, weight: .medium))
                                                    }.frame(maxWidth: .infinity, alignment: .center)
                                                }
                                            }
                                        }
                                    }
                                } compactLeading: {
                                    HStack {
                                        AsyncImage(
                                            url: URL(
                                                string:
                                                "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                            )
                                        ) { image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 18, height: 18)
                                    }
                                } compactTrailing: {
                                    HStack {
                                        if let lap = game.competitions[0].status.period {
                                            Text("R\(lap)")
                                                .font(.system(size: 14, weight: .semibold))
                                        } else {
                                            Text("R -")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
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
                                Text("Pin Race to Notch")
                            }
                        }

                        Divider()

                        if game.status.type.state == "in" || game.status.type.state == "post" {
                            Menu {
                                let competitors = game.competitions.first?.competitors ?? []
                                let topCompetitors = competitors.prefix(15)

                                ForEach(topCompetitors, id: \.id) { competitor in
                                    Button {} label: {
                                        HStack {
                                            Text("\(competitor.order ?? 0). \(competitor.athlete?.displayName ?? "Unknown") \(competitor.score ?? "-")")
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "figure.golf")
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
                                Text("View Game Details")
                            }
                        }
                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(string: leagueLogoURL(for: league))
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

private func leagueLogoURL(for league: String) -> String {
    return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
}
