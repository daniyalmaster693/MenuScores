//
//  AutoMonitorHub.swift
//  MenuScores
//

import Foundation

@MainActor
final class AutoMonitorHub {
    static let shared = AutoMonitorHub()

    private var isEnabled: () -> Bool = { false }
    private var favoriteRaw: () -> String = { "" }
    private var enabledLeagues: () -> [String] = { [] }
    private var eventSources: (() -> [(league: String, games: [Event])])?
    private var tennisSources: (() -> [(league: String, games: [TennisEvent])])?
    private var apply: ((String, String, String, String) -> Void)?

    private var autoMonitorScanIndex = 0
    private var lastMatchedLeague: String?

    private init() {}

    func configure(
        isEnabled: @escaping () -> Bool,
        favoriteRaw: @escaping () -> String,
        enabledLeagues: @escaping () -> [String],
        eventSources: @escaping () -> [(league: String, games: [Event])],
        tennisSources: @escaping () -> [(league: String, games: [TennisEvent])],
        apply: @escaping (String, String, String, String) -> Void
    ) {
        self.isEnabled = isEnabled
        self.favoriteRaw = favoriteRaw
        self.enabledLeagues = enabledLeagues
        self.eventSources = eventSources
        self.tennisSources = tennisSources
        self.apply = apply
    }

    /// Leagues to refresh before `scanAndApply()` (one league while scanning, pinned league once matched).
    func leaguesToRefreshThisTick() -> [String] {
        guard isEnabled() else { return [] }
        let q = AutoMonitorFavorite.normalizedQuery(favoriteRaw())
        guard !q.isEmpty else { return [] }

        if let lastMatchedLeague {
            return [lastMatchedLeague]
        }

        let leagues = enabledLeagues()
        guard !leagues.isEmpty else { return [] }
        return [leagues[autoMonitorScanIndex % leagues.count]]
    }

    func scanAndApply() {
        guard isEnabled() else { return }
        let q = AutoMonitorFavorite.normalizedQuery(favoriteRaw())
        guard !q.isEmpty else { return }

        if let match = findMatch(normalizedQuery: q) {
            applyMatch(match)
            lastMatchedLeague = leagueCode(for: match)
            return
        }

        if lastMatchedLeague != nil {
            lastMatchedLeague = nil
        } else {
            let leagues = enabledLeagues()
            if !leagues.isEmpty {
                autoMonitorScanIndex = (autoMonitorScanIndex + 1) % leagues.count
            }
        }
    }

    private enum Match {
        case standard(league: String, game: Event)
        case tennis(league: String, game: TennisEvent, title: String)
    }

    private func findMatch(normalizedQuery: String) -> Match? {
        if let fetchEvents = eventSources,
           let found = AutoMonitorFavorite.findStandardEventForAutoMonitor(
               normalizedQuery: normalizedQuery,
               sources: fetchEvents()
           )
        {
            return .standard(league: found.league, game: found.game)
        }

        if let fetchTennis = tennisSources,
           let tennis = AutoMonitorFavorite.findLiveTennisEvent(
               normalizedQuery: normalizedQuery,
               sources: fetchTennis()
           )
        {
            return .tennis(league: tennis.league, game: tennis.game, title: tennis.title)
        }

        return nil
    }

    private func leagueCode(for match: Match) -> String {
        switch match {
        case let .standard(league, _): return league
        case let .tennis(league, _, _): return league
        }
    }

    private func applyMatch(_ match: Match) {
        switch match {
        case let .standard(league, game):
            let newState = AutoMonitorFavorite.effectiveStandardState(league: league, game: game)
            apply?(
                displayText(for: game, league: league),
                game.id,
                newState,
                league
            )
        case let .tennis(league, game, title):
            let newState = game.status.type.state
            apply?(title, game.id, newState, league)
        }
    }
}
