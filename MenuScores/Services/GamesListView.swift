//
//  gamesListView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

@MainActor
class GamesListView: ObservableObject {
    @Published var games: [Event] = []

    func populateGames(from url: URL) async {
        do {
            self.games = try await getGames().getGamesArray(url: url)
        } catch {
            print("Failed to fetch games:", error)
        }
    }
}

struct GameListView {
    private var game: Event

    init(game: Event) {
        self.game = game
    }
}

// MARK: Racing Only

@MainActor
class RacingListView: ObservableObject {
    @Published var races: [RaceEvent] = []

    func populateRacing(from url: URL) async {
        do {
            self.races = try await getGames().getRaceArray(url: url)
        } catch {
            print("Failed to fetch races:", error)
        }
    }
}

struct RacingGameListView {
    private var game: RaceEvent

    init(game: RaceEvent) {
        self.game = game
    }
}

// MARK: Fighting Only

@MainActor
class FightingListView: ObservableObject {
    @Published var fights: [FightEvent] = []

    func populateFighting(from url: URL) async {
        do {
            self.fights = try await getGames().getFightArray(url: url)
        } catch {
            print("Failed to fetch fights:", error)
        }
    }
}

struct FightingGameListView {
    private var game: FightEvent

    init(game: FightEvent) {
        self.game = game
    }
}

// MARK: Tennis Only

@MainActor
class TennisListView: ObservableObject {
    @Published var tennisGames: [TennisEvent] = []

    func populateTennis(from url: URL) async {
        do {
            self.tennisGames = try await getGames().getTennisArray(url: url)
        } catch {
            print("Failed to fetch matches:", error)
        }
    }
}

struct TennisGameListView {
    private var game: TennisEvent

    init(game: TennisEvent) {
        self.game = game
    }
}
