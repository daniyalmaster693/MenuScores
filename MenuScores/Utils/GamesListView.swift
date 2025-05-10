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
