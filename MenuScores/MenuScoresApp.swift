//
//  MenuScoresApp.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Sparkle
import SwiftUI

class LeagueSelectionModel: ObservableObject {
    @Published var currentLeague: String = ""
}

extension LeagueSelectionModel {
    static let shared = LeagueSelectionModel()
}

@main
struct MenuScoresApp: App {
    // Sparkle Updater Closure
        
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )
    
    private var updater: SPUUpdater {
        updaterController.updater
    }
    
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
    @AppStorage("enableHNCAAM") private var enableHNCAAM = true
    @AppStorage("enableHNCAAF") private var enableHNCAAF = true
    
    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true
    
    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableCFL") private var enableCFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = true
    
    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = true
    @AppStorage("enableUEFA") private var enableUEFA = true
    @AppStorage("enableEPL") private var enableEPL = true
    @AppStorage("enableESP") private var enableESP = true
    @AppStorage("enableGER") private var enableGER = true
    @AppStorage("enableITA") private var enableITA = true
    @AppStorage("enableNLL") private var enableNLL = true
    
    @AppStorage("enableHockeyM") private var enableHockeyM = true
    @AppStorage("enableHockeyF") private var enableHockeyF = true
    
    // Notification Settings
    
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false
    
    // Title State Settings
    
    @State var currentTitle: String = ""
    @State var currentGameID: String = "0"
    @State var currentGameState: String = "pre"
    @State private var previousGameState: String? = nil
    
    // League Fetching
    
    @StateObject private var nhlVM = GamesListView()
    @StateObject private var hncaamVM = GamesListView()
    @StateObject private var hncaafVM = GamesListView()
    
    @StateObject private var nbaVM = GamesListView()
    @StateObject private var wnbaVM = GamesListView()
    @StateObject private var ncaamVM = GamesListView()
    @StateObject private var ncaafVM = GamesListView()
    
    @StateObject private var nflVM = GamesListView()
    @StateObject private var cflVM = GamesListView()
    @StateObject private var fncaaVM = GamesListView()
    
    @StateObject private var mlbVM = GamesListView()
    @StateObject private var f1VM = GamesListView()
    @StateObject private var pgaVM = GamesListView()
    @StateObject private var lpgaVM = GamesListView()
    @StateObject private var uefaVM = GamesListView()
    @StateObject private var eplVM = GamesListView()
    @StateObject private var espVM = GamesListView()
    @StateObject private var gerVM = GamesListView()
    @StateObject private var itaVM = GamesListView()
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
            
            if enableHNCAAM {
                Menu("NCAA M Hockey") {
                    Text(formattedDate(from: hncaamVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !hncaamVM.games.isEmpty {
                        ForEach(Array(hncaamVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "HNCAAM")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                Text(displayText(for: game, league: "HNCAAM"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "HNCAAM"
                    Task {
                        await hncaamVM.populateGames(from: Scoreboard.Urls.hncaam)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await hncaamVM.populateGames(from: Scoreboard.Urls.hncaam)
                        if let updatedGame = hncaamVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "HNCAAM")
                                    
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
           
            if enableHNCAAF {
                Menu("NCAA F Hockey") {
                    Text(formattedDate(from: hncaafVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !hncaafVM.games.isEmpty {
                        ForEach(Array(hncaafVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "HNCAAF")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                Text(displayText(for: game, league: "HNCAAF"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "HNCAAF"
                    Task {
                        await hncaafVM.populateGames(from: Scoreboard.Urls.hncaaf)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await hncaafVM.populateGames(from: Scoreboard.Urls.hncaaf)
                        if let updatedGame = hncaafVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "HNCAAF")
                                    
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                        
            if enableNCAAM {
                Menu("NCAA M Basketball") {
                    Text(formattedDate(from: ncaamVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !ncaamVM.games.isEmpty {
                        ForEach(Array(ncaamVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "NCAA M")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                        
            if enableNCAAF {
                Menu("NCAA F Basketball") {
                    Text(formattedDate(from: ncaafVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !ncaafVM.games.isEmpty {
                        ForEach(Array(ncaafVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "NCAA F")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
            
//            if enableCFL {
//                Menu("CFL Games") {
//                    Text(formattedDate(from: cflVM.games.first?.date ?? "Invalid Date"))
//                        .font(.headline)
//                    Divider().padding(.bottom)
//
//                    if !cflVM.games.isEmpty {
//                        ForEach(Array(cflVM.games.enumerated()), id: \.1.id) { _, game in
//                            Button {
//                                currentTitle = displayText(for: game, league: "CFL")
//                                currentGameID = game.id
//                                currentGameState = game.status.type.state
//                            } label: {
//                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
//                                    image.resizable().scaledToFit()
//                                } placeholder: {
//                                    ProgressView()
//                                }
//                                .frame(width: 40, height: 40)
//
//                                Text(displayText(for: game, league: "CFL"))
//                            }
//                        }
//                    } else {
//                        Text("Loading games...")
//                            .foregroundColor(.gray)
//                            .padding()
//                    }
//                }
//                .onAppear {
//                    LeagueSelectionModel.shared.currentLeague = "CFL"
//                    Task {
//                        await cflVM.populateGames(from: Scoreboard.Urls.cfl)
//                    }
//                }
//                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
//                    Task {
//                        await cflVM.populateGames(from: Scoreboard.Urls.cfl)
//                        if let updatedGame = cflVM.games.first(where: { $0.id == currentGameID }) {
//                            currentTitle = displayText(for: updatedGame, league: "CFL")
//                            let newState = updatedGame.status.type.state
//                                        
//                            if notiGameStart {
//                                if previousGameState != "in" && newState == "in" {
//                                    gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
//                                }
//                            }
//                                        
//                            if notiGameComplete {
//                                if previousGameState != "post" && newState == "post" {
//                                    gameCompleteNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
//                                }
//                            }
//                                        
//                            previousGameState = newState
//                            currentGameState = newState
//                        }
//                    }
//                }
//            }
            
            if enableFNCAA {
                Menu("NCAA Football") {
                    let groupedGames = Dictionary(grouping: fncaaVM.games) { game in
                        formattedDate(from: game.date)
                    }

                    let sortedDates = groupedGames.keys.sorted()

                    ForEach(sortedDates, id: \.self) { date in
                        if let gamesForDate = groupedGames[date] {
                            Menu(date) {
                                ForEach(gamesForDate, id: \.id) { game in
                                    Button {
                                        currentTitle = displayText(for: game, league: "FNCAA")
                                        currentGameID = game.id
                                        currentGameState = game.status.type.state
                                    } label: {
                                        AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)

                                        Text(displayText(for: game, league: "FNCAA"))
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "FNCAA"
                    Task {
                        await fncaaVM.populateGames(from: Scoreboard.Urls.fncaa)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await fncaaVM.populateGames(from: Scoreboard.Urls.fncaa)
                        if let updatedGame = fncaaVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "FNCAA")
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                        
            if enableF1 {
                Menu("F1 Races") {
                    Text(formattedDate(from: f1VM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !f1VM.games.isEmpty {
                        ForEach(Array(f1VM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "F1")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                Text(displayText(for: game, league: "F1"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "F1"
                    Task {
                        await f1VM.populateGames(from: Scoreboard.Urls.f1)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await f1VM.populateGames(from: Scoreboard.Urls.f1)
                        if let updatedGame = f1VM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "F1")
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
                        
            if enablePGA {
                Menu("PGA Games") {
                    Text(formattedDate(from: pgaVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !pgaVM.games.isEmpty {
                        ForEach(Array(pgaVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "PGA")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                Text(displayText(for: game, league: "PGA"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "PGA"
                    Task {
                        await pgaVM.populateGames(from: Scoreboard.Urls.pga)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await pgaVM.populateGames(from: Scoreboard.Urls.pga)
                        if let updatedGame = pgaVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "PGA")
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
                        
            if enableLPGA {
                Menu("LPGA Games") {
                    Text(formattedDate(from: lpgaVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)

                    if !lpgaVM.games.isEmpty {
                        ForEach(Array(lpgaVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "LPGA")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)

                                Text(displayText(for: game, league: "LPGA"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "LPGA"
                    Task {
                        await lpgaVM.populateGames(from: Scoreboard.Urls.lpga)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await lpgaVM.populateGames(from: Scoreboard.Urls.lpga)
                        if let updatedGame = lpgaVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "LPGA")
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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
                        
            if enableESP {
                Menu("ESP Games") {
                    Text(formattedDate(from: espVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)
                                
                    if !espVM.games.isEmpty {
                        ForEach(Array(espVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "ESP")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                            
                                Text(displayText(for: game, league: "ESP"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "ESP"
                    Task {
                        await espVM.populateGames(from: Scoreboard.Urls.esp)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await espVM.populateGames(from: Scoreboard.Urls.esp)
                        if let updatedGame = espVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "ESP")
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
                        
            if enableGER {
                Menu("GER Games") {
                    Text(formattedDate(from: gerVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)
                                
                    if !gerVM.games.isEmpty {
                        ForEach(Array(gerVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "GER")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                            
                                Text(displayText(for: game, league: "GER"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "GER"
                    Task {
                        await gerVM.populateGames(from: Scoreboard.Urls.ger)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await gerVM.populateGames(from: Scoreboard.Urls.ger)
                        if let updatedGame = gerVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "GER")
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
                        
            if enableITA {
                Menu("ITA Games") {
                    Text(formattedDate(from: itaVM.games.first?.date ?? "Invalid Date"))
                        .font(.headline)
                    Divider().padding(.bottom)
                                
                    if !itaVM.games.isEmpty {
                        ForEach(Array(itaVM.games.enumerated()), id: \.1.id) { _, game in
                            Button {
                                currentTitle = displayText(for: game, league: "ITA")
                                currentGameID = game.id
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 40, height: 40)
                                            
                                Text(displayText(for: game, league: "ITA"))
                            }
                        }
                    } else {
                        Text("Loading games...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .onAppear {
                    LeagueSelectionModel.shared.currentLeague = "ITA"
                    Task {
                        await itaVM.populateGames(from: Scoreboard.Urls.ita)
                    }
                }
                .onReceive(Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()) { _ in
                    Task {
                        await itaVM.populateGames(from: Scoreboard.Urls.ita)
                        if let updatedGame = itaVM.games.first(where: { $0.id == currentGameID }) {
                            currentTitle = displayText(for: updatedGame, league: "ITA")
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
                                currentGameState = game.status.type.state
                            } label: {
                                AsyncImage(url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")) { image in
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

            Divider()

            Button {
                currentTitle = ""
                currentGameID = ""
            } label: {
                Text("Clear Set Game")
            }
            .keyboardShortcut("c")
            
            if #available(macOS 14, *) {
                Button {
                    let environment = EnvironmentValues()
                    environment.openSettings()
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Text("Preferences")
                }
                .keyboardShortcut(",")
            }

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
            if #available(macOS 15.0, *) {
                SettingsView(updater: updater)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .containerBackground(.ultraThickMaterial, for: .window)
            } else {
                SettingsView(updater: updater)
            }
        }
    }
}
