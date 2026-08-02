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

    // Title State Settings

    private var dismissedGameID: String = ""

    @Published var currentTitle: String = ""
    @Published var currentGameID: String = ""
    @Published var currentGameState: String = "pre"
    @Published var previousGameState: String? = nil

    // Notch Data

    private let notchViewModel = NotchViewModel()

    // Pin Data

    private var pinnedByNotch = false
    private var pinnedByMenubar = false
    private var dismissedPin = false

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

    // Favorites Actions

    func toggleFavorite(_ team: TeamInfo, leagueKey: String) {
        if let index = favorites.firstIndex(where: {
            $0.id == team.id && $0.leagueKey == leagueKey
        }) {
            favorites.remove(at: index)
        } else {
            favorites.append(
                FavoriteTeam(
                    id: team.id,
                    leagueKey: leagueKey,
                    displayName: team.displayName,
                    abbreviation: team.abbreviation ?? "",
                    logo: team.primaryLogo
                )
            )
        }

        saveFavorites()
    }

    // Favorites Management

    @MainActor
    func updateNotch(for game: Event, sport: String, league: String) async {
        currentGameID = game.id
        currentGameState = game.status.type.state

        pinnedByNotch = true
        pinnedByMenubar = false

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

    private func updateMenuBar(for game: Event, league: String) async {
        currentTitle = displayText(for: game, league: league)
        currentGameID = game.id
        currentGameState = game.status.type.state

        pinnedByMenubar = true
        pinnedByNotch = false
    }

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
    func checkForFavoriteGames(in vm: GamesListView, league: String) {
        @AppStorage("autoPinFavorites") var autoPinFavorites = false
        @AppStorage("selectedPinType") var selectedPinType: PinType = .notch

        enum PinType: String, CaseIterable, Identifiable {
            case menubar = "Menubar"
            case notch = "Notch"

            var id: String { rawValue }
        }

        guard autoPinFavorites else { return }

        if dismissedPin, currentGameID == dismissedGameID {
            return
        }

        let favorites = FavoritesManager.shared.favorites
        let rawSport = FavoriteTeams.mappings[league]?.sport ?? "Hockey"
        let sportName = rawSport.prefix(1).uppercased() + rawSport.dropFirst().lowercased()

        if let updatedGame = vm.games.first(where: { $0.id == currentGameID }) {
            currentGameState = updatedGame.status.type.state

            if selectedPinType == .menubar {
                currentTitle = displayText(for: updatedGame, league: league)
            }

            if selectedPinType == .notch {
                notchViewModel.game = updatedGame
            }

            return
        }

        if let bestGame = findGame(in: vm.games, favorites: favorites, league: league) {
            if currentGameID != bestGame.id {
                Task { @MainActor in
                    if selectedPinType == .notch {
                        await updateNotch(for: bestGame, sport: sportName, league: league)
                    } else {
                        await updateMenuBar(for: bestGame, league: league)
                    }
                }
            }
        }
    }
}
