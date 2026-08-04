//
//  FavoritesManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import DynamicNotchKit
import Foundation
import SwiftUI

struct FavoriteTarget {
    let leagueKey: String
    let teamID: String
}

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [FavoriteTeam] = []
    @Published var availableTeams: [String: [TeamInfo]] = [:]
    @Published var isLoadingTeams = false

    private let favoritesKey = "favoriteTeams"
    private let teamsCache = NSCache<NSString, NSArray>()

    private var leagueVMs: [String: any ObservableObject] = [:]

    init() {
        loadFavorites()
    }

    // Pin Data

    private var dismissedPin = false
    private var dismissedGameID = ""

    // Notch Behaviors

    private var enableNotch: Bool {
        UserDefaults.standard.bool(forKey: "enableNotch")
    }

    private var notchScreenIndex: Int {
        UserDefaults.standard.integer(forKey: "notchScreenIndex")
    }

    @MainActor
    func loadTeams(for leagueKey: String, url: URL) async {
        if availableTeams[leagueKey] != nil {
            return
        }

        isLoadingTeams = true
        defer { isLoadingTeams = false }

        do {
            let teams = try await getGames().getTeamsArray(url: url)
            availableTeams[leagueKey] = teams.sorted {
                $0.displayName < $1.displayName
            }
        } catch {
            print(error)
        }
    }

    // Favorites Management

    func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            favorites = []
            return
        }

        do {
            favorites = try JSONDecoder().decode([FavoriteTeam].self, from: data)
        } catch {
            print("Failed to decode favorites:", error)
            favorites = []
        }
    }

    func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to encode favorites:", error)
        }
    }

    func isFavorite(_ team: TeamInfo, leagueKey: String) -> Bool {
        favorites.contains {
            $0.id == team.id && $0.leagueKey == leagueKey
        }
    }

    func toggleFavorite(_ team: TeamInfo, leagueKey: String) {
        if let index = favorites.firstIndex(where: {
            $0.id == team.id && $0.leagueKey == leagueKey
        }) {
            favorites.remove(at: index)
        } else {
            let sport = FavoriteTeams.mappings[leagueKey]?.sport ?? "hockey"
            var fallbackLogo = "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport).png&h=80&w=80&scale=crop&cquality=40"

            if sport == "racing" {
                fallbackLogo = "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
            } else if sport == "volleyball" {
                fallbackLogo = "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
            }

            favorites.append(
                FavoriteTeam(
                    id: team.id,
                    leagueKey: leagueKey,
                    displayName: team.displayName,
                    abbreviation: team.abbreviation ?? "",
                    logo: team.logos?.first?.href ?? fallbackLogo
                )
            )
        }

        saveFavorites()
    }

    // Auto Pin Methods

    @MainActor
    func updateNotch(
        for game: Event,
        sport: String,
        league: String,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        currentGameID.wrappedValue = game.id
        currentGameState.wrappedValue = game.status.type.state
        currentTitle.wrappedValue = ""

        NotchViewModel.shared.game = game

        if let notch = NotchViewModel.shared.notch {
            await notch.hide()
            NotchViewModel.shared.game = nil
            NotchViewModel.shared.currentGameID = ""
            NotchViewModel.shared.currentGameState = ""
            NotchViewModel.shared.previousGameState = ""
            NotchViewModel.shared.notch = nil
        }

        let newNotch = DynamicNotch(
            hoverBehavior: .all,
            style: .notch
        ) {
            Info(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        } compactLeading: {
            CompactLeading(notchViewModel: NotchViewModel.shared, sport: sport)
        } compactTrailing: {
            CompactTrailing(notchViewModel: NotchViewModel.shared, sport: sport)
        }

        NotchViewModel.shared.notch = newNotch
        await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
    }

    @MainActor
    func updateMenuBar(
        for game: Event,
        league: String,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        currentTitle.wrappedValue = displayText(for: game, league: league)
        currentGameID.wrappedValue = game.id
        currentGameState.wrappedValue = game.status.type.state
    }

    @MainActor
    func clearFinishedGame(
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        currentTitle.wrappedValue = ""
        currentGameID.wrappedValue = ""
        currentGameState.wrappedValue = ""

        if let notch = NotchViewModel.shared.notch {
            await notch.hide()
        }

        NotchViewModel.shared.game = nil
        NotchViewModel.shared.currentGameID = ""
        NotchViewModel.shared.currentGameState = ""
        NotchViewModel.shared.previousGameState = ""
        NotchViewModel.shared.notch = nil
    }

    @MainActor
    func dismissAutoPinnedGame(_ gameID: String) {
        guard !gameID.isEmpty else { return }

        dismissedPin = true
        dismissedGameID = gameID
    }

    // Auto Pin Functionality

    @MainActor
    func registerViewModels(
        nhl: GamesListView, hncaam: GamesListView, hncaaf: GamesListView,
        nba: GamesListView, wnba: GamesListView, ncaam: GamesListView, ncaaf: GamesListView,
        nfl: GamesListView, fncaa: GamesListView,
        mlb: GamesListView, bncaa: GamesListView, sncaa: GamesListView,
        f1: GamesListView, nc: GamesListView, ncs: GamesListView, nct: GamesListView, irl: GamesListView,
        pga: GamesListView, lpga: GamesListView,
        uefa: GamesListView, euefa: GamesListView, wuefa: GamesListView,
        mls: GamesListView, nwsl: GamesListView, mex: GamesListView, fra: GamesListView,
        ned: GamesListView, por: GamesListView, epl: GamesListView, wepl: GamesListView,
        esp: GamesListView, ger: GamesListView, ita: GamesListView,
        nll: GamesListView, pll: GamesListView, lncaam: GamesListView, lncaaf: GamesListView,
        vncaam: GamesListView, vncaaf: GamesListView,
        omihc: GamesListView, owihc: GamesListView, omb: GamesListView, owb: GamesListView,
        ffwc: GamesListView, ffwwc: GamesListView, ffwcquefa: GamesListView,
        conmebol: GamesListView, concacaf: GamesListView, caf: GamesListView,
        afc: GamesListView, ofc: GamesListView
    ) {
        leagueVMs["NHL"] = nhl
        leagueVMs["HNCAAM"] = hncaam
        leagueVMs["HNCAAF"] = hncaaf
        leagueVMs["NBA"] = nba
        leagueVMs["WNBA"] = wnba
        leagueVMs["NCAAM"] = ncaam
        leagueVMs["NCAAF"] = ncaaf
        leagueVMs["NFL"] = nfl
        leagueVMs["FNCAA"] = fncaa
        leagueVMs["MLB"] = mlb
        leagueVMs["BNCAA"] = bncaa
        leagueVMs["SNCAA"] = sncaa
        leagueVMs["F1"] = f1
        leagueVMs["NC"] = nc
        leagueVMs["NCS"] = ncs
        leagueVMs["NCT"] = nct
        leagueVMs["IRL"] = irl
        leagueVMs["PGA"] = pga
        leagueVMs["LPGA"] = lpga
        leagueVMs["UEFA"] = uefa
        leagueVMs["EUEFA"] = euefa
        leagueVMs["WUEFA"] = wuefa
        leagueVMs["MLS"] = mls
        leagueVMs["NWSL"] = nwsl
        leagueVMs["MEX"] = mex
        leagueVMs["FRA"] = fra
        leagueVMs["NED"] = ned
        leagueVMs["POR"] = por
        leagueVMs["EPL"] = epl
        leagueVMs["WEPL"] = wepl
        leagueVMs["ESP"] = esp
        leagueVMs["GER"] = ger
        leagueVMs["ITA"] = ita
        leagueVMs["NLL"] = nll
        leagueVMs["PLL"] = pll
        leagueVMs["LNCAAM"] = lncaam
        leagueVMs["LNCAAF"] = lncaaf
        leagueVMs["VNCAAM"] = vncaam
        leagueVMs["VNCAAF"] = vncaaf
        leagueVMs["OMIHC"] = omihc
        leagueVMs["OWIHC"] = owihc
        leagueVMs["OMB"] = omb
        leagueVMs["OWB"] = owb
        leagueVMs["FFWC"] = ffwc
        leagueVMs["FFWWC"] = ffwwc
        leagueVMs["FFWCQUEFA"] = ffwcquefa
        leagueVMs["CONMEBOL"] = conmebol
        leagueVMs["CONCACAF"] = concacaf
        leagueVMs["CAF"] = caf
        leagueVMs["AFC"] = afc
        leagueVMs["OFC"] = ofc
    }

    @MainActor
    func getSearchTargets() -> [FavoriteTarget] {
        var targets: [FavoriteTarget] = []

        for favorite in favorites {
            let target = FavoriteTarget(leagueKey: favorite.leagueKey, teamID: favorite.id)

            if !targets.contains(where: { $0.leagueKey == target.leagueKey && $0.teamID == target.teamID }) {
                targets.append(target)
            }
        }

        return targets
    }

    @MainActor
    func findGame() -> (game: Event, leagueKey: String)? {
        let targets = getSearchTargets()

        for target in targets {
            let key = target.leagueKey.uppercased()
            guard let vm = leagueVMs[key] as? GamesListView else { continue }

            let matchingGames: [Event]

            if target.teamID.hasPrefix("league-") {
                matchingGames = vm.games
            } else {
                matchingGames = vm.games.filter { game in
                    game.competitions.first?.competitors?.contains { competitor in
                        competitor.team?.id == target.teamID
                    } ?? false
                }
            }

            if let liveGame = matchingGames.first(where: { $0.status.type.state == "pre" }) {
                return (game: liveGame, leagueKey: target.leagueKey)
            }
        }

        return nil
    }

    @MainActor
    func checkForFavorites(
        _ currentGameID: Binding<String>,
        _ currentGameState: Binding<String>,
        _ currentTitle: Binding<String>
    ) async {
        @AppStorage("autoPinFavorites") var autoPinFavorites = false
        @AppStorage("selectedPinType") var selectedPinType: PinType = .notch

        enum PinType: String, CaseIterable, Identifiable {
            case menubar = "Menubar"
            case notch = "Notch"

            var id: String { rawValue }
        }

        guard autoPinFavorites else { return }
        guard let result = findGame() else { return }

        let currentGame = result.game
        let currentLeague = result.leagueKey
        let currentState = currentGame.status.type.state

        if currentGameID.wrappedValue == currentGame.id {
            currentGameState.wrappedValue = currentState

            if selectedPinType == .menubar {
                currentTitle.wrappedValue = displayText(for: currentGame, league: currentLeague)
            } else if selectedPinType == .notch {
                NotchViewModel.shared.game = currentGame
            }

            if currentGameState.wrappedValue == "post" {
                await clearFinishedGame(
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    currentTitle: currentTitle
                )
            }

            return
        }

        if !dismissedPin || dismissedGameID != currentGame.id {
            let sport = FavoriteTeams.mappings[currentLeague]?.sport ?? "hockey"
            let sportName = sport.prefix(1).uppercased() + sport.dropFirst().lowercased()

            Task { @MainActor in
                if selectedPinType == .notch {
                    await updateNotch(
                        for: currentGame,
                        sport: sportName,
                        league: currentLeague,
                        currentGameID: currentGameID,
                        currentGameState: currentGameState,
                        currentTitle: currentTitle
                    )
                } else {
                    await updateMenuBar(
                        for: currentGame,
                        league: currentLeague,
                        currentGameID: currentGameID,
                        currentGameState: currentGameState,
                        currentTitle: currentTitle
                    )
                }
            }
        }
    }
}
