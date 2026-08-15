//
//  Expanded.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

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

    @State private var playText: String = "-"
    @State private var soccerText: String = "-"
    @State private var headlineText: String = "-"

    @State private var driverArray: [Driver] = []
    @State private var totalLaps: String? = nil
    @State private var flagColor: String? = nil

    // MARK: Sport Related Text Variables

    // Baseball

    var sport: String
    var league: String

    // Fetch Latest Play Team Color

    var capsuleColor: Color {
        guard let game = notchViewModel.game,
              let lastPlay = game.competitions.first?.situation?.lastPlay,
              let playTeamID = lastPlay.team?.id
        else { return .white }

        let competitors = game.competitions.first?.competitors ?? []

        if let matchingTeam = competitors.first(where: { $0.team?.id == playTeamID }) {
            let mainHex = matchingTeam.team?.color ?? "#FFFFFF"
            let altHex = matchingTeam.team?.alternateColor ?? "#FFFFFF"
            let mainColor = Color(hex: mainHex)
            let altColor = Color(hex: altHex)

            return mainColor.brightness() < 0.1 ? altColor : mainColor
        }

        return .white
    }

    func mapFlagColor(_ flag: String?) -> Color {
        switch flag?.uppercased() {
        case "GREEN":
            return .green
        case "YELLOW":
            return .yellow
        case "RED":
            return .red
        case "BLUE":
            return .blue
        case "CHECKERED":
            return .white
        case "CHECKER":
            return .white
        default:
            return .gray
        }
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
                                    ) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .interpolation(.high)
                                                .scaledToFit()
                                                .transition(.opacity)
                                                .frame(width: 32, height: 32)
                                        } else {
                                            Color.clear
                                                .transition(.opacity)
                                                .frame(width: 32, height: 32)
                                        }
                                    }
                                    .padding(.trailing, 7)

                                    VStack {
                                        Text("\(game.competitions[0].competitors?[1].score ?? "-")")
                                            .contentTransition(.numericText(countsDown: false))
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
                                        .contentTransition(.numericText(countsDown: false))
                                        .font(.system(size: 19, weight: .semibold))
                                }
                            }
                            .padding(.horizontal, 35)
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
                                        .contentTransition(.numericText(countsDown: false))
                                        .font(.system(size: 19, weight: .semibold))
                                }
                            }
                            .padding(.horizontal, 35)
                        }

                        HStack(spacing: 4) {
                            VStack {
                                HStack {
                                    VStack {
                                        Text("\(game.competitions[0].competitors?[0].score ?? "-")")
                                            .contentTransition(.numericText(countsDown: false))
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
                                    ) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .interpolation(.high)
                                                .scaledToFit()
                                                .transition(.opacity)
                                                .frame(width: 32, height: 32)
                                        } else {
                                            Color.clear
                                                .transition(.opacity)
                                                .frame(width: 32, height: 32)
                                        }
                                    }
                                    .padding(.leading, 7)
                                }
                            }
                        }
                    }

                    if sport != "Lacrosse" && sport != "Volleyball" && sport != "Soccer" && game.competitions[0].status.type.state == "in" {
                        VStack(alignment: .center) {
                            if let text = game.competitions.first?.situation?.lastPlay?.text {
                                GeometryReader { geo in
                                    HStack(alignment: .center, spacing: 10) {
                                        Capsule()
                                            .fill(capsuleColor)
                                            .frame(width: 3, height: 16)

                                        ZStack {
                                            let font = NSFont.systemFont(ofSize: 14, weight: .medium)
                                            let textWidth = (text as NSString).size(withAttributes: [.font: font]).width

                                            if textWidth < geo.size.width {
                                                Text(text)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .fixedSize()
                                            } else {
                                                MarqueeText($playText,
                                                            font: .system(size: 14, weight: .medium),
                                                            nsFont: .body,
                                                            textColor: .white,
                                                            frameWidth: geo.size.width - 23)
                                                    .fontWeight(.medium)
                                                    .onAppear {
                                                        playText = text
                                                    }
                                            }
                                        }
                                    }
                                    .frame(minWidth: geo.size.width, alignment: .center)
                                    .padding(.horizontal, 5)
                                    .frame(height: 22)
                                }
                                .frame(height: 22)
                            }

                            if sport == "Baseball" {
                                HStack(alignment: .center, spacing: 20) {
                                    Text("Outs: \(game.competitions.first?.situation?.outs ?? 0)")
                                        .contentTransition(.numericText(countsDown: false))
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Balls: \(game.competitions.first?.situation?.balls ?? 0)")
                                        .contentTransition(.numericText(countsDown: false))
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 13, weight: .medium))

                                    Text("Strikes: \(game.competitions.first?.situation?.strikes ?? 0)")
                                        .contentTransition(.numericText(countsDown: false))
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
                        .padding(.top, 10)
                    }

                    if sport == "Soccer" && game.competitions[0].status.type.state == "in" {
                        VStack(alignment: .center) {
                            let athletesInvolved = game.competitions.first?.details?.last?.athletesInvolved?.first?.displayName ?? ""
                            let playType = game.competitions.first?.details?.last?.type.text ?? ""
                            let playClock = game.competitions.first?.details?.last?.clock.displayValue ?? ""

                            let currentSoccerText = "\(athletesInvolved) - \(playType)    \(playClock)"

                            GeometryReader { geo in
                                HStack(alignment: .center, spacing: 10) {
                                    Capsule()
                                        .fill(capsuleColor)
                                        .frame(width: 3, height: 16)

                                    ZStack {
                                        let font = NSFont.systemFont(ofSize: 14, weight: .medium)
                                        let textWidth = (currentSoccerText as NSString)
                                            .size(withAttributes: [.font: font])
                                            .width

                                        if textWidth < geo.size.width {
                                            Text(currentSoccerText)
                                                .font(.system(size: 14, weight: .medium))
                                                .fixedSize()
                                        } else {
                                            MarqueeText(
                                                $soccerText,
                                                font: .system(size: 14, weight: .medium),
                                                nsFont: .body,
                                                textColor: .white,
                                                frameWidth: geo.size.width - 23
                                            )
                                            .fontWeight(.medium)
                                        }
                                    }
                                }
                                .frame(minWidth: geo.size.width, alignment: .center)
                                .padding(.horizontal, 5)
                                .frame(height: 22)
                            }
                            .frame(height: 22)
                            .onAppear {
                                soccerText = currentSoccerText
                            }
                            .onChange(of: currentSoccerText) { newValue in
                                soccerText = newValue
                            }
                        }
                        .padding(.top, 10)
                    }

                    VStack(alignment: .center) {
                        if sport != "Lacrosse" && sport != "Volleyball" &&
                            game.competitions[0].status.type.state == "pre" || game.competitions[0].status.type.state == "post",

                            let headline = game.competitions.first?.headlines?.first?.shortLinkText ?? game.competitions.first?.notes?.first?.headline ?? game.competitions.first?.highlights?.first?.headline
                        {
                            GeometryReader { geo in
                                HStack(alignment: .center, spacing: 10) {
                                    Capsule()
                                        .fill(.white)
                                        .frame(width: 3, height: 16)

                                    ZStack {
                                        let font = NSFont.systemFont(ofSize: 14, weight: .medium)
                                        let textWidth = (headline as NSString).size(withAttributes: [.font: font]).width

                                        if textWidth < geo.size.width {
                                            Text(headline)
                                                .font(.system(size: 14, weight: .medium))
                                                .fixedSize()
                                        } else {
                                            MarqueeText($headlineText,
                                                        font: .system(size: 14, weight: .medium),
                                                        nsFont: .body,
                                                        textColor: .white,
                                                        frameWidth: geo.size.width - 23)
                                                .onAppear {
                                                    headlineText = headline
                                                }
                                                .onChange(of: headline) { newText in
                                                    headlineText = newText
                                                }
                                        }
                                    }
                                }
                                .frame(minWidth: geo.size.width, alignment: .center)
                                .padding(.horizontal, 5)
                                .frame(height: 22)
                            }
                            .frame(height: 22)
                            .padding(.top, 10)
                        }

                        if game.competitions[0].status.type.state == "pre" {
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)

                                if let weather = game.weather {
                                    Text("\(game.competitions[0].venue?.address?.city ?? "-"), \(game.competitions[0].venue?.address?.state ?? "-")   \(weather.temperature ?? 0)°")
                                        .font(.system(size: 14, weight: .medium))
                                        .fixedSize()
                                } else {
                                    Text("\(game.competitions[0].venue?.fullName ?? "-")")
                                        .font(.system(size: 14, weight: .medium))
                                        .fixedSize()
                                }
                            }
                            .padding(.top, 3)
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

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
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if game.status.type.state == "in" {
                                        if let round = game.competitions[0].status.period {
                                            Text("R\(round)")
                                                .contentTransition(.numericText(countsDown: false))
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
                                        Text("#")
                                            .frame(width: 30, alignment: .leading)

                                        Text("Golfer")
                                            .frame(width: 150, alignment: .leading)

                                        Text("Score")
                                            .frame(width: 80, alignment: .trailing)
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
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let flagURLString = competitor.athlete?.flag?.href,
                                                           let flagURL = URL(string: flagURLString)
                                                        {
                                                            AsyncImage(url: flagURL) { phase in
                                                                if let image = phase.image {
                                                                    image
                                                                        .resizable()
                                                                        .interpolation(.high)
                                                                        .scaledToFit()
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                } else {
                                                                    Color.clear
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                }
                                                            }
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.athlete?.displayName ?? "-")
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }.frame(width: 150, alignment: .leading)

                                                    Text(competitor.score ?? "-")
                                                        .contentTransition(.numericText(countsDown: false))
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
                                        ) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .interpolation(.high)
                                                    .scaledToFit()
                                                    .transition(.opacity)
                                                    .frame(width: 28, height: 28)
                                            } else {
                                                Color.clear
                                                    .transition(.opacity)
                                                    .frame(width: 28, height: 28)
                                            }
                                        }
                                        .padding(.trailing, 3)

                                        Text("\(game.shortName ?? game.name)")
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let race = notchViewModel.racingCompetition {
            if sport == "F1" {
                let f1State = race.fullStatus.type.state

                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            if f1State == "in" || f1State == "post" {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                            "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                                        )
                                    ) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .interpolation(.high)
                                                .scaledToFit()
                                                .transition(.opacity)
                                                .frame(width: 25, height: 25)
                                        } else {
                                            Color.clear
                                                .transition(.opacity)
                                                .frame(width: 25, height: 25)
                                        }
                                    }
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if f1State == "in" {
                                        if let lap = race.fullStatus.period {
                                            HStack {
                                                Image(systemName: "flag.checkered")
                                                    .foregroundColor(mapFlagColor(race.fullStatus.flag))
                                                    .font(.system(size: 12))

                                                Text("Laps: \(lap)")
                                                    .contentTransition(.numericText(countsDown: false))
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }

                                    if f1State == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 12))

                                            Text(
                                                "\(race.competitors?.first(where: { $0.order == 1 })?.shortName ?? "-")"
                                            )
                                            .contentTransition(.numericText(countsDown: false))
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }

                                VStack(spacing: 5) {
                                    HStack {
                                        Text("#")
                                            .frame(width: 30, alignment: .leading)

                                        Text("Driver")
                                            .frame(width: 130, alignment: .leading)

                                        if f1State == "post" {
                                            Text("Race Time")
                                                .frame(width: 100, alignment: .trailing)
                                        } else {
                                            Text("Team")
                                                .frame(width: 120, alignment: .trailing)
                                        }

                                        Text("Laps")
                                            .frame(width: 50, alignment: .trailing)

                                        if race.competitionType?.text == "Race" {
                                            Text("Pits")
                                                .frame(width: 50, alignment: .trailing)
                                        }
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            let competitors = race.competitors ?? []

                                            ForEach(competitors.filter { $0.order != nil }, id: \.id) { competitor in
                                                HStack {
                                                    Text("\(competitor.order ?? 0)")
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let logoURL = URL(string: competitor.logo) {
                                                            AsyncImage(url: logoURL) { phase in
                                                                if let image = phase.image {
                                                                    image
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                } else {
                                                                    Color.clear
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                }
                                                            }
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.displayName)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                    .frame(width: 130, alignment: .leading)

                                                    if f1State == "post" {
                                                        if competitor.order == 1 {
                                                            Text(
                                                                "\(competitor.time ?? "-")"
                                                            )
                                                            .contentTransition(.numericText(countsDown: false))
                                                            .frame(width: 100, alignment: .trailing)
                                                        } else {
                                                            Text(
                                                                {
                                                                    if let behindTime = competitor.behindTime, !behindTime.starts(with: "+") {
                                                                        return "+\(behindTime)"
                                                                    } else if let behindTime = competitor.behindTime {
                                                                        return behindTime
                                                                    } else if let behindLaps = competitor.behindLaps, let lapsInt = Int(behindLaps) {
                                                                        return "+\(lapsInt) \(lapsInt == 1 ? "Lap" : "Laps")"
                                                                    } else if let behindLaps = competitor.behindLaps, !behindLaps.isEmpty {
                                                                        return "+\(behindLaps)"
                                                                    }
                                                                    return "+-"
                                                                }()
                                                            )
                                                            .frame(width: 100, alignment: .trailing)
                                                        }
                                                    } else {
                                                        Text(competitor.vehicle?.manufacturer ?? "-")
                                                            .frame(width: 120, alignment: .trailing)
                                                    }

                                                    Text(competitor.laps)
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 50, alignment: .trailing)

                                                    if race.competitionType?.text == "Race" {
                                                        Text(competitor.pitsTaken ?? "-")
                                                            .contentTransition(.numericText(countsDown: false))
                                                            .frame(width: 50, alignment: .trailing)
                                                    }
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

                            if f1State == "pre" {
                                VStack {
                                    HStack {
                                        AsyncImage(
                                            url: URL(
                                                string:
                                                "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
                                            )
                                        ) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .interpolation(.high)
                                                    .scaledToFit()
                                                    .transition(.opacity)
                                                    .frame(width: 28, height: 28)
                                            } else {
                                                Color.clear
                                                    .transition(.opacity)
                                                    .frame(width: 28, height: 28)
                                            }
                                        }
                                        .padding(.trailing, 3)

                                        Text("\(race.competitionType?.text ?? "Race") - \(formattedRaceTime(from: race.date))")
                                            .font(.system(size: 18, weight: .medium))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)

                                    VStack {
                                        HStack {
                                            Image(systemName: "location.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)

                                            Text("\(race.location ?? "Unknown")   \(race.track?.displayLength ?? "0 km")")
                                                .font(.system(size: 14, weight: .medium))
                                                .fixedSize()
                                        }
                                    }
                                    .padding(.top, 6)
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }

            if sport == "Racing" {
                let raceState = race.fullStatus.type.state

                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            if raceState == "in" || raceState == "post" {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
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
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("Leaders")
                                        .font(.system(size: 14, weight: .medium))

                                    Spacer()

                                    if raceState == "in" {
                                        if let lap = race.fullStatus.period {
                                            Text("L\(lap)")
                                                .contentTransition(.numericText(countsDown: false))
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 10)
                                        }
                                    }

                                    if raceState == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))

                                            Text(
                                                "\(race.competitors?.first(where: { $0.order == 1 })?.shortName ?? "-")"
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

                                        Text("Starting #")
                                            .frame(width: 100, alignment: .trailing)

                                        Text("Laps")
                                            .frame(width: 50, alignment: .trailing)

                                        if raceState == "post" {
                                            Text("Points")
                                                .frame(width: 50, alignment: .trailing)
                                        }
                                    }
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Divider()

                                    ScrollView(.vertical, showsIndicators: true) {
                                        VStack(spacing: 4) {
                                            let competitors = race.competitors ?? []

                                            ForEach(competitors.filter { $0.order != nil }, id: \.id) { competitor in
                                                HStack {
                                                    Text("\(competitor.order ?? 0)")
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 30, alignment: .leading)

                                                    HStack(spacing: 4) {
                                                        if let logoURL = URL(string: competitor.logo) {
                                                            AsyncImage(url: logoURL) { phase in
                                                                if let image = phase.image {
                                                                    image
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                } else {
                                                                    Color.clear
                                                                        .transition(.opacity)
                                                                        .frame(width: 16, height: 16)
                                                                }
                                                            }
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.displayName)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                    .frame(width: 160, alignment: .leading)

                                                    Text("\(competitor.startOrder ?? 0)")
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 100, alignment: .trailing)

                                                    Text("\(competitor.laps)")
                                                        .contentTransition(.numericText(countsDown: false))
                                                        .frame(width: 50, alignment: .trailing)

                                                    if raceState == "post" {
                                                        Text("\(competitor.score ?? "0")")
                                                            .contentTransition(.numericText(countsDown: false))
                                                            .frame(width: 50, alignment: .trailing)
                                                    }
                                                }
                                                .font(.system(size: 13))
                                                .padding(.horizontal, 10)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                .frame(maxHeight: 130)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            }

                            if raceState == "pre" {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
                                        )
                                    ) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .interpolation(.high)
                                                .scaledToFit()
                                                .transition(.opacity)
                                                .frame(width: 28, height: 28)
                                        } else {
                                            Color.clear
                                                .transition(.opacity)
                                                .frame(width: 28, height: 28)
                                        }
                                    }
                                    .padding(.trailing, 3)

                                    Text("\(race.shortName) - \(formattedRaceTime(from: race.date))")
                                        .font(.system(size: 18, weight: .medium))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)

                                HStack {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: 12))

                                    Text("\(race.location ?? "Unknown")")
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let tennisGame = notchViewModel.tennisCompetition {
            if sport == "Tennis" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-tennis.png&h=80&w=80&scale=crop&cquality=40"
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
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("\(tennisGame.round?.displayName ?? "Round 0")")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.trailing, 7)
                                }

                                Spacer()

                                HStack {
                                    if tennisGame.status?.type.state == "pre" {
                                        Text("\(formattedTime(from: tennisGame.date))")
                                            .contentTransition(.numericText(countsDown: false))
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 15)
                                    }

                                    if tennisGame.status?.type.state == "in" {
                                        if let set = tennisGame.status?.period {
                                            Text("S\(set)")
                                                .contentTransition(.numericText(countsDown: false))
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 15)
                                        }
                                    }

                                    if tennisGame.status?.type.state == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))
                                                .padding(.leading, 10)

                                            Text(
                                                tennisGame.competitors?
                                                    .first(where: { $0.winner == true })?
                                                    .athlete?.shortName
                                                    ?? tennisGame.competitors?
                                                    .first(where: { $0.winner == true })?
                                                    .roster?.shortDisplayName
                                                    ?? "Player 1"
                                            )
                                            .lineLimit(1)
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }

                            VStack(spacing: 5) {
                                Divider()

                                ScrollView(.vertical, showsIndicators: true) {
                                    VStack(spacing: 4) {
                                        if let competitors = tennisGame.competitors {
                                            ForEach(competitors) { competitor in
                                                HStack {
                                                    HStack(spacing: 4) {
                                                        if let flagURLString = competitor.athlete?.flag?.href ?? competitor.roster?.athletes?.first?.flag?.href,
                                                           let flagURL = URL(string: flagURLString)
                                                        {
                                                            AsyncImage(url: flagURL) { phase in
                                                                if let image = phase.image {
                                                                    image
                                                                        .resizable()
                                                                        .interpolation(.high)
                                                                        .scaledToFit()
                                                                        .transition(.opacity)
                                                                        .frame(width: 23, height: 23)
                                                                } else {
                                                                    Color.clear
                                                                        .transition(.opacity)
                                                                        .frame(width: 23, height: 23)
                                                                }
                                                            }
                                                            .padding(.trailing, 5)
                                                        }

                                                        Text(competitor.athlete?.fullName ?? competitor.roster?.shortDisplayName ?? "Player")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }

                                                    Spacer()

                                                    if let linescores = competitor.linescores {
                                                        HStack(spacing: 4) {
                                                            ForEach(linescores) { linescore in
                                                                Text("\(linescore.value ?? 0)  ")
                                                                    .frame(minWidth: 20)
                                                            }
                                                        }
                                                        .font(.system(size: 14, weight: .medium))
                                                        .contentTransition(.numericText(countsDown: false))
                                                    } else {
                                                        Text("0  ")
                                                            .frame(minWidth: 20)
                                                            .font(.system(size: 14, weight: .medium))
                                                            .contentTransition(.numericText(countsDown: false))
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 120)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

                    Button {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Text("Quit")
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        if let fight = notchViewModel.fightCompetition {
            if sport == "Fighting" {
                VStack {
                    HStack(spacing: 4) {
                        VStack {
                            HStack {
                                HStack {
                                    AsyncImage(
                                        url: URL(
                                            string:
                                            "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-mma.png&w=64&h=64&scale=crop&cquality=40&location=origin"
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
                                    .padding(.trailing, 3)
                                    .padding(.leading, 10)

                                    Text("\(fight.type.abbreviation ?? "Event")")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.trailing, 7)
                                }

                                Spacer()

                                HStack {
                                    if fight.status.type.state == "pre" {
                                        Text("\(formattedTime(from: fight.date))")
                                            .contentTransition(.numericText(countsDown: false))
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 15)
                                    }

                                    if fight.status.type.state == "in" {
                                        if let round = fight.status.period {
                                            let displayClock = fight.status.displayClock ?? "-"

                                            Text("R\(round) \(displayClock)")
                                                .contentTransition(.numericText(countsDown: false))
                                                .font(.system(size: 14, weight: .semibold))
                                                .padding(.trailing, 15)
                                        }
                                    }

                                    if fight.status.type.state == "post" {
                                        HStack {
                                            Image(systemName: "trophy.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))
                                                .padding(.leading, 10)

                                            Text(
                                                fight.competitors?.first(where: { $0.winner == true })?.athlete?.shortName ?? "Player 1"
                                            )
                                            .lineLimit(1)
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }

                            VStack(spacing: 5) {
                                Divider()
                            }
                            .frame(maxHeight: 120)
                            .padding(.top, 10)
                            .padding(.bottom, 5)
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

                    Button {
                        SettingsWindowController.shared.showWindow()
                    } label: {
                        Text("Preferences")
                    }
                    .keyboardShortcut(",")

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
