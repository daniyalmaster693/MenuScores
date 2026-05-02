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
    private var refreshAll: (() async -> Void)?
    private var eventSources: (() -> [(league: String, games: [Event])])?
    private var tennisSources: (() -> [(league: String, games: [TennisEvent])])?
    private var apply: ((String, String, String, String?) -> Void)?

    private init() {}

    func configure(
        isEnabled: @escaping () -> Bool,
        favoriteRaw: @escaping () -> String,
        refreshAll: @escaping () async -> Void,
        eventSources: @escaping () -> [(league: String, games: [Event])],
        tennisSources: @escaping () -> [(league: String, games: [TennisEvent])],
        apply: @escaping (String, String, String, String?) -> Void
    ) {
        self.isEnabled = isEnabled
        self.favoriteRaw = favoriteRaw
        self.refreshAll = refreshAll
        self.eventSources = eventSources
        self.tennisSources = tennisSources
        self.apply = apply
    }

    func tick() async {
        guard isEnabled() else { return }
        let q = AutoMonitorFavorite.normalizedQuery(favoriteRaw())
        guard !q.isEmpty else { return }

        await refreshAll?()

        if let fetchEvents = eventSources {
            let events = fetchEvents()
            if let found = AutoMonitorFavorite.findStandardEventForAutoMonitor(
                normalizedQuery: q,
                sources: events
            ) {
                let newState = found.game.status.type.state
                apply?(
                    displayText(for: found.game, league: found.league),
                    found.game.id,
                    newState,
                    newState
                )
                return
            }
        }

        if let fetchTennis = tennisSources,
           let tennis = AutoMonitorFavorite.findLiveTennisEvent(
               normalizedQuery: q,
               sources: fetchTennis()
           )
        {
            let newState = tennis.game.status.type.state
            apply?(
                tennis.title,
                tennis.game.id,
                newState,
                newState
            )
        }
    }
}
