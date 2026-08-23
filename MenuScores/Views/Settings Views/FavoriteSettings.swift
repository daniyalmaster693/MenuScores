//
//  FavoritesSettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-20.
//

import SwiftUI

struct FavoritesSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var favoritesManager = FavoritesManager.shared

    @AppStorage("autoPinFavorites") private var autoPinFavorites = false
    @AppStorage("autoClearFavorites") private var autoClearFavorites = true

    @AppStorage("selectedPinType") private var selectedPinType: PinType = .menubar
    @AppStorage("enableNotch") private var enableNotch = true

    @State private var favoriteTeamMessage: String?

    enum PinType: String, CaseIterable, Identifiable {
        case menubar = "Menubar"
        case notch = "Notch"

        var id: String { rawValue }
    }

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

    @AppStorage("selectedFavoriteLeague") private var selectedLeague = "NHL"
    @State private var searchText = ""

    @State private var currentPage = 0
    private let teamsPerPage = 50

    private func fallbackLogo(for leagueKey: String) -> String {
        let sport = (FavoriteTeams.mappings[leagueKey]?.sport ?? "hockey")
        let league = (FavoriteTeams.mappings[leagueKey]?.league ?? "NHL")

        if sport == "racing" && league == "F1" {
            return "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
        } else if sport == "racing" && league != "F1" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "golf" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "volleyball" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
        } else {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport).png&h=80&w=80&scale=crop&cquality=40"
        }
    }

    private var filteredTeams: [TeamInfo] {
        if FavoriteTeams.isLeagueOnly(selectedLeague) {
            let leagueTeam = FavoriteTeams.leagueAsTeam(for: selectedLeague)
            if searchText.isEmpty {
                return [leagueTeam]
            }
            return leagueTeam.displayName.localizedCaseInsensitiveContains(searchText) ? [leagueTeam] : []
        }

        let teams = favoritesManager.availableTeams[selectedLeague] ?? []

        if searchText.isEmpty {
            return teams
        }

        return teams.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var paginatedTeams: [TeamInfo] {
        let startIndex = currentPage * teamsPerPage
        let endIndex = min(startIndex + teamsPerPage, filteredTeams.count)

        guard startIndex < endIndex else {
            return []
        }

        return Array(filteredTeams[startIndex ..< endIndex])
    }

    private var totalPages: Int {
        max(1, Int(ceil(Double(filteredTeams.count) / Double(teamsPerPage))))
    }

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section("Auto Pin") {
                    Toggle(isOn: $autoPinFavorites) {
                        HStack {
                            Image(systemName: "pin")
                                .foregroundColor(.primary)
                            Text("Auto Pin Favorite Team Games")
                        }
                    }

                    Toggle(isOn: $autoClearFavorites) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.primary)
                            Text("Auto Remove Completed Games")
                        }
                    }
                    .disabled(!self.autoPinFavorites)

                    HStack {
                        Label("Auto Pin Preference", systemImage: "display")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: self.$selectedPinType) {
                            ForEach(PinType.allCases) { key in
                                Text(key.rawValue).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!self.autoPinFavorites)
                        .frame(width: 150)
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

                Section {
                    if favoritesManager.favorites.isEmpty {
                        Text("No teams added.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(favoritesManager.favorites.enumerated()), id: \.element.uniqueID) { index, favorite in
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string: colorScheme == .dark
                                            ? darkFavoriteLogoURL(
                                                from: favorite.logo ?? fallbackLogo(for: favorite.leagueKey),
                                                teamID: favorite.id,
                                                league: favorite.leagueKey
                                            ) ?? fallbackLogo(for: favorite.leagueKey)
                                            : favorite.logo ?? fallbackLogo(for: favorite.leagueKey)
                                    )
                                ) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .interpolation(.high)
                                            .scaledToFit()
                                            .transition(.opacity)
                                            .frame(width: 18, height: 18)
                                    } else {
                                        Color.clear
                                            .transition(.opacity)
                                            .frame(width: 18, height: 18)
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text(favorite.displayName)

                                    Text(FavoriteTeams.isLeagueOnly(favorite.leagueKey)
                                        ? (FavoriteTeams.mappings[favorite.leagueKey]?.sport.capitalized ?? favorite.leagueKey)
                                        : FavoriteTeams.displayName(for: favorite.leagueKey))
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                }

                                Spacer()

                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if index > 0 {
                                            favoritesManager.favorites.swapAt(index, index - 1)
                                            favoritesManager.saveFavorites()
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.up")
                                }
                                .disabled(index == 0)
                                .buttonStyle(.plain)
                                .help("Increase priority")

                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if index < favoritesManager.favorites.count - 1 {
                                            favoritesManager.favorites.swapAt(index, index + 1)
                                            favoritesManager.saveFavorites()
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                }
                                .disabled(index == favoritesManager.favorites.count - 1)
                                .buttonStyle(.plain)
                                .help("Decrease priority")

                                Button {
                                    favoritesManager.favorites.removeAll {
                                        $0.id == favorite.id && $0.leagueKey == favorite.leagueKey
                                    }
                                    favoritesManager.saveFavorites()
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                                .buttonStyle(.plain)
                                .help("Remove from favorites")
                            }
                        }
                    }
                } header: {
                    HStack(spacing: 4) {
                        HStack {
                            Text("Favorite Teams")
                                .font(.headline)
                            Spacer()

                            if let message = favoriteTeamMessage {
                                Text(message)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Button(action: {
                                favoriteTeamMessage = "Remove favorite teams before disabling their league."
                            }) {
                                Image(systemName: "exclamationmark.circle")
                            }
                            .controlSize(.small)
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .help("Important!")
                        }
                    }
                } footer: {
                    if !favoritesManager.favorites.isEmpty {
                        Text("Use the arrows to set priority. Higher priority teams take precedence when multiple games are live.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    TextField("Search teams...", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    ZStack {
                        if favoritesManager.isLoadingTeams {
                            ProgressView()
                                .transition(.opacity)
                        } else {
                            ScrollView {
                                LazyVStack {
                                    ForEach(Array(paginatedTeams.indices), id: \.self) { index in
                                        let team = paginatedTeams[index]

                                        FavoriteTeamRow(
                                            team: team,
                                            leagueKey: selectedLeague
                                        )

                                        if index != paginatedTeams.count - 1 {
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    .animation(
                        .easeInOut(duration: 0.2),
                        value: favoritesManager.isLoadingTeams ||
                            favoritesManager.availableTeams[selectedLeague] == nil
                    )
                } header: {
                    Text("Teams")
                } footer: {
                    if totalPages > 1 {
                        HStack {
                            Button {
                                currentPage -= 1
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .buttonStyle(.bordered)
                            .disabled(currentPage == 0)

                            Spacer()

                            Text("Page \(currentPage + 1) of \(totalPages)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Spacer()

                            Button {
                                currentPage += 1
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(.bordered)
                            .disabled(currentPage >= totalPages - 1)
                        }
                    }
                }
                .task(id: selectedLeague) {
                    if FavoriteTeams.isLeagueOnly(selectedLeague) {
                        favoritesManager.isLoadingTeams = false
                    } else if let url = FavoriteTeams.teamsUrl(for: selectedLeague) {
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
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var favorites = FavoritesManager.shared

    let team: TeamInfo
    let leagueKey: String

    private var fallbackLogo: String {
        let sport = (FavoriteTeams.mappings[leagueKey]?.sport ?? "hockey")
        let league = (FavoriteTeams.mappings[leagueKey]?.league ?? "NHL")

        if sport == "racing" && league == "F1" {
            return "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
        } else if sport == "racing" && league != "F1" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "golf" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "volleyball" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
        } else {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport).png&h=80&w=80&scale=crop&cquality=40"
        }
    }

    var body: some View {
        HStack {
            AsyncImage(
                url: URL(
                    string: colorScheme == .dark
                        ? darkFavoriteLogoURL(
                            from: team.logos?.first?.href ?? fallbackLogo,
                            teamID: team.id,
                            league: leagueKey
                        ) ?? fallbackLogo
                        : team.logos?.first?.href ?? fallbackLogo
                )
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .interpolation(.high)
                        .scaledToFit()
                        .transition(.opacity)
                        .frame(width: 18, height: 18)
                } else {
                    Color.clear
                        .transition(.opacity)
                        .frame(width: 18, height: 18)
                }
            }

            Text(team.displayName)

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
            .help("Add to favorites")
        }
        .padding(.top, 5)
    }
}
