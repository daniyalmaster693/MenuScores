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

    // Notch Data

    private let notchViewModel = NotchViewModel()

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

        print(targets)
        return targets
    }

    @MainActor
    func findGame() -> (game: Event, leagueKey: String)? {
        let targets = getSearchTargets()

        for target in targets {
            let key = target.leagueKey.uppercased()

            guard let vm = leagueVMs[key] as? GamesListView else { continue }

            let matchingGames = vm.games.filter { game in
                game.competitions.first?.competitors?.contains { competitor in
                    competitor.team?.id == target.teamID
                } ?? false
            }

            if let liveGame = matchingGames.first(where: { $0.status.type.state == "pre" }) {
                print("Found live game: \(liveGame.id) for league: \(target.leagueKey)")
                return (game: liveGame, leagueKey: target.leagueKey)
            }
        }

        return nil
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

        notchViewModel.game = game

        if let existingNotch = NotchViewModel.shared.notch {
            await existingNotch.hide()
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
            Info(notchViewModel: self.notchViewModel, sport: sport, league: league)
        } compactLeading: {
            CompactLeading(notchViewModel: self.notchViewModel, sport: sport)
        } compactTrailing: {
            CompactTrailing(notchViewModel: self.notchViewModel, sport: sport)
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

    @MainActor
    func checkForFavoriteGames(
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        @AppStorage("autoPinFavorites") var autoPinFavorites = false
        @AppStorage("selectedPinType") var selectedPinType: PinType = .notch

        enum PinType: String, CaseIterable, Identifiable {
            case menubar = "Menubar"
            case notch = "Notch"

            var id: String { rawValue }
        }

        guard autoPinFavorites else { return }

        var activeGame: Event? = nil
        var activeLeagueKey = ""

        for (leagueKey, vmAny) in leagueVMs {
            if let vm = vmAny as? GamesListView,
               let found = vm.games.first(where: { $0.id == currentGameID.wrappedValue })
            {
                activeGame = found
                activeLeagueKey = leagueKey
                break
            }
        }

        if let updatedGame = activeGame {
            currentGameState.wrappedValue = updatedGame.status.type.state

            if selectedPinType == .menubar {
                currentTitle.wrappedValue = displayText(for: updatedGame, league: activeLeagueKey)
            }

            if selectedPinType == .notch {
                notchViewModel.game = updatedGame
            }

            if currentGameState.wrappedValue == "post" {
                await clearFinishedGame(
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    currentTitle: currentTitle
                )
            }
        }

        if let result = findGame() {
            let bestGame = result.game
            let bestLeague = result.leagueKey

            if !dismissedPin || dismissedGameID != bestGame.id {
                let rawSport = FavoriteTeams.mappings[bestLeague]?.sport ?? "hockey"
                let sportName = rawSport.prefix(1).uppercased() + rawSport.dropFirst().lowercased()

                Task { @MainActor in
                    if selectedPinType == .notch {
                        await updateNotch(
                            for: bestGame,
                            sport: sportName,
                            league: bestLeague,
                            currentGameID: currentGameID,
                            currentGameState: currentGameState,
                            currentTitle: currentTitle
                        )
                    } else {
                        await updateMenuBar(
                            for: bestGame,
                            league: bestLeague,
                            currentGameID: currentGameID,
                            currentGameState: currentGameState,
                            currentTitle: currentTitle
                        )
                    }
                }
            }
        }
    }
}
