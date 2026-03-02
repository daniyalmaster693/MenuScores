//
//  FavoriteTeam.swift
//  MenuScores
//
//  Created by Claude on 2025-02-24.
//

import Foundation

// MARK: - Favorite Team Model

struct FavoriteTeam: Codable, Identifiable, Hashable {
    let id: String           // ESPN team ID
    let leagueKey: String    // e.g., "NHL", "NBA"
    let displayName: String
    let abbreviation: String
    let logo: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(leagueKey)
    }

    static func == (lhs: FavoriteTeam, rhs: FavoriteTeam) -> Bool {
        lhs.id == rhs.id && lhs.leagueKey == rhs.leagueKey
    }
}

// MARK: - ESPN Teams API Response Models

struct TeamsResponse: Decodable {
    let sports: [SportTeams]
}

struct SportTeams: Decodable {
    let leagues: [LeagueTeams]
}

struct LeagueTeams: Decodable {
    let teams: [TeamWrapper]
}

struct TeamWrapper: Decodable {
    let team: TeamInfo
}

struct TeamInfo: Decodable, Identifiable {
    let id: String
    let displayName: String
    let abbreviation: String
    let logos: [TeamLogo]?

    var primaryLogo: String? {
        logos?.first?.href
    }
}

struct TeamLogo: Decodable {
    let href: String
    let width: Int?
    let height: Int?
}
