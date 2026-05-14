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

// MARK: Cricket Only

// Known IPL franchise team names — used to identify IPL matches from CricAPI
// (CricAPI match names are "MI vs PBKS, 51st Match" — no series name included)
private let iplTeamNames: Set<String> = [
    "Mumbai Indians", "Chennai Super Kings",
    "Royal Challengers Bengaluru", "Royal Challengers Bangalore",
    "Kolkata Knight Riders", "Delhi Capitals", "Punjab Kings",
    "Rajasthan Royals", "Sunrisers Hyderabad",
    "Gujarat Titans", "Lucknow Super Giants"
]

@MainActor
class CricketScheduleListView: ObservableObject {
    @Published var matches: [CricAPIMatch] = []

    let seriesFilter: String?
    private let apiKey = "YOUR CRICAPI KEY" // Get a free key at cricapi.com
    private var lastFetchTime: Date? = nil
    private var isFetching = false
    private let minFetchInterval: TimeInterval = 900 // 15 minutes

    init(seriesFilter: String? = nil) {
        self.seriesFilter = seriesFilter
        Task { await self.fetchSchedule() }
    }

    func fetchSchedule() async {
        guard !isFetching else { return }
        if let last = lastFetchTime, Date().timeIntervalSince(last) < minFetchInterval { return }

        isFetching = true
        defer { isFetching = false }

        let seriesFilter = self.seriesFilter
        var combined: [CricAPIMatch] = []
        var anySuccess = false

        let endpoints = [
            "https://api.cricapi.com/v1/currentMatches?apikey=\(apiKey)&offset=0",
            "https://api.cricapi.com/v1/matches?apikey=\(apiKey)&offset=0"
        ]

        for urlString in endpoints {
            guard let url = URL(string: urlString) else { continue }
            do {
                let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    print("[Cricket] HTTP error \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    continue
                }
                let decoded = try JSONDecoder().decode(CricAPIListResponse.self, from: data)
                combined.append(contentsOf: decoded.data ?? [])
                anySuccess = true
            } catch {
                print("[Cricket] Decode error:", error)
            }
        }

        guard anySuccess else { return } // Don't start cooldown if all requests failed

        // Deduplicate
        var seen = Set<String>()
        var deduped = combined.filter { seen.insert($0.id).inserted }

        // Filter — CricAPI puts only team names in match.name, not the series.
        // For IPL: match by known franchise team names.
        // For ICC (nil filter): show all matches that are NOT IPL.
        if let _ = seriesFilter {
            deduped = deduped.filter { match in
                (match.teams ?? []).contains { iplTeamNames.contains($0) }
            }
        } else {
            // ICC menu: exclude IPL matches
            deduped = deduped.filter { match in
                !(match.teams ?? []).contains { iplTeamNames.contains($0) }
            }
        }

        deduped.sort { $0.startTimestamp < $1.startTimestamp }

        print("[Cricket] Fetched \(deduped.count) matches (IPL filter: \(seriesFilter != nil))")
        // Only start cooldown after we actually got results
        if !deduped.isEmpty {
            self.matches = deduped
            lastFetchTime = Date()
        }
        // If empty, lastFetchTime stays nil/old so next call can retry
    }

    // Force-refresh bypasses the cooldown (used by the manual Refresh button)
    func forceRefresh() async {
        lastFetchTime = nil
        await fetchSchedule()
    }

    // Refresh a single pinned match to get updated live scores
    func refreshMatch(id: String) async -> CricAPIMatch? {
        guard let url = URL(string: "https://api.cricapi.com/v1/match_info?apikey=\(apiKey)&id=\(id)") else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { return nil }
            let decoded = try JSONDecoder().decode(CricAPISingleResponse.self, from: data)
            return decoded.data
        } catch {
            return nil
        }
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
