//
//  MenuScoresApp.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import SwiftUI

class LeagueSelectionModel: ObservableObject {
    @Published var currentLeague: String = ""
}

extension LeagueSelectionModel {
    static let shared = LeagueSelectionModel()
}

func openSettings() {
    let environment = EnvironmentValues()
    environment.openSettings()
    NSApp.setActivationPolicy(.regular)
    NSApp.activate(ignoringOtherApps: true)
}

@main
struct MenuScoresApp: App {
    @State var currentTitle: String = "Select a Game"
    @State var currentGameID: String = "0"
    
    @StateObject private var nhlVM = GamesListView()
    @StateObject private var nbaVM = GamesListView()
    @StateObject private var nflVM = GamesListView()
    @StateObject private var mlbVM = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            Menu("NHL Games") {
                Text(formattedDate(from: nhlVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !nhlVM.games.isEmpty {
                    ForEach(Array(nhlVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NHL")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NHL"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NHL"
                Task {
                    await nhlVM.populateGames(from: Scoreboard.Urls.nhl)
                }
            }
            .onReceive(Timer.publish(every: 20, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nhlVM.populateGames(from: Scoreboard.Urls.nhl)
                    if let updatedGame = nhlVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NHL")
                    }
                }
            }
            
            Menu("NBA Games") {
                Text(formattedDate(from: nbaVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !nbaVM.games.isEmpty {
                    ForEach(Array(nbaVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NBA")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NBA"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NBA"
                Task {
                    await nbaVM.populateGames(from: Scoreboard.Urls.nba)
                }
            }
            .onReceive(Timer.publish(every: 20, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nbaVM.populateGames(from: Scoreboard.Urls.nba)
                    if let updatedGame = nbaVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NBA")
                    }
                }
            }
            
            Menu("NFL Games") {
                Text(formattedDate(from: nflVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !nflVM.games.isEmpty {
                    ForEach(Array(nflVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NFL")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NFL"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NFL"
                Task {
                    await nflVM.populateGames(from: Scoreboard.Urls.nfl)
                }
            }
            .onReceive(Timer.publish(every: 20, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nflVM.populateGames(from: Scoreboard.Urls.nfl)
                    if let updatedGame = nflVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NFL")
                    }
                }
            }
            
            Menu("MLB Games") {
                Text(formattedDate(from: mlbVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !mlbVM.games.isEmpty {
                    ForEach(Array(mlbVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "MLB")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "MLB"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "MLB"
                Task {
                    await mlbVM.populateGames(from: Scoreboard.Urls.mlb)
                }
            }
            .onReceive(Timer.publish(every: 20, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await mlbVM.populateGames(from: Scoreboard.Urls.mlb)
                    if let updatedGame = mlbVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "MLB")
                    }
                }
            }

            Divider()

            Button {
                currentTitle = "Select a Game"
                currentGameID = "3"
            } label: {
                Text("Clear Set Game")
            }
            .keyboardShortcut("c")
            
            Button {
                openSettings()
            } label: {
                Text("Preferences")
            }
            .keyboardShortcut(",")

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
            }
            .keyboardShortcut("q")
        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text(currentTitle)
            }
        }
        
        Settings {
            SettingsView()
        }
    }
}
