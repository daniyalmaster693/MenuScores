//
//  GameState.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-10.
//

func displayText(for game: Event, league: String) -> String {
    guard let competition = game.competitions.first,
          let competitors = competition.competitors,
          competitors.count >= 2
    else {
        return game.shortName
    }

    let awayAbbr = competitors[1].team?.abbreviation ?? ""
    let homeAbbr = competitors[0].team?.abbreviation ?? ""
    let awayScore = competitors[1].score
    let homeScore = competitors[0].score

    let state = game.status.type.state
    let shortDetail = game.status.type.shortDetail ?? ""
    let displayClock = game.status.displayClock
    let period = game.status.period
    let prefix = periodPrefix(for: league)
    let clockText = displayClock ?? ""
    let periodText = period.map { "\(prefix)\($0)" } ?? ""

    if league == "MLB" || league == "UEFA" || league == "EPL", state == "in" {
        let detailText = shortDetail
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    \(detailText)"
    }

    // F1 Race States

    let driverName: String
    if game.competitions.count > 4,
       let f1Competitors = game.competitions[4].competitors,
       !f1Competitors.isEmpty
    {
        driverName = f1Competitors[0].athlete?.displayName ?? "Unknown"
    } else {
        driverName = "Unknown"
    }

    var f1Period: Int?
    var f1State = ""

    if game.competitions.count > 4 {
        f1Period = game.competitions[4].status.period
        f1State = game.competitions[4].status.type.state
    }
    let f1PeriodText = f1Period.map { "\(prefix)\($0)" } ?? ""

    if league == "F1", f1State == "pre" {
        return
            "\(game.shortName) - \(formattedTime(from: game.endDate ?? game.date))"
    }

    if league == "F1", f1State == "in" {
        return "\(driverName)     \(f1PeriodText)"
    }

    if league == "F1", f1State == "post" {
        return "\(driverName)     (Final)"
    }

    // Other Racing Game States

    let leaderName = game.competitions[0].competitors?.first?.athlete?.displayName ?? "Unknown"

    if league == "NC" || league == "NCS" || league == "NCT" || league == "IRL", state == "in" {
        return "\(leaderName) - \(periodText)"
    }

    if league == "NC" || league == "NCS" || league == "NCT" || league == "IRL", state == "post" {
        return "\(leaderName)     (Final)"
    }

    // PGA Game States

    let golferName =
        game.competitions[0].competitors?.first?.athlete?.displayName ?? ""
    let golferScore = game.competitions[0].competitors?.first?.score ?? ""
    let golfRound = game.competitions[0].status.period
    let golfRoundText = golfRound.map { "\(prefix)\($0)" } ?? ""

    if league == "PGA" || league == "LPGA", state == "in" {
        return "\(golferName) \(golferScore)    \(golfRoundText)"
    }

    if league == "PGA" || league == "LPGA", state == "post" {
        return "\(golferName)     (Final)"
    }

    // Normal State

    switch state {
    case "pre":
        return "\(game.shortName) - \(formattedTime(from: game.date))"

    case "in":
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    \(periodText) \(clockText)"

    case "post":
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    (Final)"

    default:
        return game.shortName
    }
}
