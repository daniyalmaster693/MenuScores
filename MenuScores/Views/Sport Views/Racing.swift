//
//  Racing.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-22.
//

import DynamicNotchKit
import SwiftUI

struct RacingMenu: View {
    let title: String
    @ObservedObject var viewModel: RacingListView
    let league: String
    let fetchURL: () -> URL

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
            Text(formattedRaceDate(from: viewModel.races.first?.date ?? "Invalid Date"))
                .font(.headline)
            Divider().padding(.bottom)

            if !viewModel.races.isEmpty {
                ForEach(Array(viewModel.races.enumerated()), id: \.1.id) { _, race in
                    Menu {
                        Button {
                            currentTitle = displayRacingText(for: race)
                            currentGameID = race.id
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
                                currentGameID = race.id
                                currentGameState = race.fullStatus.type.state

                                pinnedByNotch = true
                                pinnedByMenubar = false

                                Task {
                                    await NotchViewModel.shared.pinGame(
                                        racingCompetition: race,
                                        sport: "Racing",
                                        league: league,
                                        gameID: race.id,
                                        gameState: race.fullStatus.type.state
                                    )
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

                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(
                                    string:
                                    "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
                                )
                            ) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayRacingText(for: race))
                        }
                    }
                }
            } else {
                Text("Loading games...")
                    .foregroundColor(.gray)
                    .padding()
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
                        notchViewModel: NotchViewModel.shared
                    )
                }
            }
        }
        .onDisappear {
            RefreshManager.shared.unregisterRefreshAction(for: league)
        }
    }
}
