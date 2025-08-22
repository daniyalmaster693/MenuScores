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
    @AppStorage("enableHNCAAM") private var enableHNCAAM = false
    @AppStorage("enableHNCAAF") private var enableHNCAAF = false

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = false
    @AppStorage("enableNCAAM") private var enableNCAAM = false
    @AppStorage("enableNCAAF") private var enableNCAAF = false

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableF1") private var enableF1 = true
    @AppStorage("enableNC") private var enableNC = false
    @AppStorage("enableNCS") private var enableNCS = false
    @AppStorage("enableNCT") private var enableNCT = false
    @AppStorage("enableIRL") private var enableIRL = false

    @AppStorage("enablePGA") private var enablePGA = true
    @AppStorage("enableLPGA") private var enableLPGA = false

    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = true
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    // Notification Settings

    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

    // Title State Settings

    @State var currentTitle: String = ""
    @State var currentGameID: String = "0"
    @State var currentGameState: String = "pre"
    @State private var previousGameState: String? = nil

    // Notch Data

    @StateObject private var notchViewModel = NotchViewModel()

    // Notch Behaviors

    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @AppStorage("enableNotch") private var enableNotch = true

    // League Fetching

    @StateObject private var nhlVM = GamesListView()
    @StateObject private var hncaamVM = GamesListView()
    @StateObject private var hncaafVM = GamesListView()

    @StateObject private var nbaVM = GamesListView()
    @StateObject private var wnbaVM = GamesListView()
    @StateObject private var ncaamVM = GamesListView()
    @StateObject private var ncaafVM = GamesListView()

    @StateObject private var nflVM = GamesListView()
    @StateObject private var fncaaVM = GamesListView()

    @StateObject private var mlbVM = GamesListView()
    @StateObject private var bncaaVM = GamesListView()
    @StateObject private var sncaaVM = GamesListView()

    @StateObject private var f1VM = GamesListView()
    @StateObject private var ncVM = GamesListView()
    @StateObject private var ncsVM = GamesListView()
    @StateObject private var nctVM = GamesListView()
    @StateObject private var irlVM = GamesListView()

    @StateObject private var pgaVM = GamesListView()
    @StateObject private var lpgaVM = GamesListView()

    @StateObject private var uefaVM = GamesListView()
    @StateObject private var mlsVM = GamesListView()
    @StateObject private var mexVM = GamesListView()
    @StateObject private var fraVM = GamesListView()
    @StateObject private var nedVM = GamesListView()
    @StateObject private var porVM = GamesListView()

    @StateObject private var eplVM = GamesListView()
    @StateObject private var espVM = GamesListView()
    @StateObject private var gerVM = GamesListView()
    @StateObject private var itaVM = GamesListView()

    @StateObject private var nllVM = GamesListView()
    @StateObject private var pllVM = GamesListView()
    @StateObject private var lncaamVM = GamesListView()
    @StateObject private var lncaafVM = GamesListView()

    @StateObject private var vncaamVM = GamesListView()
    @StateObject private var vncaafVM = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            if enableNHL {
                HockeyMenu(
                    title: "NHL Games",
                    viewModel: nhlVM,
                    league: "NHL",
                    fetchURL: Scoreboard.Urls.nhl,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableHNCAAM {
                HockeyMenu(
                    title: "NCAA M Hockey",
                    viewModel: hncaamVM,
                    league: "HNCAAM",
                    fetchURL: Scoreboard.Urls.hncaam,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableHNCAAF {
                HockeyMenu(
                    title: "NCAA F Hockey",
                    viewModel: hncaafVM,
                    league: "HNCAAF",
                    fetchURL: Scoreboard.Urls.hncaaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNBA {
                BasketballMenu(
                    title: "NBA Games",
                    viewModel: nbaVM,
                    league: "NBA",
                    fetchURL: Scoreboard.Urls.nba,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableWNBA {
                BasketballMenu(
                    title: "WNBA Games",
                    viewModel: wnbaVM,
                    league: "WNBA",
                    fetchURL: Scoreboard.Urls.wnba,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNCAAM {
                BasketballMenu(
                    title: "NCAA M Basketball",
                    viewModel: ncaamVM,
                    league: "NCAA M",
                    fetchURL: Scoreboard.Urls.ncaam,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNCAAF {
                BasketballMenu(
                    title: "NCAA F Basketball",
                    viewModel: ncaafVM,
                    league: "NCAA F",
                    fetchURL: Scoreboard.Urls.ncaaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNFL {
                FootballMenu(
                    title: "NFL Games",
                    viewModel: nflVM,
                    league: "NFL",
                    fetchURL: Scoreboard.Urls.nfl,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFNCAA {
                FootballMenu(
                    title: "NCAA Football",
                    viewModel: fncaaVM,
                    league: "FNCAA",
                    fetchURL: Scoreboard.Urls.fncaa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableMLB {
                BaseballMenu(
                    title: "MLB Games",
                    viewModel: mlbVM,
                    league: "MLB",
                    fetchURL: Scoreboard.Urls.mlb,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableBNCAA {
                BaseballMenu(
                    title: "NCAA Baseball",
                    viewModel: bncaaVM,
                    league: "BNCAA",
                    fetchURL: Scoreboard.Urls.bncaa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableSNCAA {
                BaseballMenu(
                    title: "NCAA Softball",
                    viewModel: sncaaVM,
                    league: "SNCAA",
                    fetchURL: Scoreboard.Urls.sncaa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableMLS {
                SoccerMenu(
                    title: "MLS Games",
                    viewModel: mlsVM,
                    league: "MLS",
                    fetchURL: Scoreboard.Urls.mls,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableUEFA {
                SoccerMenu(
                    title: "Champions League",
                    viewModel: uefaVM,
                    league: "UEFA",
                    fetchURL: Scoreboard.Urls.uefa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableEPL {
                SoccerMenu(
                    title: "Premier League",
                    viewModel: eplVM,
                    league: "EPL",
                    fetchURL: Scoreboard.Urls.epl,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableESP {
                SoccerMenu(
                    title: "La Liga",
                    viewModel: espVM,
                    league: "ESP",
                    fetchURL: Scoreboard.Urls.esp,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableGER {
                SoccerMenu(
                    title: "Budesliga",
                    viewModel: gerVM,
                    league: "GER",
                    fetchURL: Scoreboard.Urls.ger,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableITA {
                SoccerMenu(
                    title: "Serie A",
                    viewModel: itaVM,
                    league: "ITA",
                    fetchURL: Scoreboard.Urls.ita,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableMEX {
                SoccerMenu(
                    title: "Liga MX",
                    viewModel: mexVM,
                    league: "MEX",
                    fetchURL: Scoreboard.Urls.mex,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFRA {
                SoccerMenu(
                    title: "Ligue 1",
                    viewModel: fraVM,
                    league: "FRA",
                    fetchURL: Scoreboard.Urls.fra,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNED {
                SoccerMenu(
                    title: "Eredivisie",
                    viewModel: nedVM,
                    league: "NED",
                    fetchURL: Scoreboard.Urls.ned,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enablePOR {
                SoccerMenu(
                    title: "Primeira Liga",
                    viewModel: porVM,
                    league: "POR",
                    fetchURL: Scoreboard.Urls.por,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableF1 {
                F1Menu(
                    title: "F1 Races",
                    viewModel: f1VM,
                    league: "F1",
                    fetchURL: Scoreboard.Urls.f1,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enablePGA {
                GolfMenu(
                    title: "PGA Golf",
                    viewModel: pgaVM,
                    league: "PGA",
                    fetchURL: Scoreboard.Urls.pga,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableLPGA {
                GolfMenu(
                    title: "LPGA Golf",
                    viewModel: lpgaVM,
                    league: "LPGA",
                    fetchURL: Scoreboard.Urls.lpga,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNLL {
                LacrosseMenu(
                    title: "NLL Games",
                    viewModel: nllVM,
                    league: "NLL",
                    fetchURL: Scoreboard.Urls.nll,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enablePLL {
                LacrosseMenu(
                    title: "PLL Games",
                    viewModel: pllVM,
                    league: "PLL",
                    fetchURL: Scoreboard.Urls.pll,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableLNCAAM {
                LacrosseMenu(
                    title: "Men's College Lacrosse",
                    viewModel: lncaamVM,
                    league: "LNCAAM",
                    fetchURL: Scoreboard.Urls.lncaam,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableLNCAAF {
                LacrosseMenu(
                    title: "Women's College Lacrosse",
                    viewModel: lncaafVM,
                    league: "LNCAAF",
                    fetchURL: Scoreboard.Urls.lncaaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableVNCAAM {
                VolleyballMenu(
                    title: "Men's College Volleyball",
                    viewModel: vncaamVM,
                    league: "VNCAAM",
                    fetchURL: Scoreboard.Urls.vncaam,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableVNCAAF {
                VolleyballMenu(
                    title: "Women's College Volleyball",
                    viewModel: vncaafVM,
                    league: "VNCAAF",
                    fetchURL: Scoreboard.Urls.vncaaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            Divider()

            if enableNotch {
                Picker("Choose Display", selection: $notchScreenIndex) {
                    ForEach(NSScreen.screens.indices, id: \.self) { index in
                        Text(NSScreen.screens[index].localizedName)
                            .tag(index)
                    }
                }
            }

            Button {
                currentTitle = ""
                currentGameID = ""
                currentGameState = ""
                previousGameState = nil

                Task {
                    if let notch = NotchViewModel.shared.notch {
                        await notch.hide()
                    }
                    NotchViewModel.shared.game = nil
                    NotchViewModel.shared.currentGameID = ""
                    NotchViewModel.shared.currentGameState = ""
                    NotchViewModel.shared.previousGameState = ""
                    NotchViewModel.shared.notch = nil
                }
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
                updater.checkForUpdates()
            } label: {
                Text("Check for Updates")
            }
            .buttonStyle(.bordered)
            .keyboardShortcut("u")

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

        .commands {
            CommandGroup(replacing: .help) {
                Button("MenuScores Help") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Divider()

                Button("Feedback") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/issues/new") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Button("Changelog") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/releases") {
                        NSWorkspace.shared.open(url)
                    }
                }

                Button("License") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/MenuScores/blob/main/License") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
    }
}
