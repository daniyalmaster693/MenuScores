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

    // Leagues

    @AppStorage("enableNHL") private var enableNHL = true
    @AppStorage("enableHNCAAM") private var enableHNCAAM = false
    @AppStorage("enableHNCAAF") private var enableHNCAAF = false

    @AppStorage("enableNBA") private var enableNBA = true
    @AppStorage("enableWNBA") private var enableWNBA = false
    @AppStorage("enableNCAAM") private var enableNCAAM = false
    @AppStorage("enableNCAAF") private var enableNCAAF = false

    @AppStorage("enableNFL") private var enableNFL = true
    @AppStorage("enableFNCAA") private var enableFNCAA = false

    @AppStorage("enableMLB") private var enableMLB = true
    @AppStorage("enableBNCAA") private var enableBNCAA = false
    @AppStorage("enableSNCAA") private var enableSNCAA = false

    @AppStorage("enableMLS") private var enableMLS = true
    @AppStorage("enableNWSL") private var enableNWSL = false
    @AppStorage("enableUEFA") private var enableUEFA = false
    @AppStorage("enableEUEFA") private var enableEUEFA = false
    @AppStorage("enableWUEFA") private var enableWUEFA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableWEPL") private var enableWEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false

    @AppStorage("enableNLL") private var enableNLL = false
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false

    @AppStorage("enableVNCAAM") private var enableVNCAAM = false
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false

    @AppStorage("enableOMIHC") private var enableOMIHC = false
    @AppStorage("enableOWIHC") private var enableOWIHC = false
    @AppStorage("enableOMB") private var enableOMB = false
    @AppStorage("enableOWB") private var enableOWB = false

    @AppStorage("enableFFWC") private var enableFFWC = false
    @AppStorage("enableFFWWC") private var enableFFWWC = false
    @AppStorage("enableFFWCQUEFA") private var enableFFWCQUEFA = false
    @AppStorage("enableCONCACAF") private var enableCONCACAF = false
    @AppStorage("enableCONMEBOL") private var enableCONMEBOL = false
    @AppStorage("enableCAF") private var enableCAF = false
    @AppStorage("enableAFC") private var enableAFC = false
    @AppStorage("enableOFC") private var enableOFC = false

    @State private var selectedLeague = "NHL"
    @State private var searchText = ""

    private var filteredTeams: [TeamInfo] {
        let teams = favoritesManager.availableTeams[selectedLeague] ?? []

        if searchText.isEmpty {
            return teams
        }

        return teams.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.abbreviation.localizedCaseInsensitiveContains(searchText)
        }
    }

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
                        Label("Select League", systemImage: "sportscourt")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $selectedLeague) {
                            ForEach(FavoriteTeams.supportedLeagueKeys, id: \.self) { league in
                                Text(FavoriteTeams.displayName(for: league))
                                    .tag(league)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 190)
                        .disabled(!autoPinFavorites)
                    }
                }

                Section("Favorite Teams") {
                    if favoritesManager.favorites.isEmpty {
                        Text("No favorite teams selected.")
                            .foregroundStyle(.primary)
                    } else {
                        ForEach(favoritesManager.favorites) { favorite in
                            HStack {
                                AsyncImage(url: favorite.logo.flatMap { URL(string: $0) }) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.clear
                                }
                                .frame(width: 18, height: 18)

                                VStack(alignment: .leading) {
                                    Text(favorite.displayName)

                                    Text(FavoriteTeams.displayName(for: favorite.leagueKey))
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                }

                                Spacer()

                                Button {
                                    favoritesManager.favorites.removeAll {
                                        $0.id == favorite.id && $0.leagueKey == favorite.leagueKey
                                    }
                                    favoritesManager.saveFavorites()
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                Section("Teams") {
                    TextField("Search teams...", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    if favoritesManager.isLoadingTeams {
                        ProgressView()
                    } else {
                        VStack {
                            ScrollView {
                                ForEach(Array(filteredTeams.indices), id: \.self) { index in
                                    let team = filteredTeams[index]

                                    FavoriteTeamRow(
                                        team: team,
                                        leagueKey: selectedLeague
                                    )

                                    if index != filteredTeams.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }
                        .frame(height: 230)
                    }
                }
                .task(id: selectedLeague) {
                    if let url = FavoriteTeams.teamsUrl(for: selectedLeague) {
                        await favoritesManager.loadTeams(
                            for: selectedLeague,
                            url: url
                        )
                    }
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
            AsyncImage(url: team.primaryLogo.flatMap { URL(string: $0) }) { image in
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
