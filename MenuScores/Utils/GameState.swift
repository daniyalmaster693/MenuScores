//
//  GameState.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-10.
//

func displayText(for game: Event, league: String, hasFavoriteTeam: Bool = false) -> String {
    guard let competition = game.competitions.first,
          let competitors = competition.competitors,
          competitors.count >= 2
    else {
        return game.shortName ?? game.name
    }
    
    let awayAbbr = competitors[1].team?.abbreviation ?? "-"
    let homeAbbr = competitors[0].team?.abbreviation ?? "-"
    let awayScore = competitors[1].score
    let homeScore = competitors[0].score
    
    let state = game.status.type.state
    let displayClock = game.status.displayClock
    let period = game.status.period
    let prefix = periodPrefix(for: league)
    let clockText = displayClock ?? "-"
    let periodText = period.map { "\(prefix)\($0)" } ?? "-"
    
    let starPrefix = hasFavoriteTeam ? "⭐ " : ""
    var gameStateText = "\(starPrefix)\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")"
    var preGameText = "\(starPrefix)\(game.shortName ?? game.name) - \(formattedTime(from: game.date))"
    var inGameText = "    \(periodText) \(clockText)"
    let postGameText = "     (Final)"
    
    switch league.uppercased() {
    case "F1":
        let driverName: String
        if game.competitions.count > 4,
           let f1Competitors = game.competitions[4].competitors,
           !f1Competitors.isEmpty
        {
            driverName = f1Competitors.first(where: { $0.order == 1 })?.athlete?.displayName ?? "-"
        } else {
            driverName = "-"
        }

        var f1Period: Int?
        var f1State = "-"

        if game.competitions.count > 4 {
            f1Period = game.competitions[4].status.period
            f1State = game.competitions[4].status.type.state
        }
        let f1PeriodText = f1Period.map { "\(prefix)\($0)" } ?? "-"
        
        gameStateText = driverName
        preGameText = "\(game.shortName ?? game.name) - \(formattedTime(from: game.endDate ?? game.date))"
        inGameText = "     \(f1PeriodText)"
        break
    case "NC","NCS","NCT","IRL":
        gameStateText = game.competitions[0].competitors?.first(where: { $0.order == 1 })?.athlete?.displayName ?? "-"
        inGameText = periodText
        break
    case "PGA", "LPGA":
        let golferName = game.competitions[0].competitors?.first(where: { $0.order == 1 })?.athlete?.displayName ?? "-"
        let golferScore = game.competitions[0].competitors?.first?.score ?? "-"
        let golfRound = game.competitions[0].status.period
        let golfRoundText = golfRound.map { "\(prefix)\($0)" } ?? "-"
        gameStateText = "\(golferName) \(golferScore)"
        inGameText = "    \(golfRoundText)"
        break
    default:
        break
    }
        
    switch state {
    case "pre":
        return preGameText
    case "in":
        return "\(gameStateText) \(inGameText)"
    case "post":
        return "\(gameStateText) \(postGameText)"
    default:
        return game.shortName ?? game.name
    }
}
