//
//  GameState.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-10.
//

func displayText(for game: Event, league: String) -> String {
    guard let competition = game.competitions.first else { return game.shortName }
    let competitors = competition.competitors

    let prefix = periodPrefix(for: league)

    switch game.status.type.state {
    case "pre":
        return "\(game.shortName) - \(formattedTime(from: game.date))"
    case "in":
        return "\(competitors[1].team.abbreviation) \(competitors[1].score) - \(competitors[0].team.abbreviation) \(competitors[0].score)    \(prefix)\(game.status.period) \(game.status.displayClock)"
    case "post":
        return "\(competitors[1].team.abbreviation) \(competitors[1].score) - \(competitors[0].team.abbreviation) \(competitors[0].score)    (Final)"
    default:
        return game.shortName
    }
}
