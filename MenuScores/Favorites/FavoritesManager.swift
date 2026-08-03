//
//  FavoritesManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import DynamicNotchKit
import Foundation
import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [FavoriteTeam] = []
    @Published var availableTeams: [String: [TeamInfo]] = [:]
    @Published var isLoadingTeams = false

    private let favoritesKey = "favoriteTeams"
    private let teamsCache = NSCache<NSString, NSArray>()

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
    func findGame(in games: [Event], favorites: [FavoriteTeam], league: String) -> Event? {
        let leagueFavorites = favorites.filter { $0.leagueKey == league }

        for favorite in leagueFavorites {
            let teamGames = games.filter { game in
                game.competitions.first?.competitors?.contains {
                    $0.team?.id == favorite.id

                } ?? false
            }

            if let liveGame = teamGames.first(where: {
                $0.status.type.state == "in"

            }) {
                return liveGame
            }
        }

        return nil
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

    func dismissAutoPinnedGame(_ gameID: String) {
        guard !gameID.isEmpty else { return }

        dismissedPin = true
        dismissedGameID = gameID
    }

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

    private func updateMenuBar(
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
    func checkForFavoriteGames(
        in vm: GamesListView,
        league: String,
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

        let favorites = FavoritesManager.shared.favorites
        let rawSport = FavoriteTeams.mappings[league]?.sport ?? "Hockey"
        let sportName = rawSport.prefix(1).uppercased() + rawSport.dropFirst().lowercased()

        if let updatedGame = vm.games.first(where: { $0.id == currentGameID.wrappedValue }) {
            currentGameState.wrappedValue = updatedGame.status.type.state

            if selectedPinType == .menubar {
                currentTitle.wrappedValue = displayText(for: updatedGame, league: league)
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

        if let bestGame = findGame(in: vm.games, favorites: favorites, league: league) {
            if currentGameID.wrappedValue != bestGame.id && (!dismissedPin || dismissedGameID != bestGame.id) {
                Task { @MainActor in
                    if selectedPinType == .notch {
                        await updateNotch(for: bestGame, sport: sportName, league: league, currentGameID: currentGameID, currentGameState: currentGameState, currentTitle: currentTitle)
                    } else {
                        await updateMenuBar(for: bestGame, league: league, currentGameID: currentGameID, currentGameState: currentGameState, currentTitle: currentTitle)
                    }
                }
            }
        }
    }
}
