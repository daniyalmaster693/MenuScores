//
//  Fighting.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-11-22.
//

import DynamicNotchKit
import SwiftUI

struct FightingMenu: View {
    let title: String
    @ObservedObject var viewModel: FightingListView
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
            let groupedByFight = Dictionary(grouping: viewModel.fights) { fight in
                fight.shortName
            }

            let sortedFights = groupedByFight.keys.sorted()

            if sortedFights.isEmpty {
                Text("No Fights Scheduled")
            } else {
                ForEach(sortedFights, id: \.self) { fightName in
                    if let fightEvents = groupedByFight[fightName] {
                        Menu {
                            Text(formattedFightDate(from: viewModel.fights.first?.date ?? "Invalid Date"))
                                .font(.headline)

                            Divider().padding(.bottom)

                            ForEach(fightEvents, id: \.competitionId) { fight in
                                Menu {
                                    Button {
                                        currentTitle = displayFightingText(for: fight)
                                        currentGameID = fight.competitionId
                                        currentGameState = fight.fullStatus.type.state

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
                                            currentGameID = fight.competitionId
                                            currentGameState = fight.fullStatus.type.state

                                            pinnedByNotch = true
                                            pinnedByMenubar = false

//                                                        notchViewModel.racingCompetition = race

                                            Task {
                                                if let existingNotch = NotchViewModel.shared.notch {
                                                    await existingNotch.hide()
                                                    NotchViewModel.shared.game = nil
                                                    NotchViewModel.shared.currentGameID = ""
                                                    NotchViewModel.shared.currentGameState = ""
                                                    NotchViewModel.shared.previousGameState = ""
                                                    NotchViewModel.shared.notch = nil
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

                                        Divider()
                                    }
                                } label: {
                                    HStack {
                                        AsyncImage(
                                            url: URL(
                                                string:
                                                "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-mma.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                            )
                                        ) { image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)

                                        Text(displayFightingText(for: fight))
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string: "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-mma.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 20, height: 20)

                                Text(fightName)
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
                        fightingViewModel: viewModel,
                        league: league,
                        fetchURL: fetchURL,
                        currentTitle: $currentTitle,
                        currentGameID: $currentGameID,
                        currentGameState: $currentGameState,
                        previousGameState: $previousGameState,
                        type: .fighting,
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
