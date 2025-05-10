//
//  GameState.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-10.
//

func displayText(for game: Event) -> String {
    guard let competition = game.competitions.first else { return game.shortName }
    let competitors = competition.competitors
    let currentLeague = LeagueSelectionModel.shared.currentLeague
    let prefix = periodPrefix(for: currentLeague)
    
    switch game.status.type.state {
    case "pre":
        return "\(game.shortName) - \(formattedTime(from: game.date))"
    case "in":
        let team1 = competitors[1]
        let team0 = competitors[0]
        return "\(team1.team.abbreviation) \(team1.score) - \(team0.team.abbreviation) \(team0.score)    \(prefix)\(game.status.period) \(game.status.displayClock)"
    case "post":
        let team1 = competitors[1]
        let team0 = competitors[0]
        return "\(team1.team.abbreviation) \(team1.score) - \(team0.team.abbreviation) \(team0.score)    (Final)"
    default:
        return game.shortName
    }
}
