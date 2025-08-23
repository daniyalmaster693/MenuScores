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

    @State private var capsuleColor: Color = .black
    @State private var driverArray: [Driver] = []

    // MARK: Sport Related Text Variables

    // Baseball

    var sport: String
    var league: String

    // Fetch Latest Play Team Color

    func fetchLatestPlayTeamColor() async {
        guard let game = notchViewModel.game,
              let latestPlayTeamID = game.competitions.first?.situation?.lastPlay.team.id
        else { return }

        let competitors = game.competitions.first?.competitors ?? []

        let teamIndex: Int
        if competitors.count > 1, latestPlayTeamID == competitors[1].team?.id {
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
    }

    // Fetch Race Info

    func fetchRaceInfo() async {
        let dateForAPI = formattedDateForAPI(from: notchViewModel.game?.date ?? "")
        let urlString = "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=f1&dates=\(dateForAPI)"

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
                                        url: URL(string: {
                                            if sport == "volleyball" {
                                                return game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                            } else {
                                                return game.competitions[0].competitors?[1].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport.lowercased()).png&h=80&w=80&scale=crop&cquality=40"
                                            }
                                        }())
                                    ) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Color.black
                                    }
                                    .frame(width: 32, height: 32)
                                    .padding(.trailing, 3)

                                    VStack {
                                        Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                                            .font(.system(size: 22, weight: .medium))

                                        Text("\(game.competitions[0].competitors?[1].team?.abbreviation ?? "-")")
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
                                    Text("\(game.status.type.detail ?? "-")")
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
                                    Text("\(periodPrefix(for: league))\(game.status.period ?? 0) \(game.status.displayClock ?? "-")")
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

                                        Text("\(game.competitions[0].competitors?[0].team?.abbreviation ?? "-")")
                                            .font(.system(size: 12, weight: .medium))
                                    }

                                    AsyncImage(
                                        url: URL(string: {
                                            if sport == "Volleyball" {
                                                return game.competitions[0].competitors?[0].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
                                            } else {
                                                return game.competitions[0].competitors?[0].team?.logo ?? "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport.lowercased()).png&h=80&w=80&scale=crop&cquality=40"
                                            }
                                        }())
                                    ) { image in
                                        image.resizable().scaledToFit()
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

                                        Text("\(game.competitions.first?.situation?.lastPlay.text ?? "-")")
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
                                    Text("Outs: \(game.competitions.first?.situation?.outs ?? 0)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Balls: \(game.competitions.first?.situation?.balls ?? 0)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Strikes: \(game.competitions.first?.situation?.strikes ?? 0)")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))
                                }.padding(.top, 7)
                            }

                            if sport == "Football" {
                                HStack(alignment: .center, spacing: 20) {
                                    Text("Down: \(game.competitions.first?.situation?.downDistanceText ?? "-")")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))
                                }.padding(.top, 7)
                            }
                        }
                        .task {
                            if let _ = notchViewModel.game?.id {
                                await fetchLatestPlayTeamColor()
                            }
                        }
                        .padding(.top, 10)
                    }

                    if sport != "Lacrosse" && sport != "Volleyball" &&
                        (game.competitions[0].status.type.state == "pre" || game.competitions[0].status.type.state == "post"),
                        let headline = game.competitions.first?.highlights?.first?.headline ?? game.competitions.first?.headlines?.first?.shortLinkText
                    {
                        VStack(alignment: .center) {
                            GeometryReader { geo in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .center, spacing: 10) {
                                        Capsule()
                                            .fill(.white)
                                            .frame(width: 3, height: 16)
                                        Text(headline)
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
                                    }

                                    if game.competitions[4].status.type.state == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))

                                            Text(
                                                "\(game.competitions[4].competitors?.first(where: { $0.order == 1 })?.athlete?.shortName ?? "-")"
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
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            ForEach(driverArray.filter { $0.order != nil }, id: \.id) { driver in
                                                HStack {
                                                    Text(driver.order.map { String($0) } ?? "-")
                                                        .frame(width: 30, alignment: .leading)

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
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                .frame(maxHeight: 130)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[4].status.type.state == "pre" {
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
                                        .frame(width: 28, height: 28)
                                        .padding(.trailing, 3)

                                        Text("\(game.shortName)")
                                            .font(.system(size: 18, weight: .medium))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)

                                    HStack {
                                        Image(systemName: "flag.checkered")
                                            .font(.system(size: 12))

                                        Text("\(formattedDate(from: game.endDate ?? "Invalid Date"))  @  \(formattedTime(from: game.date))")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding(.top, 2)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
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
                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
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
                                    .frame(width: 18, height: 18)
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if game.status.type.state == "in" {
                                        if let lap = game.competitions[0].status.period {
                                            Text("L\(lap)")
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 10)
                                        }
                                    }

                                    if game.status.type.state == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))

                                            Text(
                                                "\(game.competitions[0].competitors?.first(where: { $0.order == 1 })?.athlete?.shortName ?? "-")"
                                            )
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }
                                .padding(.top, 5)

                                VStack(spacing: 5) {
                                    HStack {
                                        Text("#").frame(width: 30, alignment: .leading)
                                        Text("Driver").frame(width: 160, alignment: .leading)
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            let competitors = game.competitions[0].competitors ?? []

                                            ForEach(competitors.filter { $0.order != nil }, id: \.id) { competitor in
                                                HStack {
                                                    Text("\(competitor.order ?? 0)")
                                                        .frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let flagURLString = competitor.athlete?.flag?.href,
                                                           let flagURL = URL(string: flagURLString)
                                                        {
                                                            AsyncImage(url: flagURL) { image in
                                                                image.resizable().scaledToFit()
                                                            } placeholder: {
                                                                Color.gray.opacity(0.3)
                                                            }
                                                            .frame(width: 16, height: 16)
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.athlete?.displayName ?? "-")
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                    .frame(width: 160, alignment: .leading)
                                                }
                                                .font(.system(size: 13))
                                                .padding(.horizontal, 10)
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                .frame(maxHeight: 130)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[0].status.type.state == "pre" {
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

                                    Text("\(game.shortName)")
                                        .font(.system(size: 18, weight: .medium))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)

                                HStack {
                                    Image(systemName: "flag.checkered")
                                        .font(.system(size: 12))

                                    Text("\(formattedDate(from: game.date)) @ \(formattedTime(from: game.date))")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .padding(.top, 2)
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
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

            if sport == "Golf" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            if game.competitions[0].status.type.state == "in" || game.competitions[0].status.type.state == "post" {
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
                                    .frame(width: 18, height: 18)
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if game.status.type.state == "in" {
                                        if let round = game.competitions[0].status.period {
                                            Text("R\(round)")
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 10)
                                        }
                                    }

                                    if game.status.type.state == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))

                                            Text(
                                                "\(game.competitions[0].competitors?.first(where: { $0.order == 1 })?.athlete?.shortName ?? "-")"
                                            )
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }

                                VStack(spacing: 5) {
                                    HStack {
                                        Text("#").frame(width: 30, alignment: .leading)
                                        Text("Golfer").frame(width: 150, alignment: .leading)
                                        Text("Score").frame(width: 80, alignment: .trailing)
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            let competitors = game.competitions[0].competitors ?? []

                                            ForEach(competitors.filter { $0.order != nil }.prefix(20), id: \.id) { competitor in
                                                HStack {
                                                    Text("\(competitor.order ?? 0)")
                                                        .frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let flagURLString = competitor.athlete?.flag?.href,
                                                           let flagURL = URL(string: flagURLString)
                                                        {
                                                            AsyncImage(url: flagURL) { image in
                                                                image.resizable().scaledToFit()
                                                            } placeholder: {
                                                                Color.gray.opacity(0.3)
                                                            }
                                                            .frame(width: 16, height: 16)
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.athlete?.displayName ?? "-")
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }.frame(width: 150, alignment: .leading)

                                                    Text(competitor.score ?? "-")
                                                        .frame(width: 80, alignment: .trailing)
                                                }
                                                .font(.system(size: 13))
                                                .padding(.horizontal, 10)
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .frame(maxHeight: 120)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if game.competitions[0].status.type.state == "pre" {
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
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)

                                    HStack {
                                        Image(systemName: "figure.golf")
                                            .font(.system(size: 12))

                                        Text("\(formattedDate(from: game.endDate ?? "-")) @ \(formattedTime(from: game.date))")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .padding(.top, 2)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
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
        }
    }
}
