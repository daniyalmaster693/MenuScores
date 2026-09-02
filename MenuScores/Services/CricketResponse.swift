//
//  CricketResponse.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-09-02.
//

import Foundation

struct CricketResponse: Decodable {
    let sports: [CricketSport]
    let events: [CricketEvent]
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
}

struct CricketLinks: Decodable {
    let href: String
}
