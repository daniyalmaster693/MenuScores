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
            let fetched = try await getGames().getGamesArray(url: url)

            if fetched.isEmpty {
                // Remove date range and fetch all, then get most recent completed game
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                let filteredItems = components?.queryItems?.filter { $0.name != "dates" }
                components?.queryItems = filteredItems

                if let baseURL = components?.url {
                    let allGames = try await getGames().getGamesArray(url: baseURL)
                    let completedGames = allGames.filter { $0.status.type.state == "post" }
                    let sortedByDate = completedGames.sorted { sortableDate(from: $0.date) > sortableDate(from: $1.date) }

                    if let mostRecent = sortedByDate.first {
                        self.games = [mostRecent]
                        return
                    }
                }
            }

            self.games = fetched
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
