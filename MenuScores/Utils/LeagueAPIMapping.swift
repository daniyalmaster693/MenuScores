//
//  LeagueAPIMapping.swift
//  MenuScores
//
//  Created by Claude on 2025-02-24.
//

import Foundation

// MARK: - League API Mapping

/// Maps league keys to ESPN API sport/league paths for team fetching
/// Only includes team sports (excludes Tennis, Golf, UFC, Racing)
enum LeagueAPIMapping {

    struct LeagueInfo {
        let sport: String
        let league: String
        let displayName: String
    }

    static let mappings: [String: LeagueInfo] = [
        // Hockey
        "NHL": LeagueInfo(sport: "hockey", league: "nhl", displayName: "NHL"),
        "HNCAAM": LeagueInfo(sport: "hockey", league: "mens-college-hockey", displayName: "NCAA M Hockey"),
        "HNCAAF": LeagueInfo(sport: "hockey", league: "womens-college-hockey", displayName: "NCAA F Hockey"),
        "OMIHC": LeagueInfo(sport: "hockey", league: "olympics-mens-ice-hockey", displayName: "Men's Olympic Hockey"),
        "OWIHC": LeagueInfo(sport: "hockey", league: "olympics-womens-ice-hockey", displayName: "Women's Olympic Hockey"),

        // Basketball
        "NBA": LeagueInfo(sport: "basketball", league: "nba", displayName: "NBA"),
        "WNBA": LeagueInfo(sport: "basketball", league: "wnba", displayName: "WNBA"),
        "NCAA M": LeagueInfo(sport: "basketball", league: "mens-college-basketball", displayName: "NCAA M Basketball"),
        "NCAA F": LeagueInfo(sport: "basketball", league: "womens-college-basketball", displayName: "NCAA F Basketball"),

        // Football
        "NFL": LeagueInfo(sport: "football", league: "nfl", displayName: "NFL"),
        "FNCAA": LeagueInfo(sport: "football", league: "college-football", displayName: "NCAA Football"),

        // Baseball
        "MLB": LeagueInfo(sport: "baseball", league: "mlb", displayName: "MLB"),
        "BNCAA": LeagueInfo(sport: "baseball", league: "college-baseball", displayName: "NCAA Baseball"),
        "SNCAA": LeagueInfo(sport: "baseball", league: "college-softball", displayName: "NCAA Softball"),

        // Soccer - US
        "MLS": LeagueInfo(sport: "soccer", league: "usa.1", displayName: "MLS"),
        "NWSL": LeagueInfo(sport: "soccer", league: "usa.nwsl", displayName: "NWSL"),

        // Soccer - UEFA
        "UEFA": LeagueInfo(sport: "soccer", league: "uefa.champions", displayName: "Champions League"),
        "EUEFA": LeagueInfo(sport: "soccer", league: "uefa.europa", displayName: "Europa League"),
        "WUEFA": LeagueInfo(sport: "soccer", league: "uefa.wchampions", displayName: "Women's Champions League"),

        // Soccer - Europe
        "EPL": LeagueInfo(sport: "soccer", league: "eng.1", displayName: "Premier League"),
        "wepl": LeagueInfo(sport: "soccer", league: "eng.w.1", displayName: "Women's Super League"),
        "ESP": LeagueInfo(sport: "soccer", league: "esp.1", displayName: "La Liga"),
        "GER": LeagueInfo(sport: "soccer", league: "ger.1", displayName: "Bundesliga"),
        "ITA": LeagueInfo(sport: "soccer", league: "ita.1", displayName: "Serie A"),
        "FRA": LeagueInfo(sport: "soccer", league: "fra.1", displayName: "Ligue 1"),
        "NED": LeagueInfo(sport: "soccer", league: "ned.1", displayName: "Eredivisie"),
        "POR": LeagueInfo(sport: "soccer", league: "por.1", displayName: "Primeira Liga"),
        "MEX": LeagueInfo(sport: "soccer", league: "mex.1", displayName: "Liga MX"),

        // Soccer - FIFA
        "FFWC": LeagueInfo(sport: "soccer", league: "fifa.world", displayName: "FIFA World Cup"),
        "FFWWC": LeagueInfo(sport: "soccer", league: "fifa.wwc", displayName: "FIFA Women's World Cup"),
        "FFWCQUEFA": LeagueInfo(sport: "soccer", league: "fifa.worldq.uefa", displayName: "FIFA WC UEFA Qualifiers"),
        "CONMEBOL": LeagueInfo(sport: "soccer", league: "fifa.worldq.conmebol", displayName: "FIFA WC CONMEBOL Qualifiers"),
        "CONCACAF": LeagueInfo(sport: "soccer", league: "fifa.worldq.concacaf", displayName: "FIFA WC CONCACAF Qualifiers"),
        "CAF": LeagueInfo(sport: "soccer", league: "fifa.worldq.caf", displayName: "FIFA WC African Qualifiers"),
        "AFC": LeagueInfo(sport: "soccer", league: "fifa.worldq.afc", displayName: "FIFA WC Asian Qualifiers"),
        "OFC": LeagueInfo(sport: "soccer", league: "fifa.worldq.ofc", displayName: "FIFA WC Oceanian Qualifiers"),

        // Lacrosse
        "NLL": LeagueInfo(sport: "lacrosse", league: "nll", displayName: "NLL"),
        "PLL": LeagueInfo(sport: "lacrosse", league: "pll", displayName: "PLL"),
        "LNCAAM": LeagueInfo(sport: "lacrosse", league: "mens-college-lacrosse", displayName: "NCAA M Lacrosse"),
        "LNCAAF": LeagueInfo(sport: "lacrosse", league: "womens-college-lacrosse", displayName: "NCAA F Lacrosse"),

        // Volleyball
        "VNCAAM": LeagueInfo(sport: "volleyball", league: "mens-college-volleyball", displayName: "NCAA M Volleyball"),
        "VNCAAF": LeagueInfo(sport: "volleyball", league: "womens-college-volleyball", displayName: "NCAA F Volleyball"),
    ]

    /// Get the teams API URL for a given league key
    static func teamsUrl(for leagueKey: String) -> URL? {
        guard let info = mappings[leagueKey] else { return nil }
        return URL(string: "https://site.api.espn.com/apis/site/v2/sports/\(info.sport)/\(info.league)/teams")
    }

    /// Get display name for a league key
    static func displayName(for leagueKey: String) -> String {
        mappings[leagueKey]?.displayName ?? leagueKey
    }

    /// All league keys that support favorites (team sports only)
    static var supportedLeagueKeys: [String] {
        Array(mappings.keys).sorted()
    }

    /// Check if a league supports favorites
    static func supportsTeams(_ leagueKey: String) -> Bool {
        mappings[leagueKey] != nil
    }
}
