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

func displayFightingText(for fight: FightEvent) -> String {
    let fightState = fight.fullStatus.type.state

    switch fightState {
    case "pre":
        return "\(fight.shortName) - \(formattedFightTime(from: fight.date))"

//    case "in":
//        return
//            "\(driverName)     L\(lap)"
//
//    case "post":
//        return
//            "\(driverName)     (Final)"

    default:
        return fight.shortName
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

    let status = competition.status?.type.state ?? "pre"
    let set = competition.status?.period ?? 0

    let statusSuffix: String = {
        switch status {
        case "in":
            return "S\(set)"
        case "post":
            return "(Final)"
        default:
            return ""
        }
    }()

    return "\(team1)  \(team1Scores) - \(team2Scores)  \(team2)     \(statusSuffix)"
}
