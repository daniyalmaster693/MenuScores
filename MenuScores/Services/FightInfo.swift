//
//  FightInfo.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-12.
//

import Foundation

struct FightResponse: Decodable {
    let sports: [FightingSports]
}

struct FightingSports: Decodable {
    let leagues: [FightingLeagues]
}

struct FightingLeagues: Decodable {
    let events: [FightEvent]
}

struct FightEvent: Decodable {
    let id: String
    let date: String
    let name: String
    let shortName: String
    let competitionId: String
    let description: String?
    let location: String?
    let note: String?
    let cardSegment: String?
}
