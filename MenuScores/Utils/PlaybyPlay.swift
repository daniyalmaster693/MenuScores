//
//  PlaybyPlay.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-19.
//

import Foundation

struct PlaybyPlayResponse: Decodable {
    let plays: [Plays]?
}

struct Plays: Decodable {
    let text: String?
    let team: TeamID?

//    let id: String
//    let type: [PlayType]
//    let awayScore: Int
//    let homeScore: Int
//    let outs: Int?
//    let scoreValue: Int?
}

// struct PlayType: Decodable {
//    let id: String
//    let text: String
//    let type: String
//    let alternateText: String?
// }
//
struct TeamID: Decodable {
    let id: String
}

//
// struct Period: Decodable {
//    let type: String
//    let number: Int
//    let displayValue: String
// }
