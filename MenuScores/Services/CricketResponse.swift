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
    let links: [CricketLinks]?
    let fullStatus: CricketFullStatus
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
