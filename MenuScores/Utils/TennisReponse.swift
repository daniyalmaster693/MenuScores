//
//  TennisReponse.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-02-07.
//

import Foundation

struct TennisResponse: Decodable {
    let events: [TennisEvent]
    let leagues: [TennisLeagues]
}

struct TennisLeagues: Decodable {
    let name: String?
    let abbreviation: String?
    let slug: String
}

struct TennisEvent: Decodable {
    let id: String
    let date: String
    let endDate: String?
    let name: String
    let shortName: String?
    let groupings: [Groupings]
    let status: Status
    let links: [TennisLinks]?
}

struct TennisLinks: Decodable {
    let language: String?
    let href: String
    let text: String
    let shortText: String?
    let isExternal: Bool
    let isPremium: Bool
}

struct Groupings: Decodable {
    let grouping: Grouping
    let competitions: [TennisCompetition]
}

struct Grouping: Decodable {
    let id: String
    let displayName: String
}

struct TennisCompetition: Decodable {
    let id: String
    let date: String
    let startDate: String?
    let competitors: [TennisCompetitor]?
}

struct TennisCompetitor: Decodable {
    let id: String
    let score: String?
    let order: Int?
    let winner: Bool?
    let athlete: TennisAthlete?
    let roster: TennisRoster?
}

struct TennisAthlete: Decodable {
    let fullName: String
    let displayName: String
    let shortName: String
    let flag: TennisFlag?
}

struct TennisFlag: Decodable {
    let href: String
    let alt: String
}

struct TennisRoster: Decodable {
    let displayName: String?
    let shortDisplayName: String?
    let athletes: [TennisAthletes]?
}

struct TennisAthletes: Decodable {
    let fullName: String
    let displayName: String
    let shortName: String
    let flag: TennisFlag?
}
