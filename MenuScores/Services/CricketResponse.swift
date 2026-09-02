//
//  CricketResponse.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-09-02.
//

import Foundation

struct CricketResponse: Decodable {
    let sports: [CricketSport]
}

struct CricketSport: Decodable {
    let leagues: [CricketLeagues]
}

struct CricketLeagues: Decodable {
    let events: [CricketEvent]
}

struct CricketEvent: Decodable {
    let id: String
    let date: String
    let endDate: String?
    let name: String
    let shortName: String
    let description: String
    let location: String
    let notes: [CricketNotes]?
    let links: [CricketLinks]?
    let fullStatus: CricketFullStatus
    let competitors: [CricketCompetitors]
}

struct CricketNotes: Decodable {
    let text: String
}

struct CricketLinks: Decodable {
    let href: String
}

struct CricketFullStatus: Decodable {
    let displayClock: String
    let period: Int?
    let type: CricketStatusType
    let summary: String?
    let longSummary: String?
}

struct CricketStatusType: Decodable {
    let state: String
}

struct CricketCompetitors: Decodable {
    let winner: Bool
    let displayName: String
    let name: String
    let abbreviation: String
    let location: String
    let color: String
    let score: String
    let logo: String
}
