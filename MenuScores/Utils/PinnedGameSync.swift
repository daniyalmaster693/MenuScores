//
//  PinnedGameSync.swift
//  MenuScores
//

import Foundation

enum PinnedGameSync {
    @MainActor
    static func syncStandardEvent(
        gameID: String,
        league: String,
        eventSources: [(league: String, games: [Event])],
        currentTitle: inout String,
        currentGameState: inout String,
        previousGameState: inout String?,
        notiGameStart: Bool,
        notiGameComplete: Bool
    ) {
        guard !gameID.isEmpty, gameID != "0" else { return }
        guard let updatedGame = eventSources
            .first(where: { $0.league == league })?
            .games
            .first(where: { $0.id == gameID })
        else { return }

        let pinnedToNotch = NotchViewModel.shared.notch != nil
            && (NotchViewModel.shared.currentGameID == gameID || NotchViewModel.shared.game?.id == gameID)

        if pinnedToNotch {
            currentTitle = ""
            NotchViewModel.shared.game = updatedGame
        } else {
            currentTitle = displayText(for: updatedGame, league: league)
        }

        let newState = AutoMonitorFavorite.effectiveStandardState(league: league, game: updatedGame)

        if notiGameStart, previousGameState != "in", newState == "in" {
            gameStartNotification(gameId: gameID, gameTitle: currentTitle, newState: newState)
        }
        if notiGameComplete, previousGameState != "post", newState == "post" {
            gameCompleteNotification(gameId: gameID, gameTitle: currentTitle, newState: newState)
        }

        previousGameState = newState
        currentGameState = newState
        NotchViewModel.shared.currentGameState = newState
    }
}
