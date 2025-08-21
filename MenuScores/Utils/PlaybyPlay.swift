//
//  PlaybyPlay.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-19.
//

import Foundation

struct PlaybyPlayResponse: Decodable {
    let plays: [Plays]?
    let scoringPlays: [Plays]?
    let keyEvents: [Plays]?
    let article: Article?
}

struct Article: Decodable {
    let type: String?
    let headline: String?
    let description: String?
    let linkText: String?
}

struct Plays: Decodable {
    let text: String?
    let shortText: String?
    let team: TeamID?
    let outs: Int?
    let type: PlayType?
    let pitchCount: PitchCount?
}

struct PlayType: Decodable {
    let id: String?
    let text: String?
    let type: String?
    let alternateText: String?
}

struct PitchCount: Decodable {
    let balls: Int?
    let strikes: Int?
}

struct TeamID: Decodable {
    let id: String
}
