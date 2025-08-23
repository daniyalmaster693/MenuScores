//
//  RaceInfo.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-22.
//

struct RaceInfoResponse: Decodable {
    let sports: [Sport]
}

struct Sport: Decodable {
    let leagues: [RaceLeagues]
}

struct RaceLeagues: Decodable {
    let events: [Race]
}

struct Race: Decodable {
    let id: String
    let date: String
    let name: String
    let shortName: String
    let competitionId: String
    let description: String
    let location: String
    let link: String
    let status: String
    let summary: String
    let period: Int
    let laps: String
    let trackText: String
    let track: Track
    let note: String
    let competitors: [Driver]
}

struct Track: Decodable {
    let length: Double
    let displayLength: String
}

struct Driver: Decodable {
    let id: String
    let order: Int?
    let winner: Bool
    let displayName: String
    let name: String
    let abbreviation: String
    let shortName: String
    let startOrder: Int?
    let logo: String
    let headshot: String?
    let lapsLed: String?
    let laps: String
    let place: Int
    let behindTime: String?
    let behindLaps: String?
    let time: String?
    let pitsTaken: String?
    let vehicle: Vehicle?
}

struct Vehicle: Decodable {
    let manufacturer: String?
    let number: String?
    let teamColor: String?
}
