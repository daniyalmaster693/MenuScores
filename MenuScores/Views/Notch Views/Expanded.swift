//
//  Expanded.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import Sparkle
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    func brightness() -> Double {
        let nsColor = NSColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return 0.299 * Double(red) + 0.587 * Double(green) + 0.114 * Double(blue)
    }
}

struct Info: View {
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0
    @ObservedObject var notchViewModel: NotchViewModel

    @State private var refreshID = UUID()
    @State private var latestPlayText: String = "Loading..."
    @State private var capsuleColor: Color = .black

    var sport: String
    var league: String

    // College League Mapper

    func apiLeague(for league: String) -> String {
        switch league.uppercased() {
        case "HNCAAM": return "mens-college-hockey"

        case "HNCAAF": return "womens-college-hockey"

        case "NCAA M": return "mens-college-basketball"

        case "NCAA F": return "womens-college-basketball"

        case "FNCAA": return "college-football"

        case "BNCAA": return "college-baseball"

        case "SNCAA": return "college-softball"

        case "LNCAAM": return "mens-college-lacrosse"

        case "LNCAAF": return "womens-college-lacrosse"

        case "VNCAAM": return "mens-college-volleyball"

        case "VNCAAF": return "womens-college-volleyball"

        default: return league.lowercased()
        }
    }

    // Recent Player Fetcher

    func fetchLatestPlay() async {
        // TODO: Make this work dynamically for any sport that isn't racing or soccer

        let urlString = "https://site.web.api.espn.com/apis/site/v2/sports/\(sport.lowercased())/\(apiLeague(for: league))/summary?event=\(notchViewModel.game?.id ?? "0")"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PlaybyPlayResponse.self, from: data)

