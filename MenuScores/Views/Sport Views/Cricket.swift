//
//  Cricket.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-09-02.
//

import DynamicNotchKit
import SwiftUI

struct CricketMenu: View {
    let title: String
    @ObservedObject var viewModel: CricketListView
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
            if viewModel.cricketGames.isEmpty {
                Text("No Games Scheduled")
            } else {
                Text(formattedCricketDate(from: viewModel.cricketGames.first?.date ?? "Invalid Date"))
                    .font(.headline)

                Divider().padding(.bottom)

                ForEach(viewModel.cricketGames, id: \.id) { cricketGame in
                    Menu {
                        Button {
                            currentTitle = displayCricketText(for: cricketGame)
                            currentGameID = cricketGame.id
                            currentGameState = cricketGame.fullStatus.type.state

                            pinnedByMenubar = true
                            pinnedByNotch = false
                        } label: {
                            HStack {
                                Image(systemName: "menubar.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Pin Game to Menubar")
                            }
                        }

                        if enableNotch {
                            Button {
                                currentGameID = cricketGame.id
                                currentGameState = cricketGame.fullStatus.type.state

                                pinnedByNotch = true
                                pinnedByMenubar = false

//                                Task {
//                                    await NotchViewModel.shared.pinGame(
//                                        fightCompetition: fight,
//                                        sport: "Fighting",
//                                        league: league,
//                                        gameID: fight.id,
//                                        gameState: fight.status.type.state
//                                    )
//                                }
                            } label: {
                                HStack {
                                    Image(systemName: "macbook")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("Pin Game to Notch")
                                }
                            }
                        }

                        Divider()

                        Button {
                            if let urlString = cricketGame.links?.first?.href, let url = URL(string: urlString) {
                                NSWorkspace.shared.open(url)
                            }

                        } label: {
                            HStack {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("View Game Details")
                            }
                        }
                    } label: {
                        HStack {
                            AsyncImage(
                                url: URL(
                                    string: /* fight.competitors?.first?.athlete?.flag.href ?? */
                                    "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-cricket.png&h=80&w=80&scale=crop&cquality=40"
                                )
                            ) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayCricketText(for: cricketGame))
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
                        cricketViewModel: viewModel,
                        league: league,
                        fetchURL: fetchURL,
                        currentTitle: $currentTitle,
                        currentGameID: $currentGameID,
                        currentGameState: $currentGameState,
                        previousGameState: $previousGameState,
                        type: .cricket,
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
