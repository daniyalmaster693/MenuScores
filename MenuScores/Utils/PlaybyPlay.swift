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
}

struct Plays: Decodable {
    let text: String?
    let team: TeamID?
    let type: PlayType?
    let outs: Int?
    let pitchCount: PitchCount?
}

struct PlayType: Decodable {
    let id: String
    let text: String
    let type: String
    let alternateText: String?
}

struct PitchCount: Decodable {
    let balls: Int?
    let strikes: Int?
}

struct TeamID: Decodable {
    let id: String
}
