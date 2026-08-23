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
    private var isAutoPinned = false

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
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            print("Failed to load teams: \(error)")
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
            print("Failed to fetch favorites:", error)
            favorites = []
        }
    }

    func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Failed to save favorites:", error)
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
        isAutoPinned = true

        currentGameID.wrappedValue = game.id
        currentGameState.wrappedValue = game.status.type.state
        currentTitle.wrappedValue = ""

        NotchViewModel.shared.game = game

        if let notch = NotchViewModel.shared.notch {
            await notch.hide()
            NotchViewModel.shared.notch = nil

            NotchViewModel.shared.game = nil
            NotchViewModel.shared.racingCompetition = nil
            NotchViewModel.shared.fightCompetition = nil
            NotchViewModel.shared.tennisCompetition = nil

            NotchViewModel.shared.currentGameID = ""
            NotchViewModel.shared.currentGameState = ""
            NotchViewModel.shared.previousGameState = ""
        }

        let newNotch = DynamicNotch(
            hoverBehavior: .all,
            style: .notch
        ) {
            Info(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        } compactLeading: {
            CompactLeading(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        } compactTrailing: {
            CompactTrailing(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        }

        NotchViewModel.shared.notch = newNotch
        await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
    }

    @MainActor
    func updateRacingNotch(
        for race: RaceEvent,
        sport: String,
        league: String,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        isAutoPinned = true

        if league == "F1" {
            currentGameID.wrappedValue = race.competitionId
        } else {
            currentGameID.wrappedValue = race.id
        }

        currentGameState.wrappedValue = race.fullStatus.type.state
        currentTitle.wrappedValue = ""

        NotchViewModel.shared.racingCompetition = race

        if let notch = NotchViewModel.shared.notch {
            await notch.hide()
            NotchViewModel.shared.notch = nil

            NotchViewModel.shared.game = nil
            NotchViewModel.shared.racingCompetition = nil
            NotchViewModel.shared.fightCompetition = nil
            NotchViewModel.shared.tennisCompetition = nil

            NotchViewModel.shared.currentGameID = ""
            NotchViewModel.shared.currentGameState = ""
            NotchViewModel.shared.previousGameState = ""
        }

        let newNotch = DynamicNotch(
            hoverBehavior: .all,
            style: .notch
        ) {
            Info(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        } compactLeading: {
            CompactLeading(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
        } compactTrailing: {
            CompactTrailing(notchViewModel: NotchViewModel.shared, sport: sport, league: league)
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
        isAutoPinned = true

        currentTitle.wrappedValue = displayText(for: game, league: league)
        currentGameID.wrappedValue = game.id
        currentGameState.wrappedValue = game.status.type.state
    }

    @MainActor
    func updateRacingMenuBar(
        for race: RaceEvent,
        league: String,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        isAutoPinned = true

        if league == "F1" {
            currentTitle.wrappedValue = displayF1Text(for: race)
            currentGameID.wrappedValue = race.competitionId
        } else {
            currentTitle.wrappedValue = displayRacingText(for: race)
            currentGameID.wrappedValue = race.id
        }

        currentGameState.wrappedValue = race.fullStatus.type.state
    }

    @MainActor
    func clearFinishedGame(
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) async {
        isAutoPinned = false

        currentTitle.wrappedValue = ""
        currentGameID.wrappedValue = ""
        currentGameState.wrappedValue = ""

        if let notch = NotchViewModel.shared.notch {
            await notch.hide()
        }

        NotchViewModel.shared.notch = nil

        NotchViewModel.shared.game = nil
        NotchViewModel.shared.racingCompetition = nil
        NotchViewModel.shared.fightCompetition = nil
        NotchViewModel.shared.tennisCompetition = nil

        NotchViewModel.shared.currentGameID = ""
        NotchViewModel.shared.currentGameState = ""
        NotchViewModel.shared.previousGameState = ""
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
        nba: GamesListView, wnba: GamesListView, ncaam: GamesListView, ncaaf: GamesListView, snba: GamesListView, gnba: GamesListView,
        nfl: GamesListView, afl: GamesListView, fncaa: GamesListView,
        mlb: GamesListView, bncaa: GamesListView, sncaa: GamesListView,
        f1: RacingListView, nc: RacingListView, ncs: RacingListView, nct: RacingListView, irl: RacingListView,
        pga: GamesListView, lpga: GamesListView,
        uefa: GamesListView, euefa: GamesListView, wuefa: GamesListView,
        mls: GamesListView, nwsl: GamesListView, mex: GamesListView, fra: GamesListView,
        ned: GamesListView, por: GamesListView, epl: GamesListView, wepl: GamesListView,
        esp: GamesListView, ger: GamesListView, ita: GamesListView, tur: GamesListView, bra1: GamesListView, bra2: GamesListView, ksa: GamesListView,
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
        leagueVMs["SNBA"] = snba
        leagueVMs["GNBA"] = gnba
        leagueVMs["NFL"] = nfl
        leagueVMs["AFL"] = afl
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
        leagueVMs["TUR"] = tur
        leagueVMs["BRA1"] = bra1
        leagueVMs["BRA2"] = bra2
        leagueVMs["KSA"] = ksa
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

    enum FavoriteGame {
        case normal(Event)
        case racing(RaceEvent, leagueKey: String)

        var id: String {
            switch self {
            case .normal(let game):
                return game.id

            case .racing(let race, let leagueKey):
                return leagueKey == "F1"
                    ? race.competitionId
                    : race.id
            }
        }

        var state: String {
            switch self {
            case .normal(let game):
                return game.status.type.state

            case .racing(let race, _):
                return race.fullStatus.type.state
            }
        }
    }

    @MainActor
    func findGame() -> (game: FavoriteGame, leagueKey: String)? {
        let targets = getSearchTargets()

        for target in targets {
            let key = target.leagueKey.uppercased()

            if key == "F1" || key == "NC" || key == "NCS" || key == "NCT" || key == "IRL" {
                guard let vm = leagueVMs[key] as? RacingListView else {
                    continue
                }

                let matchingRaces = vm.races

                if let race = matchingRaces.first(where: { $0.fullStatus.type.state == "in" }) {
                    return (game: .racing(race, leagueKey: target.leagueKey), leagueKey: target.leagueKey)
                }

                continue
            }

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

            if let game = matchingGames.first(where: { $0.status.type.state == "in" }) {
                return (game: .normal(game), leagueKey: target.leagueKey)
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
        @AppStorage("autoClearFavorites") var autoClearFavorites = true
        @AppStorage("selectedPinType") var selectedPinType: PinType = .notch

        enum PinType: String, CaseIterable, Identifiable {
            case menubar = "Menubar"
            case notch = "Notch"

            var id: String { rawValue }
        }

        guard autoPinFavorites else { return }

        guard let result = findGame() else {
            if autoClearFavorites {
                if isAutoPinned && !currentGameID.wrappedValue.isEmpty {
                    await clearFinishedGame(
                        currentGameID: currentGameID,
                        currentGameState: currentGameState,
                        currentTitle: currentTitle
                    )
                }
            }

            return
        }

        let currentGame = result.game
        let currentLeague = result.leagueKey

        let gameID = currentGame.id
        let gameState = currentGame.state

        if currentGameID.wrappedValue == gameID {
            currentGameState.wrappedValue = gameState

            switch currentGame {
            case .normal(let game):
                if selectedPinType == .menubar {
                    currentTitle.wrappedValue = displayText(for: game, league: currentLeague)
                } else if selectedPinType == .notch {
                    NotchViewModel.shared.game = game
                }
            case .racing(let race, let leagueKey):
                if selectedPinType == .menubar {
                    if leagueKey == "F1" {
                        currentTitle.wrappedValue = displayF1Text(for: race)
                    } else {
                        currentTitle.wrappedValue = displayRacingText(for: race)
                    }
                } else if selectedPinType == .notch {
                    NotchViewModel.shared.racingCompetition = race
                }
            }

            return
        }

        if !dismissedPin || dismissedGameID != currentGame.id {
            let sport = FavoriteTeams.mappings[currentLeague]?.sport ?? "hockey"
            let sportName = (currentLeague.uppercased() == "F1") ? "F1" : (sport.prefix(1).uppercased() + sport.dropFirst().lowercased())

            switch currentGame {
            case .normal(let game):
                Task { @MainActor in
                    if selectedPinType == .notch {
                        await updateNotch(
                            for: game,
                            sport: sportName,
                            league: currentLeague,
                            currentGameID: currentGameID,
                            currentGameState: currentGameState,
                            currentTitle: currentTitle
                        )
                    } else {
                        await updateMenuBar(
                            for: game,
                            league: currentLeague,
                            currentGameID: currentGameID,
                            currentGameState: currentGameState,
                            currentTitle: currentTitle
                        )
                    }
                }

            case .racing(let race, _):
                Task { @MainActor in
                    if selectedPinType == .notch {
                        await updateRacingNotch(
                            for: race,
                            sport: sportName,
                            league: currentLeague,
                            currentGameID: currentGameID,
                            currentGameState: currentGameState,
                            currentTitle: currentTitle
                        )
                    } else {
                        await updateRacingMenuBar(
                            for: race,
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
}
