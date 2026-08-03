//
//  RefreshManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-03.
//

import SwiftUI

@MainActor
class RefreshManager: NSObject, ObservableObject {
    static let shared = RefreshManager()

    // Refresh Interval Settings

    var timer: Timer?

    private var selectedOption: String {
        UserDefaults.standard.string(forKey: "refreshInterval") ?? "15 seconds"
    }

    private var currentInterval: TimeInterval {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
        }
    }

    // Notification Settings

    private var notiGameStart: Bool {
        UserDefaults.standard.bool(forKey: "notiGameStart")
    }

    private var notiGameComplete: Bool {
        UserDefaults.standard.bool(forKey: "notiGameComplete")
    }

    // Refresh Helpers

    @MainActor
    func standardRefresh(
        viewModel: GamesListView,
        league: String,
        fetchURL: URL,
        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,
        pinnedByMenubar: Bool,
        pinnedByNotch: Bool,
        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateGames(from: fetchURL)
        await FavoritesManager.shared.checkForFavoriteGames(
            in: viewModel,
            league: league,
            currentGameID: currentGameID,
            currentGameState: currentGameState,
            currentTitle: currentTitle
        )

        if let updatedGame = viewModel.games.first(where: { $0.id == currentGameID.wrappedValue }) {
            if pinnedByMenubar {
                currentTitle.wrappedValue = displayText(for: updatedGame, league: league)
            } else if pinnedByNotch {
                currentTitle.wrappedValue = ""
            }

            let newState = updatedGame.status.type.state

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: currentTitle.wrappedValue, newState: newState)
            }
            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: currentTitle.wrappedValue, newState: newState)
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch {
                notchViewModel.game = updatedGame
            }
        }
    }

    @MainActor
    func tennisRefresh(
        viewModel: TennisListView,
        league: String,
        fetchURL: URL,
        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,
        pinnedByMenubar: Bool,
        pinnedByNotch: Bool,
        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateTennis(from: fetchURL)

        if let updatedCompetition = viewModel.tennisGames
            .flatMap({ $0.groupings })
            .flatMap({ $0.competitions })
            .first(where: { $0.id == currentGameID.wrappedValue })
        {
            if pinnedByMenubar {
                currentTitle.wrappedValue = displayTennisText(for: updatedCompetition)
            } else if pinnedByNotch {
                currentTitle.wrappedValue = ""
            }

            let newState = updatedCompetition.status?.type.state ?? "pre"

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: currentTitle.wrappedValue, newState: newState)
            }
            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: currentTitle.wrappedValue, newState: newState)
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch {
                notchViewModel.tennisCompetition = updatedCompetition
            }
        }
    }

    // Refresh System

    @MainActor
    func performRefesh() async {}

    func startTimer(action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: currentInterval, repeats: true) { _ in
            action()
        }
    }
}
