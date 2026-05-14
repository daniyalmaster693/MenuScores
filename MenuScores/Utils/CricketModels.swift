//
//  CricketModels.swift
//  MenuScores
//

import Foundation

// MARK: - CricAPI Response

struct CricAPIListResponse: Decodable {
    let data: [CricAPIMatch]?
    let status: String
}

struct CricAPISingleResponse: Decodable {
    let data: CricAPIMatch?
    let status: String
}

// MARK: - Match

struct CricAPIMatch: Decodable, Identifiable {
    let id: String
    let name: String
    let matchType: String?
    let status: String?
    let venue: String?
    let date: String?
    let dateTimeGMT: String?
    let teams: [String]?
    let teamInfo: [CricAPITeamInfo]?
    let score: [CricAPIScore]?
    let seriesId: String?
    let matchStarted: Bool?
    let matchEnded: Bool?

    var team1Name: String { teams?.first ?? "Team 1" }
    var team2Name: String { teams?.dropFirst().first ?? "Team 2" }

    var team1Short: String {
        teamInfo?.first?.shortname
            ?? teams?.first.map { String($0.prefix(3)).uppercased() }
            ?? "T1"
    }
    var team2Short: String {
        teamInfo?.dropFirst().first?.shortname
            ?? teams?.dropFirst().first.map { String($0.prefix(3)).uppercased() }
            ?? "T2"
    }

    var team1Logo: URL? { teamInfo?.first?.img.flatMap { URL(string: $0) } }
    var team2Logo: URL? { teamInfo?.dropFirst().first?.img.flatMap { URL(string: $0) } }

    var isLive: Bool { matchStarted == true && matchEnded != true }
    var hasScores: Bool { !(score?.isEmpty ?? true) }

    var score1Text: String { scoreText(for: team1Name, compact: false) }
    var score2Text: String { scoreText(for: team2Name, compact: false) }
    var score1Compact: String { scoreText(for: team1Name, compact: true) }
    var score2Compact: String { scoreText(for: team2Name, compact: true) }

    private func scoreText(for teamName: String, compact: Bool) -> String {
        guard let innings = score?.first(where: { $0.inning?.hasPrefix(teamName) == true }) else {
            return "-"
        }
        let runs = innings.r ?? 0
        let wickets = innings.w ?? 10
        if compact {
            return "\(runs)/\(wickets)"
        }
        let overs = innings.o.map { String(format: "%.1f", $0) } ?? "0"
        return "\(runs)/\(wickets) (\(overs) Ov)"
    }

    var startDateFormatted: String {
        guard let dateStr = dateTimeGMT else { return date ?? "-" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        let withZ = dateStr.hasSuffix("Z") ? dateStr : dateStr + "Z"
        if let d = iso.date(from: withZ) {
            let fmt = DateFormatter()
            fmt.dateFormat = "MMM d, h:mm a"
            fmt.timeZone = TimeZone.current
            return fmt.string(from: d)
        }
        return date ?? dateStr
    }

    // Seconds since epoch, used for sorting
    var startTimestamp: TimeInterval {
        guard let dateStr = dateTimeGMT else { return 0 }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        let withZ = dateStr.hasSuffix("Z") ? dateStr : dateStr + "Z"
        return iso.date(from: withZ)?.timeIntervalSince1970 ?? 0
    }
}

struct CricAPITeamInfo: Decodable {
    let name: String
    let shortname: String?
    let img: String?
}

struct CricAPIScore: Decodable {
    let r: Int?
    let w: Int?
    let o: Double?
    let inning: String?
}
