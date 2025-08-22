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

    // Recent Play Variables

    @State private var latestPlayText: String = "Loading..."
    @State private var postGameText: String = "Loading..."
    @State private var capsuleColor: Color = .black
    @State private var driverArray: [Driver] = []
    @State private var refreshID = UUID()

    // MARK: Sport Related Text Variables

    // Baseball

    @State private var outs: String = "..."
    @State private var balls: String = "..."
    @State private var strikes: String = "..."

    var sport: String
    var league: String

    // League Name Mapper

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

        case "MLS": return "USA.1"

        case "UEFA": return "uefa.champions"

        case "EPL": return "ENG.1"

        case "ESP": return "ESP.1"

        case "GER": return "GER.1"

        case "ITA": return "ITA.1"

        case "MEX": return "MEX.1"

        case "FRA": return "FRA.1"

        case "NED": return "NED.1"

        case "POR": return "POR.1"

        default: return league.lowercased()
        }
    }

    // Recent Player Fetcher

    func fetchLatestPlay() async {
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
                        self.latestPlayText = latestPlay.text ?? latestPlay.type?.text ?? "-"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.latestPlayText = "No Recent Plays"
                    }
                }
            }

            if sport.lowercased() == "soccer" {
                if let keyEvents = response.keyEvents, !keyEvents.isEmpty {
                    let latestPlay = keyEvents.last!
                    DispatchQueue.main.async {
                        self.latestPlayText = latestPlay.text ?? latestPlay.type?.text ?? "-"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.latestPlayText = "No Recent Plays"
                    }
                }
            }

            else {
                if let plays = response.plays, !plays.isEmpty {
                    let latestPlay = plays.last!
                    DispatchQueue.main.async {
                        self.latestPlayText = latestPlay.text ?? latestPlay.type?.text ?? "-"

                        if sport == "Baseball" {
                            self.outs = latestPlay.outs.map { String($0) } ?? "-"
                            self.balls = latestPlay.pitchCount?.balls.map { String($0) } ?? "-"
                            self.strikes = latestPlay.pitchCount?.strikes.map { String($0) } ?? "-"
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.latestPlayText = "No Recent Plays"
                    }
                }
            }
        } catch {
            print("Failed to fetch play-by-play: \(error)")
            DispatchQueue.main.async {
                self.latestPlayText = "No Recent Plays"
            }
        }
    }

    func fetchLatestPlayTeamColor() async {
        let urlString = "https://site.web.api.espn.com/apis/site/v2/sports/\(sport.lowercased())/\(apiLeague(for: league))/summary?event=\(notchViewModel.game?.id ?? "0")"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PlaybyPlayResponse.self, from: data)

            guard let latestPlay = (
                sport.lowercased() == "football"
                    ? response.scoringPlays?.last
                    : sport.lowercased() == "soccer"
                    ? response.keyEvents?.last
                    : response.plays?.last
            ) else {
                return
            }

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

    // Fetch Post Game Article Headline

    func fetchGameHeadline() async {
        let urlString = "https://site.web.api.espn.com/apis/site/v2/sports/\(sport.lowercased())/\(apiLeague(for: league))/summary?event=\(notchViewModel.game?.id ?? "0")"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PlaybyPlayResponse.self, from: data)

            if let article = response.article {
                DispatchQueue.main.async {
                    self.postGameText = article.headline ?? article.linkText ?? "-"
                }
            } else {
                DispatchQueue.main.async {
                    self.postGameText = "No headline available"
                }
            }
        } catch {
            print("Failed to fetch play-by-play: \(error)")
            DispatchQueue.main.async {
                self.postGameText = "No headline available"
            }
        }
    }

    // Fetch Race Info

    func fetchRaceInfo() async {
        let urlString = "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=f1&dates=20250803"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(RaceInfoResponse.self, from: data)

            if let race = response.sports.first?.leagues.first?.events[4] {
                DispatchQueue.main.async {
                    driverArray = race.competitors
                }
            } else {
                DispatchQueue.main.async {
                    driverArray = []
                }
            }

        } catch {
            print("Failed to fetch race info: \(error)")
            DispatchQueue.main.async {}
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
            if sport != "F1" && sport != "Racing" && sport != "Golf" {
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

                    if sport != "Lacrosse" && sport != "Volleyball" && game.competitions[0].status.type.state == "in" {
                        VStack(alignment: .center) {
                            GeometryReader { geo in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Capsule()
                                            .fill(capsuleColor)
                                            .frame(width: 3, height: 16)

                                        Text(latestPlayText)
                                            .font(.system(size: 14, weight: .medium))
                                            .fixedSize()
                                    }
                                    .frame(minWidth: geo.size.width, alignment: .center)
                                }
                                .padding(.horizontal, 5)
                                .frame(height: 22)
                            }
                            .frame(height: 22)

                            if sport == "Baseball" {
                                HStack(alignment: .center, spacing: 20) {
                                    Text("Outs: \(outs)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Balls: \(balls)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Strikes: \(strikes)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))
                                }.padding(.top, 7)
                            }
                        }
                        .task {
                            if let _ = notchViewModel.game?.id {
                                await fetchLatestPlay()
                                await fetchLatestPlayTeamColor()
                            }
                        }
                        .id(refreshID)
                        .padding(.top, 10)
                    }

                    if sport != "Lacrosse" && sport != "Volleyball" && game.competitions[0].status.type.state == "pre" || game.competitions[0].status.type.state == "post" {
                        VStack(alignment: .center) {
                            GeometryReader { geo in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Capsule()
                                            .fill(.white)
                                            .frame(width: 3, height: 16)

                                        Text(postGameText)
                                            .font(.system(size: 14, weight: .medium))
                                            .fixedSize()
                                    }
                                    .frame(minWidth: geo.size.width, alignment: .center)
                                }
                                .padding(.horizontal, 5)
                                .frame(height: 22)
                            }
                            .frame(height: 22)
                        }

                        .task {
                            if let _ = notchViewModel.game?.id {
                                await fetchGameHeadline()
                            }
                        }
                        .id(refreshID)
                        .padding(.top, 10)
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

            if sport == "F1" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            if game.competitions[4].status.type.state == "in" || game.competitions[4].status.type.state == "post" {
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
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if game.competitions[4].status.type.state == "in" {
                                        if let lap = game.competitions[4].status.period {
                                            Text("L\(lap)")
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 10)
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))

                                            Text(
                                                "\(game.competitions[4].competitors?[0].athlete?.shortName ?? "-")"
                                            )
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }

                                VStack(spacing: 5) {
                                    HStack {
                                        Text("#").frame(width: 30, alignment: .leading)
                                        Text("Driver").frame(width: 130, alignment: .leading)
                                        Text("Race Time").frame(width: 80, alignment: .trailing)
                                        Text("Laps").frame(width: 50, alignment: .trailing)
                                        Text("Pits").frame(width: 50, alignment: .trailing)
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            ForEach(driverArray, id: \.id) { driver in
                                                HStack {
                                                    Text("\(driver.order)").frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let logoURL = URL(string: driver.logo) {
                                                            AsyncImage(url: logoURL) { image in
                                                                image.resizable().scaledToFit()
                                                            } placeholder: {
                                                                Color.gray.opacity(0.3)
                                                            }
                                                            .frame(width: 16, height: 16)
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(driver.displayName)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                    .frame(width: 130, alignment: .leading)

                                                    if driver.order == 1 {
                                                        Text(
                                                            "\(driver.time ?? "-")"
                                                        ).frame(width: 80, alignment: .trailing)
                                                    } else {
                                                        Text(
                                                            {
                                                                if let behindTime = driver.behindTime, !behindTime.starts(with: "+") {
                                                                    return "+\(behindTime)"
                                                                } else if let behindTime = driver.behindTime {
                                                                    return behindTime
                                                                } else if let behindLaps = driver.behindLaps, let lapsInt = Int(behindLaps) {
                                                                    return "+\(lapsInt) \(lapsInt == 1 ? "Lap" : "Laps")"
                                                                } else if let behindLaps = driver.behindLaps, !behindLaps.isEmpty {
                                                                    return "+\(behindLaps)"
                                                                }
                                                                return "+-"
                                                            }()
                                                        ).frame(width: 80, alignment: .trailing)
                                                    }

                                                    Text(driver.laps)
                                                        .frame(width: 50, alignment: .trailing)

                                                    Text(driver.pitsTaken ?? "-")
                                                        .frame(width: 50, alignment: .trailing)
                                                }
                                                .font(.system(size: 13))
                                                .padding(.horizontal, 10)
                                            }
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                .task {
                                    if let _ = notchViewModel.game?.id {
                                        await fetchRaceInfo()
                                    }
                                }
                                .id(refreshID)
                                .frame(maxHeight: 130)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[4].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "flag.checkered")
                                        .font(.system(size: 12))

                                    Text("\(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
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
                                        "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
                                    )
                                ) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 3)

                                Text("\(game.name)")
                                    .font(.system(size: 18, weight: .medium))
                            }
                            .padding(.bottom, 7)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)

                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                                HStack {
                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let lap = game.competitions[0].status.period {
                                        Text("L\(lap)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                ScrollView(.vertical, showsIndicators: true) {
                                    VStack(spacing: 4) {
                                        let competitors = game.competitions[0].competitors ?? []

                                        ForEach(competitors, id: \.id) { competitor in
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
                                    }
                                }
                                .frame(maxHeight: 95)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[0].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "flag.checkered")
                                        .font(.system(size: 12))

                                    Text("\(formattedDate(from: game.date))  @  \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
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
                                .frame(width: 28, height: 28)
                                .padding(.trailing, 3)

                                Text("\(game.shortName)")
                                    .font(.system(size: 18, weight: .medium))
                            }.padding(.bottom, 7)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)

                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
                                HStack {
                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.leading, 10)

                                    Spacer()

                                    if let round = game.competitions[0].status.period {
                                        Text("R\(round)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                    }
                                }.padding(.top, 5)

                                ScrollView(.vertical, showsIndicators: true) {
                                    VStack(spacing: 4) {
                                        let competitors = game.competitions[0].competitors ?? []

                                        ForEach(competitors.prefix(15), id: \.id) { competitor in
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
                                    }
                                }
                                .frame(maxHeight: 95)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[0].status.type.state == "pre" {
                                HStack {
                                    Image(systemName: "figure.golf")
                                        .font(.system(size: 12))

                                    Text("\(formattedDate(from: game.endDate ?? "Invalid Date")) @ \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }.frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }.contextMenu {
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
        }
    }
}
