//
//  Leading.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import SwiftUI

struct CompactLeading: View {
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
                    let team = game.competitions[0].competitors?[1].team
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

                    Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))
                }
                .transition(.opacity)
                .onChange(of: notchViewModel.currentGameID) { _ in
                    newGame = true
                }
                .onChange(of: game.competitions[0].competitors?[1].score) { newScore in
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
                    AsyncImage(
                        url: URL(
                            string:
                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                        )
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
            }
        }

        if sport == "F1" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                    )
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
        }

        if sport == "Racing" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
                    )
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
        }

        if let competition = notchViewModel.tennisCompetition {
            if sport == "Tennis" {
                HStack {
                    AsyncImage(
                        url: URL(string: competition.competitors?.first?.athlete?.flag?.href ?? competition.competitors?.first?.roster?.athletes?.first?.flag?.href ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40")
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

                    Text("\(competition.competitors?.first?.linescores?.last?.value ?? 0)")
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 14, weight: .semibold))
                }
                .transition(.opacity)
                .onChange(of: NotchViewModel.shared.currentGameID) { _ in
                    newGame = true
                }
                .onChange(of: competition.competitors?.first?.linescores?.last?.value) { newScore in
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

        if sport == "Fighting" {
            HStack {
                AsyncImage(
                    url: URL(
                        string:
                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-mma.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                    )
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
        }

//        if let cricketGame = notchViewModel.cricketCompetition {
//            if sport == "Cricket" {
//                let awayScore = cricketGame.competitors[1].score ?? "0"
//                let cricketAwayScore = awayScore.components(separatedBy: " ").first ?? awayScore
//
//                HStack {
//                    AsyncImage(
//                        url: URL(string: cricketGame.competitors[1].logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-cricket.png&h=80&w=80&scale=crop&cquality=40")
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
//
//                    Text("\(cricketAwayScore)")
//                        .contentTransition(.numericText(countsDown: false))
//                        .font(.system(size: 14, weight: .semibold))
//                }
//                .transition(.opacity)
//            }
//        }
    }
}
