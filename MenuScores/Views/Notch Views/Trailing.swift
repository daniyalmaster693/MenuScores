//
//  Trailing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactTrailing: View {
    @ObservedObject var notchViewModel: NotchViewModel

    @State private var newGame: Bool = false

    var sport: String {
        notchViewModel.sport
    }

    var league: String {
        notchViewModel.league
    }

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "F1" && sport != "Racing" && sport != "Golf" {
                HStack {
                    Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))

                    let team = game.competitions[0].competitors?[0].team
                    let logoURL = darkLogoURL(from: team?.logo, teamID: team?.id, league: league) ?? (
                        sport == "volleyball"
                            ?"https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                            : "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport.lowercased()).png&h=80&w=80&scale=crop&cquality=40"
                    )

                    AsyncImage(url: URL(string: logoURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .interpolation(.high)
                                .scaledToFit()
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        } else {
                            Color.clear
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .transition(.opacity)
                .onChange(of: notchViewModel.currentGameID) { _ in
                    newGame = true
                }
                .onChange(of: game.competitions[0].competitors?[0].score) { newScore in
                    guard newScore != nil else { return }
                    guard sport != "Basketball" else { return }

                    if newGame {
                        newGame = false
                        return
                    }

                    notchViewModel.triggerAlert()
                }
            }

            if sport == "Golf" {
                HStack {
                    if let round = game.competitions[0].status.period {
                        Text("R\(round)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("R -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .transition(.opacity)
            }
        }

        if let race = notchViewModel.racingCompetition {
            if sport == "F1" {
                HStack {
                    if race.fullStatus.type.state == "in" || race.fullStatus.type.state == "post" {
                        let firstName = race.competitors?.first?.firstName ?? ""
                        let lastName = race.competitors?.first?.lastName ?? ""

                        Text("\(firstName.prefix(1)).\(lastName.prefix(1))")
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        let raceType = race.competitionType?.abbreviation ?? ""

                        Text("\(raceType)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .transition(.opacity)
            }

            if sport == "Racing" {
                HStack {
                    if let lap = race.fullStatus.period {
                        Text("L\(lap)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("L -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .transition(.opacity)
            }
        }

        if let competition = notchViewModel.tennisCompetition {
            if sport == "Tennis" {
                HStack {
                    Text("\(competition.competitors?.dropFirst().first?.linescores?.last?.value ?? 0)")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))

                    AsyncImage(
                        url: URL(string: competition.competitors?.dropFirst().first?.athlete?.flag?.href ?? competition.competitors?.dropFirst().first?.roster?.athletes?.first?.flag?.href ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40")
                    ) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .interpolation(.high)
                                .scaledToFit()
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        } else {
                            Color.clear
                                .transition(.opacity)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .transition(.opacity)
                .onChange(of: NotchViewModel.shared.currentGameID) { _ in
                    newGame = true
                }
                .onChange(of: competition.competitors?.dropFirst().first?.linescores?.last?.value) { newScore in
                    guard newScore != nil else { return }
                    guard sport != "Basketball" else { return }

                    if newGame {
                        newGame = false
                        return
                    }

                    NotchViewModel.shared.triggerAlert()
                }
            }
        }

        if let fight = notchViewModel.fightCompetition {
            if sport == "Fighting" {
                HStack {
                    if let round = fight.status.period {
                        Text("R\(round)")
                            .contentTransition(.numericText(countsDown: false))
                            .font(.system(size: 14, weight: .semibold))
                    } else {
                        Text("R -")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .transition(.opacity)
            }
        }

//        if let cricketGame = notchViewModel.cricketCompetition {
//            if sport == "Cricket" {
//                HStack {
//                    let homeScore = cricketGame.competitors[0].score ?? "0"
//                    let cricketHomeScore = homeScore.components(separatedBy: " ").first ?? homeScore
//
//                    Text("\(cricketHomeScore)")
//                        .contentTransition(.numericText(countsDown: false))
//                        .font(.system(size: 14, weight: .semibold))
//
//                    AsyncImage(
//                        url: URL(string: cricketGame.competitors[0].logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-cricket.png&h=80&w=80&scale=crop&cquality=40")
//                    ) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .interpolation(.high)
//                                .scaledToFit()
//                                .transition(.opacity)
//                                .frame(width: 18, height: 18)
//                        } else {
//                            Color.clear
//                                .transition(.opacity)
//                                .frame(width: 18, height: 18)
//                        }
//                    }
//                }
//                .transition(.opacity)
//            }
//        }
    }
}