            if sport.lowercased() == "football" {
                if let scoringPlays = response.scoringPlays, !scoringPlays.isEmpty {
                    let latestPlay = scoringPlays.last!
                    DispatchQueue.main.async {
                        self.latestPlayText = latestPlay.text ?? "-"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.latestPlayText = "N/A"
                    }
                }
            } else {
                if let plays = response.plays, !plays.isEmpty {
                    let latestPlay = plays.last!
                    DispatchQueue.main.async {
                        self.latestPlayText = latestPlay.text ?? "-"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.latestPlayText = "N/A"
                    }
                }
            }
        } catch {
            print("Failed to fetch play-by-play: \(error)")
            DispatchQueue.main.async {
                self.latestPlayText = "N/A"
            }
        }
    }

    // Play by Play Event Team Mapper

    func fetchLatestPlayTeamColor() async {
        // TODO: Make sure api still works for college leagues and other sports

        let urlString = "https://site.web.api.espn.com/apis/site/v2/sports/\(sport.lowercased())/\(apiLeague(for: league))/summary?event=\(notchViewModel.game?.id ?? "0")"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PlaybyPlayResponse.self, from: data)

            guard let latestPlay = (sport.lowercased() == "football" ? response.scoringPlays?.last : response.plays?.last) else {
                return
            }

            // TODO: Update to use scoring plays for football

            let playTeamID = latestPlay.team?.id
            guard let game = notchViewModel.game else { return }
            let competitors = game.competitions[0].competitors ?? []

            let teamIndex: Int
            if playTeamID == competitors[1].team?.id {
                teamIndex = 1
            } else {
                teamIndex = 0
            }

            let teamHex = competitors[teamIndex].team?.color ?? "#FFFFFF"
            let altHex = competitors[teamIndex].team?.alternateColor ?? "#FFFFFF"

            let mainColor = Color(hex: teamHex)
            let altColor = Color(hex: altHex)

            let fillColor = altColor.brightness() < 0.1 ? mainColor : altColor

            DispatchQueue.main.async {
                self.capsuleColor = fillColor
            }

        } catch {
            print("Failed to fetch latest play color: \(error)")
            DispatchQueue.main.async {
                self.capsuleColor = .black
            }
        }
    }

    // Sparkle Updater Closure

    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    private var updater: SPUUpdater {
        updaterController.updater
    }

    var body: some View {
        if let game = notchViewModel.game {
            if sport != "Racing" && sport != "Golf" {
                VStack {
                    HStack {
                        HStack(spacing: 4) {
                            VStack {
                                HStack {
                                    AsyncImage(
                                        url: URL(string: game.competitions[0].competitors?[1].team?.logo ?? "")
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        Color.black
                                    }
                                    .frame(width: 32, height: 32)
                                    .padding(.trailing, 3)

                                    VStack {
                                        Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                                            .font(.system(size: 22, weight: .medium))

                                        Text("\(game.competitions[0].competitors?[1].team?.abbreviation ?? "")")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                }
                            }
                        }

                        if sport == "Baseball" || sport == "Soccer" {
                            HStack(spacing: 4) {
                                if game.status.type.state == "post" {
                                    Text("Final")
                                        .font(.system(size: 19, weight: .semibold))
                                } else if game.status.type.state == "pre" {
                                    Text(formattedTime(from: game.date))
                                        .font(.system(size: 19, weight: .semibold))
                                } else {
                                    Text("\(game.status.type.detail ?? "")")
                                        .font(.system(size: 19, weight: .semibold))
                                }
                            }
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                        }

                        if sport != "Baseball" && sport != "Soccer" {
                            HStack(spacing: 4) {
                                if game.status.type.state == "post" {
                                    Text("Final")
                                        .font(.system(size: 19, weight: .semibold))
                                } else if game.status.type.state == "pre" {
                                    Text(formattedTime(from: game.date))
                                        .font(.system(size: 19, weight: .semibold))
                                } else {
                                    Text("P\(game.status.period ?? 0) \(game.status.displayClock ?? "")")
                                        .font(.system(size: 19, weight: .semibold))
                                }
                            }
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                        }

                        HStack(spacing: 4) {
                            VStack {
                                HStack {
                                    VStack {
                                        Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                                            .font(.system(size: 22, weight: .medium))

                                        Text("\(game.competitions[0].competitors?[0].team?.abbreviation ?? "")")
                                            .font(.system(size: 12, weight: .medium))
                                    }

                                    AsyncImage(
                                        url: URL(string: game.competitions[0].competitors?[0].team?.logo ?? "")
                                    ) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        Color.black
                                    }
                                    .frame(width: 32, height: 32)
                                    .padding(.leading, 3)
                                }
                            }
                        }
                    }

                    if sport != "Soccer" && sport != "Lacrosse" && sport != "Volleyball" && game.competitions[0].status.type.state == "post" {
                        HStack {
                            Capsule()
                                .fill(capsuleColor)
                                .frame(width: 3, height: 16)

                            Text(latestPlayText)
                                .truncationMode(.tail)
                        }.task {
                            if let _ = notchViewModel.game?.id {
                                await fetchLatestPlay()
                                await fetchLatestPlayTeamColor()
                            }
                        }
                        .id(refreshID)
                        .padding(.top, 10)
                        .frame(maxHeight: 22, alignment: .center)
                    }
                }
                .contextMenu {
                    Picker("Choose Display", selection: $notchScreenIndex) {
                        ForEach(NSScreen.screens.indices, id: \.self) { index in
                            Text(NSScreen.screens[index].localizedName)
                                .tag(index)
                        }
                    }

                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "Racing" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
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
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 3)

                                Text("\(game.shortName)")
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.bottom, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)

                            if game.competitions[4].status.type.state == "in" || game.competitions[4].status.type.state == "post" {
                                HStack {
                                    Text("Current Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let lap = game.competitions[4].status.period {
                                        Text("L\(lap)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                VStack {
                                    let competitors = game.competitions[4].competitors ?? []

                                    ForEach(competitors.prefix(5), id: \.id) { competitor in
                                        HStack {
                                            if let flagURLString = competitor.athlete?.flag.href,
                                               let flagURL = URL(string: flagURLString)
                                            {
                                                AsyncImage(url: flagURL) { image in
                                                    image.resizable().scaledToFit()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 16, height: 16)
                                                .padding(.trailing, 3)
                                                .padding(.leading, 10)
                                            }

                                            Text("\(competitor.order ?? 0). ")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                            Text("\(competitor.athlete?.displayName ?? "Unknown")")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.padding(.top, 10)
                            }

                            if game.competitions[4].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "flag.checkered")
                                        .font(.system(size: 12))

                                    Text("Race Date: \(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "Golf" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                AsyncImage(
                                    url: URL(
                                        string:
                                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 32, height: 32)
                                .padding(.trailing, 3)

                                Text("\(game.shortName)")
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.bottom, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)

                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                                HStack {
                                    Text("Current Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let round = game.competitions[0].status.period {
                                        Text("R\(round)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                VStack {
                                    let competitors = game.competitions[0].competitors ?? []

                                    ForEach(competitors.prefix(5), id: \.id) { competitor in
                                        HStack {
                                            HStack {
                                                if let flagURLString = competitor.athlete?.flag.href,
                                                   let flagURL = URL(string: flagURLString)
                                                {
                                                    AsyncImage(url: flagURL) { image in
                                                        image.resizable().scaledToFit()
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 16, height: 16)
                                                    .padding(.trailing, 3)
                                                    .padding(.leading, 10)
                                                }

                                                Text("\(competitor.order ?? 0). ")
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)

                                                Text("\(competitor.athlete?.displayName ?? "Unknown")")
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                            }

                                            Text("\(competitor.score ?? "-")")
                                                .lineLimit(1)
                                                .truncationMode(.tail)

                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.padding(.top, 10)
                            }

                            if game.competitions[0].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "figure.golf")
                                        .font(.system(size: 12))

                                    Text("Tournament Date: \(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
                    if #available(macOS 14, *) {
                        Button {
                            let environment = EnvironmentValues()
                            environment.openSettings()
                            NSApp.setActivationPolicy(.regular)
                            NSApp.activate(ignoringOtherApps: true)
                        } label: {
                            Text("Preferences")
                        }
                        .keyboardShortcut(",")
                    }

                    Button {
                        updater.checkForUpdates()
                    } label: {
                        Text("Check for Updates")
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("u")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }
    }
}
