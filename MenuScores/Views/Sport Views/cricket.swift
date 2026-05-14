//
//  Cricket.swift
//  MenuScores
//

import DynamicNotchKit
import SwiftUI

struct CricketMenu: View {
    let title: String
    @ObservedObject var viewModel: CricketScheduleListView
    let league: String
    let seriesFilter: String?

    @State private var pinnedByNotch = false
    @State private var pinnedByMenubar = false
    @State private var pinnedMatchId: String? = nil

    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"

    private var refreshInterval: TimeInterval {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
        }
    }

    private func matchMenuTitle(_ match: CricAPIMatch) -> String {
        "\(match.team1Short) vs \(match.team2Short) — \(match.name) • \(match.startDateFormatted)"
    }

    private func pinToMenubar(_ match: CricAPIMatch) {
        currentTitle = "\(match.team1Short) vs \(match.team2Short)"
        currentGameID = match.id
        currentGameState = "pre"
        pinnedMatchId = match.id
        pinnedByMenubar = true
        pinnedByNotch = false
    }

    private func pinToNotch(_ match: CricAPIMatch) {
        currentGameID = match.id
        currentGameState = "pre"
        pinnedMatchId = match.id
        pinnedByNotch = true
        pinnedByMenubar = false

        Task {
            if let existingNotch = NotchViewModel.shared.notch {
                await existingNotch.hide()
                NotchViewModel.shared.notch = nil
            }

            NotchViewModel.shared.game = nil
            NotchViewModel.shared.tennisCompetition = nil
            NotchViewModel.shared.cricketMatch = match

            let newNotch = DynamicNotch(hoverBehavior: .all, style: .notch) {
                Info(notchViewModel: NotchViewModel.shared, sport: "Cricket", league: league)
            } compactLeading: {
                CompactLeading(notchViewModel: NotchViewModel.shared, sport: "Cricket")
            } compactTrailing: {
                CompactTrailing(notchViewModel: NotchViewModel.shared, sport: "Cricket")
            }

            NotchViewModel.shared.notch = newNotch
            await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
        }
    }

    var body: some View {
        Menu(title) {
            if viewModel.matches.isEmpty {
                Text("No Games Scheduled")
            } else {
                ForEach(viewModel.matches) { match in
                    Menu {
                        Button {
                            pinToMenubar(match)
                        } label: {
                            HStack {
                                Image(systemName: "menubar.rectangle")
                                    .resizable().scaledToFit().frame(width: 20, height: 20)
                                Text("Pin Game to Menubar")
                            }
                        }

                        if enableNotch {
                            Button {
                                pinToNotch(match)
                            } label: {
                                HStack {
                                    Image(systemName: "macbook")
                                        .resizable().scaledToFit().frame(width: 20, height: 20)
                                    Text("Pin Game to Notch")
                                }
                            }
                        }
                    } label: {
                        Text(matchMenuTitle(match))
                    }
                }
            }
        }
        .onReceive(
            Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()
        ) { _ in
            Task {
                guard let matchId = pinnedMatchId else { return }
                if let fresh = await viewModel.refreshMatch(id: matchId) {
                    if pinnedByNotch {
                        NotchViewModel.shared.cricketMatch = fresh
                    }
                    if pinnedByMenubar && fresh.isLive {
                        currentTitle = "\(fresh.team1Short) \(fresh.score1Text) — \(fresh.team2Short) \(fresh.score2Text)"
                    }
                }
            }
        }
    }
}
