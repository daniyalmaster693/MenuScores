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
}

struct Competition: Decodable {
    let competitors: [Competitor]
}

struct Competitor: Decodable {
    let team: Team
}

struct Team: Decodable {
    let name: String
    let logo: String
}
