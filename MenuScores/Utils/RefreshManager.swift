//
//  RefreshManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-03.
//

import DynamicNotchKit
import SwiftUI

@MainActor
class RefreshManager: NSObject, ObservableObject {
    static let shared = RefreshManager()

    // Refresh Interval Settings

    private var timer: Timer?
    private var refreshActions: [String: () -> Void] = [:]

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

    // Auto Pin Settings

    private var autoPinFavorites: Bool {
        UserDefaults.standard.bool(forKey: "autoPinFavorites")
    }

    // Notification Settings

    private var notiGameStart: Bool {
        UserDefaults.standard.bool(forKey: "notiGameStart")
    }

    private var notiGameComplete: Bool {
        UserDefaults.standard.bool(forKey: "notiGameComplete")
    }

    // Refresh Helpers

    enum RefreshType {
        case standard
        case racing
        case tennis
        case fighting
    }

    @MainActor
    func standardRefresh(
        viewModel: GamesListView,
        league: String,
        fetchURL: () -> URL,

        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,

        pinnedByMenubar: Binding<Bool>,
        pinnedByNotch: Binding<Bool>,

        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateGames(from: fetchURL())

        if let updatedGame = viewModel.games.first(where: { $0.id == currentGameID.wrappedValue }) {
            let notificationTitle = displayText(for: updatedGame, league: league)

            if pinnedByMenubar.wrappedValue {
                currentTitle.wrappedValue = displayText(for: updatedGame, league: league)
            } else if pinnedByNotch.wrappedValue {
                currentTitle.wrappedValue = ""
            }

            let newState = updatedGame.status.type.state

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Game")
            }

            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Game")
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch.wrappedValue {
                notchViewModel.game = updatedGame
            }
        }
    }

    @MainActor
    func racingRefresh(
        viewModel: RacingListView,
        league: String,
        fetchURL: () -> URL,

        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,

        pinnedByMenubar: Binding<Bool>,
        pinnedByNotch: Binding<Bool>,

        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateRacing(from: fetchURL())

        if let race = viewModel.races.first(where: { $0.id == currentGameID.wrappedValue }) {
            let notificationTitle: String

            if league == "F1" {
                notificationTitle = displayF1Text(for: race)
            } else {
                notificationTitle = displayRacingText(for: race)
            }

            if pinnedByMenubar.wrappedValue {
                if league == "F1" {
                    currentTitle.wrappedValue = displayF1Text(for: race)
                } else {
                    currentTitle.wrappedValue = displayRacingText(for: race)
                }
            } else if pinnedByNotch.wrappedValue {
                currentTitle.wrappedValue = ""
            }

            let newState = race.fullStatus.type.state

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Race")
            }

            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Race")
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch.wrappedValue {
                notchViewModel.racingCompetition = race
            }
        }
    }

    @MainActor
    func fightingRefresh(
        viewModel: FightingListView,
        league: String,
        fetchURL: () -> URL,

        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,

        pinnedByMenubar: Binding<Bool>,
        pinnedByNotch: Binding<Bool>,

        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateFighting(from: fetchURL())

        if let fight = viewModel.fights.first(where: { $0.id == currentGameID.wrappedValue }) {
            let notificationTitle = displayFightingText(for: fight)

            if pinnedByMenubar.wrappedValue {
                currentTitle.wrappedValue = displayFightingText(for: fight)
            } else if pinnedByNotch.wrappedValue {
                currentTitle.wrappedValue = ""
            }

            let newState = fight.status.type.state

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Fight")
            }

            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Fight")
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch.wrappedValue {
                notchViewModel.fightCompetition = fight
            }
        }
    }

    @MainActor
    func tennisRefresh(
        viewModel: TennisListView,
        league: String,
        fetchURL: () -> URL,

        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,

        pinnedByMenubar: Binding<Bool>,
        pinnedByNotch: Binding<Bool>,

        notchViewModel: NotchViewModel
    ) async {
        await viewModel.populateTennis(from: fetchURL())

        if let updatedCompetition = viewModel.tennisGames
            .flatMap({ $0.groupings })
            .flatMap({ $0.competitions })
            .first(where: { $0.id == currentGameID.wrappedValue })
        {
            let notificationTitle = displayTennisText(for: updatedCompetition)

            if pinnedByMenubar.wrappedValue {
                currentTitle.wrappedValue = displayTennisText(for: updatedCompetition)
            } else if pinnedByNotch.wrappedValue {
                currentTitle.wrappedValue = ""
            }

            let newState = updatedCompetition.status?.type.state ?? "pre"

            if notiGameStart && previousGameState.wrappedValue != "in" && newState == "in" {
                gameStartNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Game")
            }

            if notiGameComplete && previousGameState.wrappedValue != "post" && newState == "post" {
                gameCompleteNotification(gameId: currentGameID.wrappedValue, gameTitle: notificationTitle, newState: newState, eventType: "Game")
            }

            previousGameState.wrappedValue = newState
            currentGameState.wrappedValue = newState

            if pinnedByNotch.wrappedValue {
                notchViewModel.tennisCompetition = updatedCompetition
            }
        }
    }

    @MainActor
    func performRefresh(
        viewModel: GamesListView? = nil,
        racingViewModel: RacingListView? = nil,
        tennisViewModel: TennisListView? = nil,
        fightingViewModel: FightingListView? = nil,
        league: String,
        fetchURL: () -> URL,

        currentTitle: Binding<String>,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        previousGameState: Binding<String?>,

        type: RefreshType,
        pinnedByMenubar: Binding<Bool>,
        pinnedByNotch: Binding<Bool>,

        notchViewModel: NotchViewModel
    ) async {
        switch type {
        case .standard:
            if let viewModel {
                await standardRefresh(
                    viewModel: viewModel,
                    league: league,
                    fetchURL: fetchURL,
                    currentTitle: currentTitle,
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    previousGameState: previousGameState,
                    pinnedByMenubar: pinnedByMenubar,
                    pinnedByNotch: pinnedByNotch,
                    notchViewModel: notchViewModel
                )
            }

        case .racing:
            if let racingViewModel {
                await racingRefresh(
                    viewModel: racingViewModel,
                    league: league,
                    fetchURL: fetchURL,
                    currentTitle: currentTitle,
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    previousGameState: previousGameState,
                    pinnedByMenubar: pinnedByMenubar,
                    pinnedByNotch: pinnedByNotch,
                    notchViewModel: notchViewModel
                )
            }

        case .tennis:
            if let tennisViewModel {
                await tennisRefresh(
                    viewModel: tennisViewModel,
                    league: league,
                    fetchURL: fetchURL,
                    currentTitle: currentTitle,
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    previousGameState: previousGameState,
                    pinnedByMenubar: pinnedByMenubar,
                    pinnedByNotch: pinnedByNotch,
                    notchViewModel: notchViewModel
                )
            }

        case .fighting:
            if let fightingViewModel {
                await fightingRefresh(
                    viewModel: fightingViewModel,
                    league: league,
                    fetchURL: fetchURL,
                    currentTitle: currentTitle,
                    currentGameID: currentGameID,
                    currentGameState: currentGameState,
                    previousGameState: previousGameState,
                    pinnedByMenubar: pinnedByMenubar,
                    pinnedByNotch: pinnedByNotch,
                    notchViewModel: notchViewModel
                )
            }
        }
    }

    // Refresh System

    @MainActor
    func startTimer(
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>
    ) {
        timer?.invalidate()

        timer = Timer.scheduledTimer(
            withTimeInterval: currentInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor in
                self?.refreshActions.values.forEach { action in
                    action()
                }

                if self?.autoPinFavorites == true {
                    await FavoritesManager.shared.checkForFavorites(
                        currentGameID,
                        currentGameState,
                        currentTitle
                    )
                }
            }
        }
    }

    @MainActor
    func registerRefreshAction(
        for league: String,
        currentGameID: Binding<String>,
        currentGameState: Binding<String>,
        currentTitle: Binding<String>,
        action: @escaping () -> Void
    ) {
        refreshActions[league] = action

        Task {
            action()
        }

        if timer == nil {
            startTimer(
                currentGameID: currentGameID,
                currentGameState: currentGameState,
                currentTitle: currentTitle
            )
        }
    }

    @MainActor
    func unregisterRefreshAction(for league: String) {
        refreshActions.removeValue(forKey: league)
        if refreshActions.isEmpty {
            timer?.invalidate()
            timer = nil
        }
    }
}
