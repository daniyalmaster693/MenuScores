//
//  FavoriteTeam.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-29.
//

import Foundation

struct FavoriteTeam: Codable, Identifiable, Hashable {
    let id: String
    let leagueKey: String
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

struct TeamsResponse: Decodable {
    let sports: [SportsLeagues]
}

struct SportsLeagues: Decodable {
    let name: String
    let leagues: [LeagueTeams]
}

struct LeagueTeams: Decodable {
    let abbreviation: String
    let name: String
    let teams: [TeamDetails]
}

struct TeamDetails: Decodable {
    let team: TeamInfo
}

struct TeamInfo: Decodable, Identifiable {
    let id: String
    let color: String?
    let alternateColor: String?
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
