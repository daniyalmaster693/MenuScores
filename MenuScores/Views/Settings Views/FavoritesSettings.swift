//
//  FavoritesSettings.swift
//  MenuScores
//
//

import SwiftUI

struct FavoritesSettingsView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared

    @AppStorage("notifyFavoriteGameStart") private var notifyFavoriteGameStart = true
    @AppStorage("notifyFavoriteGameEnd") private var notifyFavoriteGameEnd = true
    @AppStorage("autoPinFavorites") private var autoPinFavorites = true

    // League enable states
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
    @AppStorage("enableEPL") private var enableEPL = false
    @AppStorage("enableWEPL") private var enableWEPL = false
    @AppStorage("enableESP") private var enableESP = false
    @AppStorage("enableGER") private var enableGER = false
    @AppStorage("enableITA") private var enableITA = false
    @AppStorage("enableMEX") private var enableMEX = false
    @AppStorage("enableFRA") private var enableFRA = false
    @AppStorage("enableNED") private var enableNED = false
    @AppStorage("enablePOR") private var enablePOR = false
    @AppStorage("enableNLL") private var enableNLL = true
    @AppStorage("enablePLL") private var enablePLL = false
    @AppStorage("enableLNCAAM") private var enableLNCAAM = false
    @AppStorage("enableLNCAAF") private var enableLNCAAF = false
    @AppStorage("enableVNCAAM") private var enableVNCAAM = true
    @AppStorage("enableVNCAAF") private var enableVNCAAF = false
    @AppStorage("enableOMIHC") private var enableOMIHC = true
    @AppStorage("enableOWIHC") private var enableOWIHC = false

    @State private var selectedLeague: String?
    @State private var searchText = ""

    private var enabledLeagues: [(key: String, name: String)] {
        var leagues: [(key: String, name: String)] = []

        // Hockey
        if enableNHL { leagues.append(("NHL", "NHL")) }
        if enableHNCAAM { leagues.append(("HNCAAM", "NCAA M Hockey")) }
        if enableHNCAAF { leagues.append(("HNCAAF", "NCAA F Hockey")) }
        if enableOMIHC { leagues.append(("OMIHC", "Men's Olympic Hockey")) }
        if enableOWIHC { leagues.append(("OWIHC", "Women's Olympic Hockey")) }

        // Basketball
        if enableNBA { leagues.append(("NBA", "NBA")) }
        if enableWNBA { leagues.append(("WNBA", "WNBA")) }
        if enableNCAAM { leagues.append(("NCAA M", "NCAA M Basketball")) }
        if enableNCAAF { leagues.append(("NCAA F", "NCAA F Basketball")) }

        // Football
        if enableNFL { leagues.append(("NFL", "NFL")) }
        if enableFNCAA { leagues.append(("FNCAA", "NCAA Football")) }

        // Baseball
        if enableMLB { leagues.append(("MLB", "MLB")) }
        if enableBNCAA { leagues.append(("BNCAA", "NCAA Baseball")) }
        if enableSNCAA { leagues.append(("SNCAA", "NCAA Softball")) }

        // Soccer
        if enableMLS { leagues.append(("MLS", "MLS")) }
        if enableNWSL { leagues.append(("NWSL", "NWSL")) }
        if enableUEFA { leagues.append(("UEFA", "Champions League")) }
        if enableEUEFA { leagues.append(("EUEFA", "Europa League")) }
        if enableWUEFA { leagues.append(("WUEFA", "Women's Champions League")) }
        if enableEPL { leagues.append(("EPL", "Premier League")) }
        if enableWEPL { leagues.append(("wepl", "Women's Super League")) }
        if enableESP { leagues.append(("ESP", "La Liga")) }
        if enableGER { leagues.append(("GER", "Bundesliga")) }
        if enableITA { leagues.append(("ITA", "Serie A")) }
        if enableMEX { leagues.append(("MEX", "Liga MX")) }
        if enableFRA { leagues.append(("FRA", "Ligue 1")) }
        if enableNED { leagues.append(("NED", "Eredivisie")) }
        if enablePOR { leagues.append(("POR", "Primeira Liga")) }

        // Lacrosse
        if enableNLL { leagues.append(("NLL", "NLL")) }
        if enablePLL { leagues.append(("PLL", "PLL")) }
        if enableLNCAAM { leagues.append(("LNCAAM", "NCAA M Lacrosse")) }
        if enableLNCAAF { leagues.append(("LNCAAF", "NCAA F Lacrosse")) }

        // Volleyball
        if enableVNCAAM { leagues.append(("VNCAAM", "NCAA M Volleyball")) }
        if enableVNCAAF { leagues.append(("VNCAAF", "NCAA F Volleyball")) }

        return leagues
    }

    private var filteredTeams: [TeamInfo] {
        guard let league = selectedLeague else { return [] }
        let teams = favoritesManager.getTeams(for: league)

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
                Section("Notification Settings") {
                    Toggle(isOn: $notifyFavoriteGameStart) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.secondary)
                            Text("Notify when favorite team's game starts")
                        }
                    }

                    Toggle(isOn: $notifyFavoriteGameEnd) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .foregroundColor(.secondary)
                            Text("Notify when favorite team's game ends")
                        }
                    }

                    Toggle(isOn: $autoPinFavorites) {
                        HStack {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.secondary)
                            Text("Auto-pin favorite team games")
                        }
                    }
                }

                Section {
                    if favoritesManager.favorites.isEmpty {
                        Text("No favorite teams yet")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(favoritesManager.favorites) { team in
                            HStack {
                                if let logoUrl = team.logo, let url = URL(string: logoUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Image(systemName: "sportscourt")
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 24, height: 24)
                                } else {
                                    Image(systemName: "sportscourt")
                                        .foregroundColor(.secondary)
                                        .frame(width: 24, height: 24)
                                }

                                VStack(alignment: .leading) {
                                    Text(team.displayName)
                                        .font(.body)
                                    Text(LeagueAPIMapping.displayName(for: team.leagueKey))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button {
                                    favoritesManager.removeFavorite(team)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Current Favorites")
                            .font(.headline)
                        Spacer()
                        if !favoritesManager.favorites.isEmpty {
                            Button("Clear All") {
                                favoritesManager.clearAllFavorites()
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        }
                    }
                }

                Section("Add Favorites") {
                    if enabledLeagues.isEmpty {
                        Text("Enable leagues in the Leagues tab to add favorites")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        Picker("Select League", selection: $selectedLeague) {
                            Text("Choose a league...").tag(nil as String?)
                            ForEach(enabledLeagues, id: \.key) { league in
                                Text(league.name).tag(league.key as String?)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedLeague) { newValue in
                            if let league = newValue {
                                Task {
                                    await favoritesManager.fetchTeams(for: league)
                                }
                            }
                            searchText = ""
                        }

                        if selectedLeague != nil {
                            TextField("Search teams...", text: $searchText)
                                .textFieldStyle(.roundedBorder)

                            if favoritesManager.isLoadingTeams {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Loading teams...")
                                        .foregroundColor(.secondary)
                                }
                            } else if filteredTeams.isEmpty {
                                Text("No teams found")
                                    .foregroundColor(.secondary)
                                    .italic()
                            } else {
                                ScrollView {
                                    LazyVStack(alignment: .leading, spacing: 8) {
                                        ForEach(filteredTeams) { team in
                                            TeamRowView(
                                                team: team,
                                                leagueKey: selectedLeague!,
                                                isFavorite: favoritesManager.isFavoriteTeamInLeague(teamId: team.id, leagueKey: selectedLeague!),
                                                onToggle: {
                                                    if favoritesManager.isFavoriteTeamInLeague(teamId: team.id, leagueKey: selectedLeague!) {
                                                        favoritesManager.removeFavorite(teamId: team.id, leagueKey: selectedLeague!)
                                                    } else {
                                                        favoritesManager.addFavorite(from: team, leagueKey: selectedLeague!)
                                                    }
                                                }
                                            )
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .frame(maxHeight: 200)
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}

struct TeamRowView: View {
    let team: TeamInfo
    let leagueKey: String
    let isFavorite: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack {
            if let logoUrl = team.primaryLogo, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Image(systemName: "sportscourt")
                        .foregroundColor(.secondary)
                }
                .frame(width: 24, height: 24)
            } else {
                Image(systemName: "sportscourt")
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }

            Text(team.displayName)
                .font(.body)

            Text("(\(team.abbreviation))")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Button {
                onToggle()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isFavorite ? Color.yellow.opacity(0.1) : Color.clear)
        .cornerRadius(6)
    }
}
