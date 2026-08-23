//
//  FightInfo.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-12.
//

import Foundation

struct FightResponse: Decodable {
    let events: [FightEvent]
    let leagues: [FightLeagues]
}

struct FightLeagues: Decodable {
    let name: String?
    let abbreviation: String?
    let slug: String
}

struct FightEvent: Decodable {
    let id: String
    let date: String
    let name: String
    let shortName: String?
    let competitions: [FightCompetitions]
}

struct FightCompetitions: Decodable {
    let id: String
    let date: String
    let endDate: String
    let type: FightCompetitionType
    let status: FightStatus
    let venue: FightVenue
    let competitors: [FightCompetitor]?
    let details: [FightDetails]?
}

struct FightCompetitionType: Decodable {
    let abbreviation: String?
}

struct FightStatus: Decodable {
    let displayClock: String?
    let period: Int?
    let type: FightType
}

struct FightType: Decodable {
    let state: String
    let completed: Bool
    let detail: String?
    let shortDetail: String?
}

struct FightVenue: Decodable {
    let id: String?
    let fullName: String?
    let address: FightVenueAddress?
}

struct FightVenueAddress: Decodable {
    let city: String?
    let state: String?
}

struct FightCompetitor: Decodable {
    let id: String
    let order: Int?
    let winner: Bool?
    let athlete: FightAthlete?
    let records: [FightRecords]?
    let linescores: [FightLineScores]?
}

struct FightAthlete: Decodable {
    let fullName: String
    let displayName: String
    let shortName: String
    let flag: FightFlag
}

struct FightFlag: Decodable {
    let href: String
}

struct FightRecords: Decodable {
    let summary: String
}

struct FightLineScores: Decodable, Identifiable {
    let id: UUID = .init()
    let value: Int
    let displayValue: String

    enum CodingKeys: String, CodingKey {
        case value
        case displayValue
    }
}

struct FightDetails: Decodable {
    let type: FightDetailType
}

struct FightDetailType: Decodable {
    let text: String
}
