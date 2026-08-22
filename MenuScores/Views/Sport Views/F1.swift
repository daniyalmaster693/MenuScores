//
//  F1.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-03.
//

import DynamicNotchKit
import SwiftUI

struct F1Menu: View {
    let title: String
    @ObservedObject var viewModel: RacingListView
    let league: String
    let fetchURL: () -> URL

    @StateObject private var notchViewModel = NotchViewModel()

    @State private var pinnedByNotch = false
    @State private var pinnedByMenubar = false

    @Binding var currentTitle: String
    @Binding var currentGameID: String
    @Binding var currentGameState: String
    @Binding var previousGameState: String?

    @AppStorage("enableNotch") private var enableNotch = true
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    @AppStorage("refreshInterval") private var selectedOption = "15 seconds"
    @AppStorage("notiGameStart") private var notiGameStart = false
    @AppStorage("notiGameComplete") private var notiGameComplete = false

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

    var body: some View {
        Menu(title) {
            let groupedByRace = Dictionary(grouping: viewModel.races) { race in
                race.shortName
            }

            let sortedRaces = groupedByRace.keys.sorted()

            if sortedRaces.isEmpty {
                Text("No Races Scheduled")
            } else {
                ForEach(sortedRaces, id: \.self) { raceName in
                    if let raceEvents = groupedByRace[raceName] {
                        Menu {
                            let groupedByDate = Dictionary(grouping: raceEvents) { race in
                                formattedRaceDate(from: race.date)
                            }

                            let sortedDates = groupedByDate.keys.sorted()

                            ForEach(sortedDates, id: \.self) { date in
                                if let racesForDate = groupedByDate[date] {
                                    Menu(date) {
                                        ForEach(racesForDate, id: \.competitionId) { race in
                                            Menu {
                                                Button {
                                                    currentTitle = displayF1Text(for: race)
                                                    currentGameID = race.competitionId
                                                    currentGameState = race.fullStatus.type.state

                                                    pinnedByMenubar = true
                                                    pinnedByNotch = false
                                                } label: {
                                                    HStack {
                                                        Image(systemName: "menubar.rectangle")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                        Text("Pin Race to Menubar")
                                                    }
                                                }

                                                if enableNotch {
                                                    Button {
                                                        currentGameID = race.competitionId
                                                        currentGameState = race.fullStatus.type.state

                                                        pinnedByNotch = true
                                                        pinnedByMenubar = false

                                                        notchViewModel.racingCompetition = race

                                                        Task {
                                                            if let existingNotch = NotchViewModel.shared.notch {
                                                                await existingNotch.hide()
                                                                NotchViewModel.shared.notch = nil

                                                                NotchViewModel.shared.game = nil
                                                                NotchViewModel.shared.racingCompetition = nil
                                                                NotchViewModel.shared.fightCompetition = nil
                                                                NotchViewModel.shared.tennisCompetition = nil

                                                                NotchViewModel.shared.currentGameID = ""
                                                                NotchViewModel.shared.currentGameState = ""
                                                                NotchViewModel.shared.previousGameState = ""
                                                            }

                                                            let newNotch = DynamicNotch(
                                                                hoverBehavior: .all,
                                                                style: .notch
                                                            ) {
                                                                Info(notchViewModel: notchViewModel, sport: "F1", league: "\(league)")
                                                            } compactLeading: {
                                                                CompactLeading(notchViewModel: notchViewModel, sport: "F1")
                                                            } compactTrailing: {
                                                                CompactTrailing(notchViewModel: notchViewModel, sport: "F1")
                                                            }

                                                            NotchViewModel.shared.notch = newNotch
                                                            await newNotch.compact(on: NSScreen.screens[notchScreenIndex])
                                                        }
                                                    } label: {
                                                        HStack {
                                                            Image(systemName: "macbook")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 20, height: 20)
                                                            Text("Pin Race to Notch")
                                                        }
                                                    }
                                                }

                                                Divider()

                                                Button {
                                                    if let urlString = race.links.first?.href, let url = URL(string: urlString) {
                                                        NSWorkspace.shared.open(url)
                                                    }
                                                } label: {
                                                    HStack {
                                                        Image(systemName: "info.circle")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                        Text("View Race Details")
                                                    }
                                                }
                                            } label: {
                                                HStack {
                                                    AsyncImage(
                                                        url: URL(
                                                            string:
                                                            "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                                                        )
                                                    ) { image in
                                                        image.resizable().scaledToFit()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 40, height: 40)

                                                    Text(displayF1Text(for: race))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string: "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 20, height: 20)

                                Text(raceName)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            RefreshManager.shared.registerRefreshAction(
                for: league,
                currentGameID: $currentGameID,
                currentGameState: $currentGameState,
                currentTitle: $currentTitle
            ) {
                Task {
                    await RefreshManager.shared.performRefresh(
                        racingViewModel: viewModel,
                        league: league,
                        fetchURL: fetchURL,
                        currentTitle: $currentTitle,
                        currentGameID: $currentGameID,
                        currentGameState: $currentGameState,
                        previousGameState: $previousGameState,
                        type: .racing,
                        pinnedByMenubar: $pinnedByMenubar,
                        pinnedByNotch: $pinnedByNotch,
                        notchViewModel: notchViewModel
                    )
                }
            }
        }
        .onDisappear {
            RefreshManager.shared.unregisterRefreshAction(for: league)
        }
    }
}
