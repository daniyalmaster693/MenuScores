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

    func populateGames() async {
        do {
            self.games = try await getGames().getGamesArray(url: Scoreboard.Urls.gamesArray)
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
