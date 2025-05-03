//
//  MenuScoresApp.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import SwiftUI

@main
struct MenuScoresApp: App {
    @State var currentTitle: String = "Select a Game"
    @State var currentGameID: String = "0"
    @StateObject private var vm = GamesListView()

    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        MenuBarExtra {
            
            Menu("NHL Games") {
                            Text(formattedDate(from: vm.games.first?.date ?? "Invalid Date"))
                                .font(.headline)
                            
                            Divider()
                                .padding(.bottom)

                            if !vm.games.isEmpty {
                                ForEach(Array(vm.games.enumerated()), id: \.1.id) { _, game in
                                    Button {
                                        if let competition = game.competitions.first {
                                            let competitors = competition.competitors
                                            
                                            if game.status.type.state == "pre" {
                                                currentTitle = "\(game.shortName) - \(formattedTime(from: game.date))"
                                            } else if game.status.type.state == "in" {
                                                currentTitle = "\(competitors[1].team.abbreviation) \(competitors[1].score) - \(competitors[0].team.abbreviation) \(competitors[0].score)    P\(game.status.period) \(game.status.displayClock)"
                                            } else if game.status.type.state == "post" {
                                                currentTitle = "\(competitors[1].team.abbreviation) \(competitors[1].score) - \(competitors[0].team.abbreviation) \(competitors[0].score)"
                                            }
                                        }
                                        
                                        currentGameID = game.id
                                    } label: {
                                        AsyncImage(url: URL(string: game.competitions[0].competitors[1].team.logo)) { image in
                                            image.resizable()
                                                .scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                        
                                        Text("\(game.shortName) - \(formattedTime(from: game.date))")
                                    }
                                }
                            } else {
                                Text("Loading games...")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onAppear {
                            Task {
                                await vm.populateGames()
                            }
                        }
            
            Menu("NBA Games") {
                // Button 1
                
                Button {
                    currentTitle = "Game 1"
                    currentGameID = "1"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 1")}
                .keyboardShortcut("1")
                
                // Button 2
                
                Button {
                    currentTitle = "Game 2"
                    currentGameID = "2"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 2")}
                .keyboardShortcut("2")
                
                // Button 3
                
                Button {
                    currentTitle = "Game 3"
                    currentGameID = "3"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 3")}
                .keyboardShortcut("3")
                }
            
            Menu("NFL Games") {
                // Button 1
                
                Button {
                    currentTitle = "Game 1"
                    currentGameID = "1"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 1")}
                .keyboardShortcut("1")
                
                // Button 2
                
                Button {
                    currentTitle = "Game 2"
                    currentGameID = "2"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 2")}
                .keyboardShortcut("2")
                
                // Button 3
                
                Button {
                    currentTitle = "Game 3"
                    currentGameID = "3"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 3")}
                .keyboardShortcut("3")
                }
            
            Menu("MLB Games") {
                // Button 1
                
                Button {
                    currentTitle = "Game 1"
                    currentGameID = "1"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 1")}
                .keyboardShortcut("1")
                
                // Button 2
                
                Button {
                    currentTitle = "Game 2"
                    currentGameID = "2"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 2")}
                .keyboardShortcut("2")
                
                // Button 3
                
                Button {
                    currentTitle = "Game 3"
                    currentGameID = "3"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 3")}
                .keyboardShortcut("3")
                }
            
            Menu("F1 Races") {
                // Button 1
                
                Button {
                    currentTitle = "Game 1"
                    currentGameID = "1"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 1")}
                .keyboardShortcut("1")
                
                // Button 2
                
                Button {
                    currentTitle = "Game 2"
                    currentGameID = "2"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 2")}
                .keyboardShortcut("2")
                
                // Button 3
                
                Button {
                    currentTitle = "Game 3"
                    currentGameID = "3"
                } label: {
                    Image (systemName: "sparkles")
                    Text ("Game 3")}
                .keyboardShortcut("3")
                }

                Divider()
    
            // Clear Game
            
            Button {
                currentTitle = "Select a Game"
                currentGameID = "3"
            } label: {
                Text ("Clear Set Game")}
            .keyboardShortcut("r")
            
            // Quit App
            
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text ("Quit")}
            .keyboardShortcut("q")

        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                Text(currentTitle)
            }
        }
    }
}
