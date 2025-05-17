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

func showWalkthrough() {
    let walkthroughWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 750, height: 425),
        styleMask: [.titled, .closable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )
    
    // Transparency Effects
    
    let visualEffectView = NSVisualEffectView(frame: walkthroughWindow.contentView!.bounds)
    visualEffectView.autoresizingMask = [.width, .height]
    visualEffectView.blendingMode = .behindWindow
    visualEffectView.state = .active
    visualEffectView.material = .underWindowBackground
    
    let hostingView = NSHostingView(rootView: WalkthroughView())
    hostingView.frame = walkthroughWindow.contentView!.bounds
    hostingView.autoresizingMask = [.width, .height]
    walkthroughWindow.contentView?.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
    walkthroughWindow.contentView?.addSubview(hostingView)
    
    // Window Details
    
    walkthroughWindow.center()
    walkthroughWindow.titleVisibility = .hidden
    walkthroughWindow.titlebarAppearsTransparent = true
    walkthroughWindow.isMovableByWindowBackground = true
    
    walkthroughWindow.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
}


@main
struct MenuScoresApp: App {
    // Walkthrough
    
    init() {
//        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
            let hasLaunchedBeforeKey = "hasLaunchedBefore"
            let userDefaults = UserDefaults.standard

            if !userDefaults.bool(forKey: hasLaunchedBeforeKey) {
                showWalkthrough()
                userDefaults.set(true, forKey: hasLaunchedBeforeKey)
            }
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
    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = true
    @AppStorage("enableNCAAM") private var enableNCAAM = true
    @AppStorage("enableNCAAF") private var enableNCAAF = true
    @AppStorage("enableNFL") private var enableNFL = true
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
    
    // Title State Settings
    
    @State var currentTitle: String = "Select a Game"
    @State var currentGameID: String = "0"
    @State var currentGameState: String = "pre"
    @State private var previousGameState: String? = nil
    
    // League Fetching
    
    @StateObject private var nhlVM = GamesListView()
    @StateObject private var nbaVM = GamesListView()
    @StateObject private var wnbaVM = GamesListView()
    @StateObject private var ncaamVM = GamesListView()
    @StateObject private var ncaafVM = GamesListView()
    @StateObject private var nflVM = GamesListView()
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
                                    
                                    if previousGameState != "in" && newState == "in" {
                                        gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
                                    }
                                    
                                    if previousGameState != "post" && newState == "post" {
                                        gameStartNotification(gameId: currentGameID, gameTitle: currentTitle, newState: newState)
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
