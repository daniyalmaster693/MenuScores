//
//  MenuScoresApp.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import SwiftUI

class LeagueSelectionModel: ObservableObject {
    @Published var currentLeague: String = "NHL"
}

extension LeagueSelectionModel {
    static let shared = LeagueSelectionModel()
}

@main
struct MenuScoresApp: App {
    @State var currentTitle: String = "Select a Game"
    @State var currentGameID: String = "0"
    @StateObject private var vm = GamesListView()

    var body: some Scene {
        MenuBarExtra {
            Menu("NHL Games") {
                Text(formattedDate(from: vm.games.first?.date ?? "Invalid Date"))
                    .font(.headline)
                Divider()
                    .padding(.bottom)

                if !vm.games.isEmpty {
                    ForEach(Array(vm.games.enumerated()), id: \.1.id) { _, game in
                        Button {
                            currentTitle = displayText(for: game)
                            currentGameID = game.id
                        } label: {
                            AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)

                            Text(displayText(for: game))
                        }
                    }
                } else {
                    Text("Loading games...")
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                LeagueSelectionModel.shared.currentLeague = "NHL"
                Task {
                    await vm.populateGames()
                }
            }

            Divider()

            Button {
                currentTitle = "Select a Game"
                currentGameID = "3"
            } label: {
                Text("Clear Set Game")
            }
            .keyboardShortcut("r")

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
            }
            .keyboardShortcut("q")
        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text(currentTitle)
            }
        }
    }
}
