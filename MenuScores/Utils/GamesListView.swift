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

    /// Games grouped by formatted date, sorted chronologically
    var gamesByDate: [(date: String, games: [Event])] {
        let grouped = Dictionary(grouping: games) { formattedDate(from: $0.date) }
        return grouped.keys
            .sorted { date1, date2 in
                guard let game1 = grouped[date1]?.first,
                      let game2 = grouped[date2]?.first else { return false }
                return sortableDate(from: game1.date) < sortableDate(from: game2.date)
            }
            .map { (date: formattedDate(from: grouped[$0]!.first!.date), games: grouped[$0]!) }
    }

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

// MARK: Tennis Only

@MainActor
class TennisListView: ObservableObject {
    @Published var tennisGames: [TennisEvent] = []

    func populateTennis(from url: URL) async {
        do {
            self.tennisGames = try await getGames().getTennisArray(url: url)
        } catch {
            print("Failed to fetch games:", error)
        }
    }
}

struct TennisGameListView {
    private var game: TennisEvent

    init(game: TennisEvent) {
        self.game = game
    }
}
