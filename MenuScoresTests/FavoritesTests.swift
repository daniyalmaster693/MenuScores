//
//  FavoritesTests.swift
//  MenuScoresTests
//
//  Created on 2026-03-02.
//

import Testing
@testable import MenuScores

// MARK: - Test Helpers

func makeTeam(id: String, displayName: String = "Test Team", abbreviation: String = "TST") -> Team {
    Team(
        id: id,
        displayName: displayName,
        abbreviation: abbreviation,
        name: displayName,
        logo: nil,
        links: [],
        color: nil,
        alternateColor: nil
    )
}

func makeCompetitor(teamId: String) -> Competitor {
    Competitor(
        id: "comp-\(teamId)",
        score: "0",
        order: 1,
        winner: nil,
        athlete: nil,
        team: makeTeam(id: teamId)
    )
}

func makeCompetition(homeTeamId: String, awayTeamId: String) -> Competition {
    Competition(
        competitors: [
            makeCompetitor(teamId: homeTeamId),
            makeCompetitor(teamId: awayTeamId)
        ],
        status: Status(displayClock: nil, period: nil, type: MenuScores.type(state: "pre", completed: false, detail: nil, shortDetail: nil)),
        situation: nil,
        highlights: nil,
        headlines: nil,
        venue: nil,
        notes: nil
    )
}

func makeEvent(homeTeamId: String, awayTeamId: String) -> Event {
    Event(
        id: "event-\(homeTeamId)-\(awayTeamId)",
        date: "2026-03-02T19:00Z",
        endDate: nil,
        name: "Test Game",
        shortName: "TST vs TST",
        competitions: [makeCompetition(homeTeamId: homeTeamId, awayTeamId: awayTeamId)],
        weather: nil,
        status: Status(displayClock: nil, period: nil, type: MenuScores.type(state: "pre", completed: false, detail: nil, shortDetail: nil)),
        links: nil,
        circuit: nil
    )
}

// MARK: - FavoriteTeam Tests

struct FavoriteTeamTests {

    @Test func favoriteTeamEquality() {
        let team1 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)
        let team2 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Different Name", abbreviation: "DIF", logo: "logo.png")

        // Same id and leagueKey should be equal
        #expect(team1 == team2)
    }

    @Test func favoriteTeamInequality_differentId() {
        let team1 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)
        let team2 = FavoriteTeam(id: "456", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        #expect(team1 != team2)
    }

    @Test func favoriteTeamInequality_differentLeague() {
        let team1 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)
        let team2 = FavoriteTeam(id: "123", leagueKey: "NBA", displayName: "Test", abbreviation: "TST", logo: nil)

        #expect(team1 != team2)
    }

    @Test func favoriteTeamHashing() {
        let team1 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)
        let team2 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Different", abbreviation: "DIF", logo: "logo.png")

        // Same hash for equal teams
        #expect(team1.hashValue == team2.hashValue)
    }
}

// MARK: - FavoritesManager Tests

@MainActor
struct FavoritesManagerTests {

    @Test func isFavorite_byTeamId() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        manager.addFavorite(team)

        #expect(manager.isFavorite(teamId: "123") == true)
        #expect(manager.isFavorite(teamId: "456") == false)
    }

    @Test func isFavorite_byTeamIdAndLeague() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        manager.addFavorite(team)

        #expect(manager.isFavorite(teamId: "123", leagueKey: "NHL") == true)
        #expect(manager.isFavorite(teamId: "123", leagueKey: "NBA") == false)
    }

    @Test func addFavorite_preventsDuplicates() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        manager.addFavorite(team)
        manager.addFavorite(team)

        #expect(manager.favorites.count == 1)
    }

    @Test func removeFavorite() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        manager.addFavorite(team)
        #expect(manager.favorites.count == 1)

        manager.removeFavorite(team)
        #expect(manager.favorites.count == 0)
    }

    @Test func removeFavorite_byIdAndLeague() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Test", abbreviation: "TST", logo: nil)

        manager.addFavorite(team)
        manager.removeFavorite(teamId: "123", leagueKey: "NHL")

        #expect(manager.favorites.isEmpty)
    }

    @Test func gameInvolvesFavorite_homeTeam() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "home-123", leagueKey: "NHL", displayName: "Home Team", abbreviation: "HOM", logo: nil)

        manager.addFavorite(team)
        let event = makeEvent(homeTeamId: "home-123", awayTeamId: "away-456")

        #expect(manager.gameInvolvesFavorite(event) == true)
    }

    @Test func gameInvolvesFavorite_awayTeam() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "away-456", leagueKey: "NHL", displayName: "Away Team", abbreviation: "AWY", logo: nil)

        manager.addFavorite(team)
        let event = makeEvent(homeTeamId: "home-123", awayTeamId: "away-456")

        #expect(manager.gameInvolvesFavorite(event) == true)
    }

    @Test func gameInvolvesFavorite_noFavorite() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "other-789", leagueKey: "NHL", displayName: "Other Team", abbreviation: "OTH", logo: nil)

        manager.addFavorite(team)
        let event = makeEvent(homeTeamId: "home-123", awayTeamId: "away-456")

        #expect(manager.gameInvolvesFavorite(event) == false)
    }

    @Test func getFavoriteTeam_returnsCorrectTeam() {
        let manager = FavoritesManager()
        let team = FavoriteTeam(id: "home-123", leagueKey: "NHL", displayName: "Home Team", abbreviation: "HOM", logo: nil)

        manager.addFavorite(team)
        let event = makeEvent(homeTeamId: "home-123", awayTeamId: "away-456")

        let found = manager.getFavoriteTeam(in: event)
        #expect(found?.id == "home-123")
        #expect(found?.displayName == "Home Team")
    }

    @Test func hasFavorites_forLeague() {
        let manager = FavoritesManager()
        let nhlTeam = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "NHL Team", abbreviation: "NHL", logo: nil)

        manager.addFavorite(nhlTeam)

        #expect(manager.hasFavorites(for: "NHL") == true)
        #expect(manager.hasFavorites(for: "NBA") == false)
    }

    @Test func clearAllFavorites() {
        let manager = FavoritesManager()
        let team1 = FavoriteTeam(id: "123", leagueKey: "NHL", displayName: "Team 1", abbreviation: "T1", logo: nil)
        let team2 = FavoriteTeam(id: "456", leagueKey: "NBA", displayName: "Team 2", abbreviation: "T2", logo: nil)

        manager.addFavorite(team1)
        manager.addFavorite(team2)
        #expect(manager.favorites.count == 2)

        manager.clearAllFavorites()
        #expect(manager.favorites.isEmpty)
    }
}
