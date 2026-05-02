//
//  AutoMonitorFavorite.swift
//  MenuScores
//

import Foundation

enum AutoMonitorFavorite {
    static func normalizedQuery(_ raw: String) -> String {
        raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// F1 uses the race competition’s state when present; everything else uses the event status.
    static func effectiveStandardState(league: String, game: Event) -> String {
        if league == "F1", game.competitions.count > 4 {
            return game.competitions[4].status.type.state
        }
        return game.status.type.state
    }

    static func parseEventStartDate(from isoString: String) -> Date? {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        if let d = df.date(from: isoString) { return d }
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let d = df.date(from: isoString) { return d }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: isoString) { return d }
        iso.formatOptions = [.withInternetDateTime]
        return iso.date(from: isoString)
    }

    static func isEventOnLocalCalendarToday(_ game: Event) -> Bool {
        guard let start = parseEventStartDate(from: game.date) else { return false }
        return Calendar.current.isDate(start, inSameDayAs: Date())
    }

    static func stringMatchesFavorite(_ value: String?, query: String) -> Bool {
        guard let value, !value.isEmpty else { return false }
        let v = value.lowercased()
        if v == query || v.contains(query) || query.contains(v) { return true }
        let parts = query.split { !$0.isLetter && !$0.isNumber }.map(String.init).filter { $0.count >= 3 }
        guard !parts.isEmpty else { return false }
        return parts.allSatisfy { v.contains($0) }
    }

    static func competitorMatches(_ c: Competitor, query: String) -> Bool {
        if let team = c.team {
            if stringMatchesFavorite(team.abbreviation, query: query) { return true }
            if stringMatchesFavorite(team.displayName, query: query) { return true }
            if stringMatchesFavorite(team.name, query: query) { return true }
        }
        if let a = c.athlete {
            if stringMatchesFavorite(a.fullName, query: query) { return true }
            if stringMatchesFavorite(a.displayName, query: query) { return true }
            if stringMatchesFavorite(a.shortName, query: query) { return true }
        }
        return false
    }

    static func eventInvolvesFavorite(_ game: Event, query: String) -> Bool {
        guard !query.isEmpty else { return false }
        for competition in game.competitions {
            guard let competitors = competition.competitors else { continue }
            for c in competitors where competitorMatches(c, query: query) {
                return true
            }
        }
        return false
    }

    /// Picks a favorite game: live (`in`) any day in the feed, or `pre` / `post` only when the event starts on the **local** calendar today.
    /// Previously only `in` matched, so finished games (e.g. Blue Jays after the final) or not-yet-started games never appeared.
    static func findStandardEventForAutoMonitor(
        normalizedQuery: String,
        sources: [(league: String, games: [Event])]
    ) -> (league: String, game: Event)? {
        guard !normalizedQuery.isEmpty else { return nil }

        for (league, games) in sources {
            for game in games {
                guard eventInvolvesFavorite(game, query: normalizedQuery) else { continue }
                let state = effectiveStandardState(league: league, game: game)
                if state == "in" { return (league, game) }
            }
        }

        for (league, games) in sources {
            for game in games {
                guard eventInvolvesFavorite(game, query: normalizedQuery) else { continue }
                let state = effectiveStandardState(league: league, game: game)
                if state == "pre", isEventOnLocalCalendarToday(game) { return (league, game) }
            }
        }

        for (league, games) in sources {
            for game in games {
                guard eventInvolvesFavorite(game, query: normalizedQuery) else { continue }
                let state = effectiveStandardState(league: league, game: game)
                if state == "post", isEventOnLocalCalendarToday(game) { return (league, game) }
            }
        }

        return nil
    }

    static func tennisAthleteMatches(_ a: TennisAthletes, query: String) -> Bool {
        stringMatchesFavorite(a.fullName, query: query)
            || stringMatchesFavorite(a.displayName, query: query)
            || stringMatchesFavorite(a.shortName, query: query)
    }

    static func tennisAthleteMatches(_ a: TennisAthlete, query: String) -> Bool {
        stringMatchesFavorite(a.fullName, query: query)
            || stringMatchesFavorite(a.displayName, query: query)
            || stringMatchesFavorite(a.shortName, query: query)
    }

    static func tennisCompetitorMatches(_ c: TennisCompetitor, query: String) -> Bool {
        if let a = c.athlete, tennisAthleteMatches(a, query: query) { return true }
        if let roster = c.roster?.athletes {
            for a in roster where tennisAthleteMatches(a, query: query) { return true }
        }
        return false
    }

    static func isTennisCompetitionLive(game: TennisEvent, competition: TennisCompetition) -> Bool {
        if competition.status?.type.state == "in" { return true }
        return game.status.type.state == "in"
    }

    static func tennisMenubarTitle(competition: TennisCompetition) -> String {
        let team1 =
            competition.competitors?.first?.athlete?.shortName
            ?? competition.competitors?.first?.roster?.shortDisplayName ?? "Player 1"
        let team2 =
            competition.competitors?.dropFirst().first?.athlete?.shortName
            ?? competition.competitors?.dropFirst().first?.roster?.shortDisplayName ?? "Player 2"
        return "\(team1) - \(team2)"
    }

    static func findLiveTennisEvent(
        normalizedQuery: String,
        sources: [(league: String, games: [TennisEvent])]
    ) -> (league: String, game: TennisEvent, title: String)? {
        guard !normalizedQuery.isEmpty else { return nil }
        for (league, games) in sources {
            for game in games {
                for group in game.groupings {
                    for competition in group.competitions {
                        guard isTennisCompetitionLive(game: game, competition: competition) else { continue }
                        guard let competitors = competition.competitors else { continue }
                        if competitors.contains(where: { tennisCompetitorMatches($0, query: normalizedQuery) }) {
                            return (league, game, tennisMenubarTitle(competition: competition))
                        }
                    }
                }
            }
        }
        return nil
    }
}
