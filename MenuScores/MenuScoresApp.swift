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
    // Refresh Interval Settings
    
    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"

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
    
        
    // Toggled League Settings
    
    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true
    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enableUEFA") private var enableUEFA = true
    @AppStorage("enableEPL") private var enableEPL = true
    
    // Title State Settings
    
    @State var currentTitle: String = "Select a Game"
    @State var currentGameID: String = "0"
    
    // League Fetching
    
    @StateObject private var nhlVM = GamesListView()
    @StateObject private var nbaVM = GamesListView()
    @StateObject private var wnbaVM = GamesListView()
    @StateObject private var ncaamVM = GamesListView()
    @StateObject private var ncaafVM = GamesListView()
    @StateObject private var nflVM = GamesListView()
    @StateObject private var mlbVM = GamesListView()
    @StateObject private var uefaVM = GamesListView()
    @StateObject private var eplVM = GamesListView()
    @StateObject private var nllVM = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            if enableNHL {
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
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nhlVM.populateGames(from: Scoreboard.Urls.nhl)
                    if let updatedGame = nhlVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NHL")
                    }
                }
            }
            }
            
            if enableNBA {
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
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nbaVM.populateGames(from: Scoreboard.Urls.nba)
                    if let updatedGame = nbaVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NBA")
                    }
                }
            }
            }
            
            if enableWNBA {
            Menu("WNBA Games") {
                Text(formattedDate(from: wnbaVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !wnbaVM.games.isEmpty {
                    ForEach(Array(wnbaVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "WNBA")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "WNBA"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "WNBA"
                Task {
                    await wnbaVM.populateGames(from: Scoreboard.Urls.wnba)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await wnbaVM.populateGames(from: Scoreboard.Urls.wnba)
                    if let updatedGame = wnbaVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "WNBA")
                    }
                }
            }
            }
            
            if enableNCAAM {
            Menu("NCAA M Games") {
                Text(formattedDate(from: ncaamVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !ncaamVM.games.isEmpty {
                    ForEach(Array(ncaamVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NCAA M")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NCAA M"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NCAA M"
                Task {
                    await ncaamVM.populateGames(from: Scoreboard.Urls.ncaam)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await ncaamVM.populateGames(from: Scoreboard.Urls.ncaam)
                    if let updatedGame = ncaamVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NCAA M")
                    }
                }
            }
            }
            
            if enableNCAAF {
            Menu("NCAA F Games") {
                Text(formattedDate(from: ncaafVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !ncaafVM.games.isEmpty {
                    ForEach(Array(ncaafVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NCAA F")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NCAA F"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NCAA F"
                Task {
                    await ncaafVM.populateGames(from: Scoreboard.Urls.ncaaf)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await ncaamVM.populateGames(from: Scoreboard.Urls.ncaam)
                    if let updatedGame = ncaamVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NCAA M")
                    }
                }
            }
            }
            
            if enableNFL {
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
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nflVM.populateGames(from: Scoreboard.Urls.nfl)
                    if let updatedGame = nflVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NFL")
                    }
                }
            }
            }
            
            if enableMLB {
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
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await mlbVM.populateGames(from: Scoreboard.Urls.mlb)
                    if let updatedGame = mlbVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "MLB")
                    }
                }
            }
            }
            
            if enableUEFA {
            Menu("UEFA Games") {
                Text(formattedDate(from: uefaVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !uefaVM.games.isEmpty {
                    ForEach(Array(uefaVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "UEFA")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "UEFA"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "UEFA"
                Task {
                    await uefaVM.populateGames(from: Scoreboard.Urls.uefa)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await uefaVM.populateGames(from: Scoreboard.Urls.uefa)
                    if let updatedGame = uefaVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "UEFA")
                    }
                }
            }
            }
            
            if enableEPL {
            Menu("EPL Games") {
                Text(formattedDate(from: eplVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !eplVM.games.isEmpty {
                    ForEach(Array(eplVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "EPL")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "EPL"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "EPL"
                Task {
                    await eplVM.populateGames(from: Scoreboard.Urls.epl)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await eplVM.populateGames(from: Scoreboard.Urls.epl)
                    if let updatedGame = eplVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "EPL")
                    }
                }
            }
            }
            
            if enableNLL {
            Menu("NLL Games") {
                Text(formattedDate(from: nllVM.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider().padding(.bottom)

                if !nllVM.games.isEmpty {
                    ForEach(Array(nllVM.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game, league: "NLL")
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game, league: "NLL"))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NLL"
                Task {
                    await nllVM.populateGames(from: Scoreboard.Urls.nll)
                }
            }
            .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                Task {
                    await nllVM.populateGames(from: Scoreboard.Urls.nll)
                    if let updatedGame = nllVM.games.first(where: { $0.id == currentGameID }) {
                        currentTitle = displayText(for: updatedGame, league: "NLL")
                    }
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
