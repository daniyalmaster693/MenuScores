//
//  FavoriteSettings.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import SwiftUI

struct FavoritesSettingsView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @AppStorage("autoPinFavorites") private var autoPinFavorites = false

    @State private var selectedLeague = "nhl"

    var body: some View {
        VStack(spacing: 4) {
            Text("Favorites")
                .font(.title2)
                .bold()

            Form {
                Section {
                    Toggle(isOn: $autoPinFavorites) {
                        HStack {
                            Image(systemName: "pin")
                                .foregroundColor(.primary)
                            Text("Auto-pin favorite team games")
                        }
                    }

                    HStack {
                        Label("Favorite League", systemImage: "sportscourt")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $selectedLeague) {
                            Text("NHL").tag("nhl")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 190)
                        .disabled(!autoPinFavorites)
                    }
                }

                Section("Favorite Teams") {
                    let leagueFavorites = favoritesManager.favorites.filter {
                        $0.leagueKey == selectedLeague
                    }

                    if leagueFavorites.isEmpty {
                        Text("No favorite teams selected.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(leagueFavorites) { favorite in
                            if let team = favoritesManager.availableTeams[selectedLeague]?
                                .first(where: { $0.id == favorite.id })
                            {
                                FavoriteTeamRow(
                                    team: team,
                                    leagueKey: selectedLeague
                                )
                            }
                        }
                    }
                }

                Section("Teams") {
                    if favoritesManager.isLoadingTeams {
                        ProgressView()
                    } else {
                        VStack {
                            ScrollView {
                                ForEach(Array(favoritesManager.availableTeams[selectedLeague] ?? []).indices, id: \.self) { index in
                                    let team = (favoritesManager.availableTeams[selectedLeague] ?? [])[index]

                                    FavoriteTeamRow(
                                        team: team,
                                        leagueKey: selectedLeague
                                    )

                                    if index != (favoritesManager.availableTeams[selectedLeague]?.count ?? 0) - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .frame(height: 230)
                    }
                }
                .task {
                    await favoritesManager.loadTeams(
                        for: selectedLeague,
                        url: FavoriteTeams.teamsURL
                    )
                }
            }
            .formStyle(.grouped)
        }
    }
}

struct FavoriteTeamRow: View {
    let team: TeamInfo
    let leagueKey: String

    @ObservedObject var favorites = FavoritesManager.shared

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: team.primaryLogo ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.clear
            }
            .frame(width: 18, height: 18)

            VStack(alignment: .leading) {
                Text(team.displayName)
            }

            Spacer()

            Button {
                favorites.toggleFavorite(team, leagueKey: leagueKey)
            } label: {
                Image(systemName:
                    favorites.isFavorite(team, leagueKey: leagueKey)
                        ? "star.fill"
                        : "star"
                )
            }
            .padding(.trailing, 15)
            .buttonStyle(.plain)
        }
        .padding(.top, 5)
    }
}
