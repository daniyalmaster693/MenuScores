//
//  game.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

struct ScoreboardResponse: Decodable {
    let events: [Event]
    let leagues: [Leagues]
}

struct Leagues: Decodable {
    let name: String?
    let abbreviation: String?
    let slug: String
}

struct Event: Decodable {
    let id: String
    let date: String
    let endDate: String?
    let name: String
    let shortName: String
    let competitions: [Competition]
    let status: Status
    let links: [Links]?
    let circuit: Circuit?
}

struct Status: Decodable {
    let displayClock: String?
    let period: Int?
    let type: Type
}

struct Type: Decodable {
    let state: String
    let completed: Bool
    let detail: String?
    let shortDetail: String?
}

struct Competition: Decodable {
    let competitors: [Competitor]?
    let status: Status
    let situation: Situation?
    let highlights: [Highlights]?
    let headlines: [Headlines]?
}

struct Competitor: Decodable {
    let id: String
    let score: String?
    let order: Int?
    let winner: Bool?
    let athlete: Athlete?
    let team: Team?
}

struct Team: Decodable {
    let id: String
    let displayName: String
    let abbreviation: String
    let name: String
    let logo: String?
    let links: [Links]
    let color: String?
    let alternateColor: String?
}

struct Athlete: Decodable {
    let fullName: String
    let displayName: String
    let shortName: String
    let flag: Flag?
}

struct Links: Decodable {
    let language: String?
    let href: String
    let text: String
    let shortText: String?
    let isExternal: Bool
    let isPremium: Bool
}

struct Flag: Decodable {
    let href: String
    let alt: String
}

struct Circuit: Decodable {
    let id: String
    let fullName: String
    let address: Address
}

struct Address: Decodable {
    let city: String
    let country: String
}

struct Situation: Decodable {
    let lastPlay: LastPlay
    let balls: Int?
    let outs: Int?
    let strikes: Int?
    let downDistanceText: String?
}

struct LastPlay: Decodable {
    let text: String
    let type: PlayType
    let team: TeamID
}

struct PlayType: Decodable {
    let text: String
}

struct TeamID: Decodable {
    let id: String
}

struct Highlights: Decodable {
    let headline: String
    let description: String
}

struct Headlines: Decodable {
    let shortLinkText: String?
    let description: String?
}
