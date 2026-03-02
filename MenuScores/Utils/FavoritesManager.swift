//
//  FavoritesManager.swift
//  MenuScores
//
//  Created by Claude on 2025-02-24.
//

import Foundation

@MainActor
class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [FavoriteTeam] = []
    @Published var availableTeams: [String: [TeamInfo]] = [:] // leagueKey -> teams
    @Published var isLoadingTeams = false

    private let favoritesKey = "favoriteTeams"
    private let teamsCache = NSCache<NSString, NSArray>()

    init() {
        loadFavorites()
    }

    // MARK: - Favorites Persistence

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

    // MARK: - Favorites Management

    func addFavorite(_ team: FavoriteTeam) {
        guard !favorites.contains(team) else { return }
        favorites.append(team)
        saveFavorites()
    }

    func addFavorite(from teamInfo: TeamInfo, leagueKey: String) {
        let favorite = FavoriteTeam(
            id: teamInfo.id,
            leagueKey: leagueKey,
            displayName: teamInfo.displayName,
            abbreviation: teamInfo.abbreviation,
            logo: teamInfo.primaryLogo
        )
        addFavorite(favorite)
    }

    func removeFavorite(_ team: FavoriteTeam) {
        favorites.removeAll { $0 == team }
        saveFavorites()
    }

    func removeFavorite(teamId: String, leagueKey: String) {
        favorites.removeAll { $0.id == teamId && $0.leagueKey == leagueKey }
        saveFavorites()
    }

    func isFavoriteTeam(teamId: String) -> Bool {
        favorites.contains { $0.id == teamId }
    }

    func isFavoriteTeamInLeague(teamId: String, leagueKey: String) -> Bool {
        favorites.contains { $0.id == teamId && $0.leagueKey == leagueKey }
    }

    func clearAllFavorites() {
        favorites.removeAll()
        saveFavorites()
    }

    // MARK: - Teams Fetching

    func fetchTeams(for leagueKey: String) async {
        // Check cache first
        if let cached = teamsCache.object(forKey: leagueKey as NSString) as? [TeamInfo] {
            availableTeams[leagueKey] = cached
            return
        }

        guard let url = LeagueAPIMapping.teamsUrl(for: leagueKey) else {
            print("No teams URL for league: \(leagueKey)")
            return
        }

        isLoadingTeams = true

        do {
            let teams = try await getGames().getTeamsArray(url: url)
            availableTeams[leagueKey] = teams
            teamsCache.setObject(teams as NSArray, forKey: leagueKey as NSString)
        } catch {
            print("Failed to fetch teams for \(leagueKey):", error)
            availableTeams[leagueKey] = []
        }

        isLoadingTeams = false
    }

    func getTeams(for leagueKey: String) -> [TeamInfo] {
        availableTeams[leagueKey] ?? []
    }

    // MARK: - Game Matching

    func gameInvolvesFavorite(_ event: Event) -> Bool {
        guard let competitors = event.competitions.first?.competitors else { return false }
        let teamIds = competitors.compactMap { $0.team?.id }
        return favorites.contains { teamIds.contains($0.id) }
    }

    func getFavoriteTeam(in event: Event) -> FavoriteTeam? {
        guard let competitors = event.competitions.first?.competitors else { return nil }
        let teamIds = competitors.compactMap { $0.team?.id }
        return favorites.first { teamIds.contains($0.id) }
    }

    func getFavoriteTeamName(in event: Event) -> String {
        getFavoriteTeam(in: event)?.displayName ?? "Favorite Team"
    }

    // MARK: - Favorites for League

    func favorites(for leagueKey: String) -> [FavoriteTeam] {
        favorites.filter { $0.leagueKey == leagueKey }
    }

    func hasFavorites(for leagueKey: String) -> Bool {
        favorites.contains { $0.leagueKey == leagueKey }
    }

    // MARK: - Score String Helper

    func getScoreString(for event: Event) -> String {
        guard let competitors = event.competitions.first?.competitors,
              competitors.count >= 2 else {
            return ""
        }

        let home = competitors[0]
        let away = competitors[1]

        let homeName = home.team?.abbreviation ?? home.team?.displayName ?? "Home"
        let awayName = away.team?.abbreviation ?? away.team?.displayName ?? "Away"
        let homeScore = home.score ?? "0"
        let awayScore = away.score ?? "0"

        return "\(awayName) \(awayScore) - \(homeScore) \(homeName)"
    }
}
