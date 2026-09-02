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
        return game.shortName ?? game.name
    }

    let awayAbbr = competitors[1].team?.abbreviation ?? "-"
    let homeAbbr = competitors[0].team?.abbreviation ?? "-"
    let awayScore = competitors[1].score
    let homeScore = competitors[0].score

    let state = game.status.type.state
    let shortDetail = game.status.type.shortDetail ?? "-"
    let displayClock = game.status.displayClock
    let period = game.status.period
    let prefix = periodPrefix(for: league)
    let clockText = displayClock ?? "-"
    let periodText = period.map { "\(prefix)\($0)" } ?? "-"

    if league == "MLB" || league == "UEFA" || league == "EPL", state == "in" {
        let detailText = shortDetail
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    \(detailText)"
    }

    // PGA Game States

    let golferName =
        game.competitions[0].competitors?.first(where: { $0.order == 1 })?.athlete?.displayName ?? "-"
    let golferScore = game.competitions[0].competitors?.first?.score ?? "-"
    let golfRound = game.competitions[0].status.period
    let golfRoundText = golfRound.map { "\(prefix)\($0)" } ?? "-"

    if league == "PGA" || league == "LPGA", state == "in" {
        return "\(golferName) \(golferScore)    \(golfRoundText)"
    }

    if league == "PGA" || league == "LPGA", state == "post" {
        return "\(golferName)     (Final)"
    }

    // Normal State

    switch state {
    case "pre":
        return "\(game.shortName ?? game.name) - \(formattedTime(from: game.date))"

    case "in":
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    \(periodText) \(clockText)"

    case "post":
        return
            "\(awayAbbr) \(awayScore ?? "-") - \(homeAbbr) \(homeScore ?? "-")    (Final)"

    default:
        return game.shortName ?? game.name
    }
}

func displayF1Text(for race: RaceEvent) -> String {
    let f1State = race.fullStatus.type.state
    let driverName = race.competitors?.first?.shortName ?? "Driver"
    let lap = race.fullStatus.period ?? 0

    switch f1State {
    case "pre":
        return "\(race.competitionType?.text ?? "Race") - \(formattedRaceTime(from: race.date))"

    case "in":
        return
            "\(driverName)     L\(lap)"

    case "post":
        return
            "\(driverName)     (Final)"

    default:
        return race.shortName
    }
}

func displayRacingText(for race: RaceEvent) -> String {
    let raceState = race.fullStatus.type.state
    let driverName = race.competitors?.first?.shortName ?? "Driver"
    let lap = race.fullStatus.period ?? 0

    switch raceState {
    case "pre":
        return "\(race.shortName) - \(formattedRaceTime(from: race.date))"

    case "in":
        return
            "\(driverName)     L\(lap)"

    case "post":
        return
            "\(driverName)     (Final)"

    default:
        return race.shortName
    }
}

func displayFightingText(for fight: FightCompetitions) -> String {
    let time = formattedTime(from: fight.date)
    let fightState = fight.status.type.state

    let round = fight.status.period ?? 0
    let displayClock = fight.status.displayClock ?? "-"

    let competitor1 = fight.competitors?.first?.athlete?.shortName ?? "Competitor 1"
    let competitor2 = fight.competitors?.dropFirst().first?.athlete?.shortName ?? "Competitor 2"

    let winner = fight.competitors?.first(where: { $0.winner == true })?.athlete?.shortName ?? "Unknown"

    switch fightState {
    case "pre":
        return "\(competitor1) - \(competitor2) @ \(time)"

    case "in":
        return
            "\(competitor1) - \(competitor2)     R\(round) \(displayClock)"

    case "post":
        return
            "\(competitor1) - \(competitor2)     (W: \(winner))"

    default:
        return "\(competitor1) - \(competitor2)"
    }
}

func displayTennisText(for competition: TennisCompetition) -> String {
    let team1 = competition.competitors?.first?.athlete?.shortName
        ?? competition.competitors?.first?.athlete?.displayName ?? competition.competitors?.first?.roster?.athletes?.first?.shortName ?? competition.competitors?.first?.roster?.athletes?.first?.displayName
        ?? "Player 1"

    let team2 = competition.competitors?.dropFirst().first?.athlete?.shortName
        ?? competition.competitors?.dropFirst().first?.athlete?.displayName ?? competition.competitors?.dropFirst().first?.roster?.athletes?.first?.shortName ?? competition.competitors?.dropFirst().first?.roster?.athletes?.first?.displayName
        ?? "Player 2"

    let team1Scores = competition.competitors?.first?.linescores?
        .map { "\($0.value ?? 0)" }
        .joined(separator: " ") ?? ""

    let team2Scores = competition.competitors?.dropFirst().first?.linescores?
        .map { "\($0.value ?? 0)" }
        .joined(separator: " ") ?? ""

    let time = formattedTime(from: competition.date)

    let status = competition.status?.type.state ?? "pre"
    let set = competition.status?.period ?? 0

    let statusSuffix: String = {
        switch status {
        case "pre":
            return "@ \(time)"
        case "in":
            return "    S\(set)"
        case "post":
            return "    (Final)"
        default:
            return ""
        }
    }()

    return "\(team1)  \(team1Scores) - \(team2Scores)  \(team2) \(statusSuffix)"
}

// func displayCricketText(for cricketGame: CricketEvent) -> String {
//    let cricketState = cricketGame.fullStatus.type.state
//
//    let cricketShortName = cricketGame.shortName
//        .replacingOccurrences(of: " v ", with: " vs ")
//        .replacingOccurrences(of: " V ", with: " vs ")
//
//    let awayAbbr = cricketGame.competitors[1].abbreviation
//    let homeAbbr = cricketGame.competitors[0].abbreviation
//
//    let awayScore = cricketGame.competitors[1].score ?? "0"
//    let cricketAwayScore = awayScore.components(separatedBy: " ").first ?? awayScore
//
//    let homeScore = cricketGame.competitors[0].score ?? "0"
//    let cricketHomeScore = homeScore.components(separatedBy: " ").first ?? homeScore
//
//    let periodText = cricketGame.fullStatus.period ?? 0
//    let clockText = cricketGame.fullStatus.displayClock ?? "-"
//
//    switch cricketState {
//    case "pre":
//        return "\(cricketShortName) - \(formattedCricketTime(from: cricketGame.date))"
//
//    case "in":
//        return
//            "\(awayAbbr) \(cricketAwayScore) - \(homeAbbr) \(cricketHomeScore)    I\(periodText) \(clockText)"
//
//    case "post":
//        return
//            "\(awayAbbr) \(cricketAwayScore) - \(homeAbbr) \(cricketHomeScore)     (Final)"
//
//    default:
//        return cricketGame.shortName
//    }
// }
