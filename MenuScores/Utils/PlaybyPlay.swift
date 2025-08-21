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
}

struct Plays: Decodable {
    let text: String?
    let shortText: String?
    let team: TeamID?
    let outs: Int?
    let pitchCount: PitchCount?
}

struct PitchCount: Decodable {
    let balls: Int?
    let strikes: Int?
}

struct TeamID: Decodable {
    let id: String
}
