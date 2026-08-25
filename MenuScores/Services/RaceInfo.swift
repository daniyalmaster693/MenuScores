//
//  RaceInfo.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-22.
//

import Foundation

struct RaceResponse: Decodable {
    let sports: [Sport]
}

struct Sport: Decodable {
    let leagues: [RaceLeagues]
}

struct RaceLeagues: Decodable {
    let events: [RaceEvent]
}

struct RaceEvent: Decodable {
    let id: String
    let date: String
    let name: String
    let shortName: String
    let competitionId: String
    let competitionType: CompetitionType?
    let description: String?
    let location: String?
    let links: [RaceLinks]
    let status: String?
    let fullStatus: FullStatus
    let summary: String?
    let period: Int?
    let laps: String?
    let trackText: String?
    let track: Track?
    let competitors: [Driver]?
}

struct RaceLinks: Decodable {
    let href: String
}

struct CompetitionType: Decodable {
    let abbreviation: String?
    let text: String
}

struct FullStatus: Decodable {
    let period: Int?
    let flag: String?
    let type: RacingStatus
}

struct RacingStatus: Decodable {
    let state: String
    let completed: Bool
    let description: String
    let detail: String
    let shortDetail: String
}

struct Track: Decodable {
    let length: Double?
    let displayLength: String?
}

struct Driver: Decodable {
    let id: String
    let order: Int?
    let winner: Bool?
    let displayName: String
    let name: String
    let abbreviation: String?
    let shortName: String?
    let firstName: String?
    let lastName: String?
    let startOrder: Int?
    let logo: String?
    let headshot: String?
    let lapsLed: String?
    let laps: String?
    let place: Int?
    let behindTime: String?
    let behindLaps: String?
    let time: String?
    let score: String?
    let pitsTaken: String?
    let vehicle: Vehicle?
    let status: DriverStatus?
}

struct DriverStatus: Decodable {
    let displayValue: String?
    let period: Int?
}

struct Vehicle: Decodable {
    let manufacturer: String?
    let number: String?
    let teamColor: String?
}
