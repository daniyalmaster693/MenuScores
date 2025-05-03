//
//  game.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//
import Foundation

struct ScoreboardResponse: Decodable {
    let events: [Event]
}

struct Event: Decodable {
    let id: String
    let date: String
    let name: String
    let shortName: String
    let competitions: [Competition]
    let status: Status 
}

struct Status: Decodable {
    let displayClock: String
    let period: Int
    let type: Type
}

struct Type: Decodable {
    let state: String
    let completed: Bool
    let detail: String
    let shortDetail: String
}

struct Competition: Decodable {
    let competitors: [Competitor]
}

struct Competitor: Decodable {
    let id: String
    let score: String
    let team: Team
}

struct Team: Decodable {
    let displayName: String
    let abbreviation: String
    let name: String
    let logo: String
}
