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
    @AppStorage("enableNWSL") private var enableNWSL = false
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableEUEFA") private var enableEUEFA = false
    @AppStorage("enableWUEFA") private var enableWUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableWEPL") private var enableWEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableFFWC") private var enableFFWC = false
    @AppStorage("enableFFWWC") private var enableFFWWC = false
    @AppStorage("enableFFWCQUEFA") private var enableFFWCQUEFA = false
    @AppStorage("enableCONCACAF") private var enableCONCACAF = false
    @AppStorage("enableCONMEBOL") private var enableCONMEBOL = false
    @AppStorage("enableCAF") private var enableCAF = false
    @AppStorage("enableAFC") private var enableAFC = false
    @AppStorage("enableOFC") private var enableOFC = false

    @AppStorage("enableATP") private var enableATP = true
    @AppStorage("enableWTA") private var enableWTA = false

    @AppStorage("enableUFC") private var enableUFC = true

    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = true
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    @AppStorage("enableOMIHC") private var enableOMIHC = true
    @AppStorage("enableOWIHC") private var enableOWIHC = false

    private func refreshAllLeagues() async {
        if enableNHL { await nhlVM.populateGames(from: Scoreboard.Urls.nhl) }

        if enableHNCAAM { await hncaamVM.populateGames(from: Scoreboard.Urls.hncaam) }
        if enableHNCAAF { await hncaafVM.populateGames(from: Scoreboard.Urls.hncaaf) }

        if enableNBA { await nbaVM.populateGames(from: Scoreboard.Urls.nba) }
        if enableWNBA { await wnbaVM.populateGames(from: Scoreboard.Urls.wnba) }
        if enableNCAAM { await ncaamVM.populateGames(from: Scoreboard.Urls.ncaam) }
        if enableNCAAF { await ncaafVM.populateGames(from: Scoreboard.Urls.ncaaf) }

        if enableNFL { await nflVM.populateGames(from: Scoreboard.Urls.nfl) }
        if enableFNCAA { await fncaaVM.populateGames(from: Scoreboard.Urls.fncaa) }

        if enableMLB { await mlbVM.populateGames(from: Scoreboard.Urls.mlb) }
        if enableBNCAA { await bncaaVM.populateGames(from: Scoreboard.Urls.bncaa) }
        if enableSNCAA { await sncaaVM.populateGames(from: Scoreboard.Urls.sncaa) }

        if enableF1 { await f1VM.populateGames(from: Scoreboard.Urls.f1) }
        if enableNC { await ncVM.populateGames(from: Scoreboard.Urls.nc) }
        if enableNCS { await ncsVM.populateGames(from: Scoreboard.Urls.ncs) }
        if enableNCT { await nctVM.populateGames(from: Scoreboard.Urls.nct) }
        if enableIRL { await irlVM.populateGames(from: Scoreboard.Urls.irl) }

        if enablePGA { await pgaVM.populateGames(from: Scoreboard.Urls.pga) }
        if enableLPGA { await lpgaVM.populateGames(from: Scoreboard.Urls.lpga) }

        if enableATP { await atpVM.populateTennis(from: Scoreboard.Urls.atp) }
        if enableWTA { await wtaVM.populateTennis(from: Scoreboard.Urls.wta) }

        if enableUFC { await ufcVM.populateGames(from: Scoreboard.Urls.ufc) }

        if enableNLL { await nllVM.populateGames(from: Scoreboard.Urls.nll) }
        if enablePLL { await pllVM.populateGames(from: Scoreboard.Urls.pll) }
        if enableLNCAAM { await lncaamVM.populateGames(from: Scoreboard.Urls.lncaam) }
        if enableLNCAAF { await lncaafVM.populateGames(from: Scoreboard.Urls.lncaaf) }

        if enableVNCAAM { await vncaamVM.populateGames(from: Scoreboard.Urls.vncaam) }
        if enableVNCAAF { await vncaafVM.populateGames(from: Scoreboard.Urls.vncaaf) }

        if enableOMIHC { await omihcVM.populateGames(from: Scoreboard.Urls.omihc) }
        if enableOWIHC { await owihcVM.populateGames(from: Scoreboard.Urls.owihc) }
    }

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

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

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
    @StateObject private var euefaVM = GamesListView()
    @StateObject private var wuefaVM = GamesListView()
    @StateObject private var mlsVM = GamesListView()
    @StateObject private var nwslVM = GamesListView()
    @StateObject private var mexVM = GamesListView()
    @StateObject private var fraVM = GamesListView()
    @StateObject private var nedVM = GamesListView()
    @StateObject private var porVM = GamesListView()
    @StateObject private var eplVM = GamesListView()
    @StateObject private var weplVM = GamesListView()
    @StateObject private var espVM = GamesListView()
    @StateObject private var gerVM = GamesListView()
    @StateObject private var itaVM = GamesListView()

    @StateObject private var ffwcVM = GamesListView()
    @StateObject private var ffwwcVM = GamesListView()
    @StateObject private var ffwcquefaVM = GamesListView()
    @StateObject private var conmebolVM = GamesListView()
    @StateObject private var concacafVM = GamesListView()
    @StateObject private var cafVM = GamesListView()
    @StateObject private var afcVM = GamesListView()
    @StateObject private var ofcVM = GamesListView()

    @StateObject private var atpVM = TennisListView()
    @StateObject private var wtaVM = TennisListView()

    @StateObject private var ufcVM = GamesListView()

    @StateObject private var nllVM = GamesListView()
    @StateObject private var pllVM = GamesListView()
    @StateObject private var lncaamVM = GamesListView()
    @StateObject private var lncaafVM = GamesListView()

    @StateObject private var vncaamVM = GamesListView()
    @StateObject private var vncaafVM = GamesListView()

    @StateObject private var omihcVM = GamesListView()
    @StateObject private var owihcVM = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            if enableNHL {
                HockeyMenu(
                    title: "NHL",
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
                    title: "NBA",
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
                    title: "WNBA",
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
                    title: "NFL",
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
                    title: "MLB",
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
                    title: "MLS",
                    viewModel: mlsVM,
                    league: "MLS",
                    fetchURL: Scoreboard.Urls.mls,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNWSL {
                SoccerMenu(
                    title: "NWSL",
                    viewModel: nwslVM,
                    league: "NWSL",
                    fetchURL: Scoreboard.Urls.nwsl,
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

            if enableEUEFA {
                SoccerMenu(
                    title: "Europa Champions League",
                    viewModel: euefaVM,
                    league: "EUEFA",
                    fetchURL: Scoreboard.Urls.euefa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableWUEFA {
                SoccerMenu(
                    title: "Womans Champions League",
                    viewModel: wuefaVM,
                    league: "WUEFA",
                    fetchURL: Scoreboard.Urls.wuefa,
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

            if enableWEPL {
                SoccerMenu(
                    title: "Women's Super League",
                    viewModel: weplVM,
                    league: "wepl",
                    fetchURL: Scoreboard.Urls.wepl,
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
                    title: "F1",
                    viewModel: f1VM,
                    league: "F1",
                    fetchURL: Scoreboard.Urls.f1,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNC {
                RacingMenu(
                    title: "Nascar Premier",
                    viewModel: ncVM,
                    league: "NC",
                    fetchURL: Scoreboard.Urls.nc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNCS {
                RacingMenu(
                    title: "Nascar Secondary",
                    viewModel: ncsVM,
                    league: "NCS",
                    fetchURL: Scoreboard.Urls.ncs,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNCT {
                RacingMenu(
                    title: "Nascar Truck",
                    viewModel: nctVM,
                    league: "NCT",
                    fetchURL: Scoreboard.Urls.nct,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableIRL {
                RacingMenu(
                    title: "IndyCar",
                    viewModel: irlVM,
                    league: "IRL",
                    fetchURL: Scoreboard.Urls.irl,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enablePGA {
                GolfMenu(
                    title: "PGA",
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
                    title: "LPGA",
                    viewModel: lpgaVM,
                    league: "LPGA",
                    fetchURL: Scoreboard.Urls.lpga,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableATP {
                TennisMenu(
                    title: "ATP Tour",
                    viewModel: atpVM,
                    league: "ATP",
                    fetchURL: Scoreboard.Urls.atp,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableWTA {
                TennisMenu(
                    title: "WTA Tour",
                    viewModel: wtaVM,
                    league: "WTA",
                    fetchURL: Scoreboard.Urls.wta,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableUFC {
                UFCMenu(
                    title: "UFC",
                    viewModel: ufcVM,
                    league: "UFC",
                    fetchURL: Scoreboard.Urls.ufc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableNLL {
                LacrosseMenu(
                    title: "NLL",
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
                    title: "PLL",
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
                    title: "NCAA M Lacrosse",
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
                    title: "NCAA F Lacrosse",
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
                    title: "NCAA M Volleyball",
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
                    title: "NCAA F Volleyball",
                    viewModel: vncaafVM,
                    league: "VNCAAF",
                    fetchURL: Scoreboard.Urls.vncaaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableOMIHC {
                HockeyMenu(
                    title: "Men's Olympic Ice Hcokey",
                    viewModel: omihcVM,
                    league: "OMIHC",
                    fetchURL: Scoreboard.Urls.omihc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableOWIHC {
                HockeyMenu(
                    title: "Women's Olympic Ice Hcokey",
                    viewModel: owihcVM,
                    league: "OWIHC",
                    fetchURL: Scoreboard.Urls.owihc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup",
                    viewModel: ffwcVM,
                    league: "FFWC",
                    fetchURL: Scoreboard.Urls.ffwc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFFWWC {
                SoccerMenu(
                    title: "FIFA Women's World Cup",
                    viewModel: ffwwcVM,
                    league: "FFWWC",
                    fetchURL: Scoreboard.Urls.ffwwc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup UEFA Qualifiers",
                    viewModel: ffwcquefaVM,
                    league: "FFWCQUEFA",
                    fetchURL: Scoreboard.Urls.ffwcquefa,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup CONMEBOL Qualifiers",
                    viewModel: conmebolVM,
                    league: "CONMEBOL",
                    fetchURL: Scoreboard.Urls.conmebol,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableFFWC {
                SoccerMenu(
                    title: "FIFA World Cup CONCACAF Qualifiers",
                    viewModel: concacafVM,
                    league: "CONCACAF",
                    fetchURL: Scoreboard.Urls.concacaf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableAFC {
                SoccerMenu(
                    title: "FIFA World Cup African Qualifiers",
                    viewModel: cafVM,
                    league: "CAF",
                    fetchURL: Scoreboard.Urls.caf,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableAFC {
                SoccerMenu(
                    title: "FIFA World Cup Asian Qualifiers",
                    viewModel: afcVM,
                    league: "AFC",
                    fetchURL: Scoreboard.Urls.afc,
                    currentTitle: $currentTitle,
                    currentGameID: $currentGameID,
                    currentGameState: $currentGameState,
                    previousGameState: $previousGameState
                )
            }

            if enableOFC {
                SoccerMenu(
                    title: "FIFA World Cup Oceanian Qualifiers",
                    viewModel: ofcVM,
                    league: "OFC",
                    fetchURL: Scoreboard.Urls.ofc,
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
                Task {
                    await refreshAllLeagues()
                }
            } label: {
                Text("Refresh")
            }
            .keyboardShortcut("r")

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

            Divider()

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
                SettingsView()
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .containerBackground(.thickMaterial, for: .window)
            } else {
                SettingsView()
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
