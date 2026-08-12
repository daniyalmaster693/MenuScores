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
    let fullStatus: FightFullStatus
}

struct FightFullStatus: Decodable {
    let displayClock: String
    let period: Int
    let displayPeriod: String
    let type: FightType
    let result: FightResult?
}

struct FightType: Decodable {
    let state: String
    let completed: Bool
    let description: String
    let detail: String
    let shortDetail: String
}

struct FightResult: Decodable {
    let name: String?
    let shortName: String?
    let shortDisplayName: String?
}
