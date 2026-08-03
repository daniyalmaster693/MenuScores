//
//  FavoriteTeamAPI.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-29.
//

import Foundation

enum FavoriteTeams {
    struct LeagueInfo {
        let sport: String
        let league: String
        let displayName: String
    }

    static let mappings: [String: LeagueInfo] = [
        "NHL": LeagueInfo(sport: "hockey", league: "nhl", displayName: "NHL"),
        "HNCAAM": LeagueInfo(sport: "hockey", league: "mens-college-hockey", displayName: "NCAA M Hockey"),
        "HNCAAF": LeagueInfo(sport: "hockey", league: "womens-college-hockey", displayName: "NCAA F Hockey"),

        "NBA": LeagueInfo(sport: "basketball", league: "nba", displayName: "NBA"),
        "WNBA": LeagueInfo(sport: "basketball", league: "wnba", displayName: "WNBA"),

        "NFL": LeagueInfo(sport: "football", league: "nfl", displayName: "NFL"),
        "FNCAA": LeagueInfo(sport: "football", league: "college-football", displayName: "NCAA Football"),

        "MLB": LeagueInfo(sport: "baseball", league: "mlb", displayName: "MLB"),
        "BNCAA": LeagueInfo(sport: "baseball", league: "college-baseball", displayName: "NCAA Baseball"),
        "SNCAA": LeagueInfo(sport: "baseball", league: "college-softball", displayName: "NCAA Softball"),

        "MLS": LeagueInfo(sport: "soccer", league: "usa.1", displayName: "MLS"),
        "NWSL": LeagueInfo(sport: "soccer", league: "usa.nwsl", displayName: "NWSL"),
        "UEFA": LeagueInfo(sport: "soccer", league: "uefa.champions", displayName: "Champions League"),
        "EUEFA": LeagueInfo(sport: "soccer", league: "uefa.europa", displayName: "Europa League"),
        "WUEFA": LeagueInfo(sport: "soccer", league: "uefa.wchampions", displayName: "Women's Champions League"),
        "EPL": LeagueInfo(sport: "soccer", league: "eng.1", displayName: "Premier League"),
        "WEPL": LeagueInfo(sport: "soccer", league: "eng.w.1", displayName: "Women's Super League"),
        "ESP": LeagueInfo(sport: "soccer", league: "esp.1", displayName: "La Liga"),
        "GER": LeagueInfo(sport: "soccer", league: "ger.1", displayName: "Bundesliga"),
        "ITA": LeagueInfo(sport: "soccer", league: "ita.1", displayName: "Serie A"),
        "FRA": LeagueInfo(sport: "soccer", league: "fra.1", displayName: "Ligue 1"),
        "NED": LeagueInfo(sport: "soccer", league: "ned.1", displayName: "Eredivisie"),
        "POR": LeagueInfo(sport: "soccer", league: "por.1", displayName: "Primeira Liga"),
        "MEX": LeagueInfo(sport: "soccer", league: "mex.1", displayName: "Liga MX"),

        "F1": LeagueInfo(sport: "racing", league: "f1", displayName: "F1"),
        "NC": LeagueInfo(sport: "racing", league: "nc", displayName: "Nascar Premier"),
        "NCS": LeagueInfo(sport: "racing", league: "ncs", displayName: "Nascar Secondary"),
        "NCT": LeagueInfo(sport: "racing", league: "nct", displayName: "Nascar Truck"),
        "IRL": LeagueInfo(sport: "racing", league: "irl", displayName: "IndyCar"),

        "PGA": LeagueInfo(sport: "golf", league: "pga", displayName: "PGA"),
        "LPGA": LeagueInfo(sport: "golf", league: "lpga", displayName: "LPGA"),

        "NLL": LeagueInfo(sport: "lacrosse", league: "nll", displayName: "NLL"),
        "PLL": LeagueInfo(sport: "lacrosse", league: "pll", displayName: "PLL"),
        "LNCAAM": LeagueInfo(sport: "lacrosse", league: "mens-college-lacrosse", displayName: "NCAA M Lacrosse"),
        "LNCAAF": LeagueInfo(sport: "lacrosse", league: "womens-college-lacrosse", displayName: "NCAA F Lacrosse"),

        "VNCAAM": LeagueInfo(sport: "volleyball", league: "mens-college-volleyball", displayName: "NCAA M Volleyball"),
        "VNCAAF": LeagueInfo(sport: "volleyball", league: "womens-college-volleyball", displayName: "NCAA F Volleyball"),

        "OMIHC": LeagueInfo(sport: "hockey", league: "olympics-mens-ice-hockey", displayName: "Men's Olympic Hockey"),
        "OWIHC": LeagueInfo(sport: "hockey", league: "olympics-womens-ice-hockey", displayName: "Women's Olympic Hockey"),
        "NCAA M": LeagueInfo(sport: "basketball", league: "mens-college-basketball", displayName: "NCAA M Basketball"),
        "NCAA F": LeagueInfo(sport: "basketball", league: "womens-college-basketball", displayName: "NCAA F Basketball"),

        "FFWC": LeagueInfo(sport: "soccer", league: "fifa.world", displayName: "FIFA World Cup"),
        "FFWWC": LeagueInfo(sport: "soccer", league: "fifa.wwc", displayName: "FIFA Women's World Cup"),
        "FFWCQUEFA": LeagueInfo(sport: "soccer", league: "fifa.worldq.uefa", displayName: "FIFA WC UEFA Qualifiers"),
        "CONMEBOL": LeagueInfo(sport: "soccer", league: "fifa.worldq.conmebol", displayName: "FIFA WC CONMEBOL Qualifiers"),
        "CONCACAF": LeagueInfo(sport: "soccer", league: "fifa.worldq.concacaf", displayName: "FIFA WC CONCACAF Qualifiers"),
        "CAF": LeagueInfo(sport: "soccer", league: "fifa.worldq.caf", displayName: "FIFA WC African Qualifiers"),
        "AFC": LeagueInfo(sport: "soccer", league: "fifa.worldq.afc", displayName: "FIFA WC Asian Qualifiers"),
        "OFC": LeagueInfo(sport: "soccer", league: "fifa.worldq.ofc", displayName: "FIFA WC Oceanian Qualifiers"),
    ]

    static func teamsUrl(for leagueKey: String) -> URL? {
        guard let info = mappings[leagueKey] else { return nil }
        return URL(string: "https://site.api.espn.com/apis/site/v2/sports/\(info.sport)/\(info.league)/teams")
    }

    static func displayName(for leagueKey: String) -> String {
        mappings[leagueKey]?.displayName ?? leagueKey
    }

    static func isLeagueOnly(_ leagueKey: String) -> Bool {
        guard let info = mappings[leagueKey] else { return false }
        return info.sport == "racing" || info.sport == "golf"
    }

    static func leagueAsTeam(for leagueKey: String) -> TeamInfo {
        let info = mappings[leagueKey]
        let displayName = info?.displayName ?? leagueKey
        let sport = mappings[leagueKey]?.sport ?? "hockey"
        let logo = fallbackLogoForLeague(leagueKey)

        return TeamInfo(
            id: "league-\(leagueKey.lowercased())",
            color: nil,
            alternateColor: nil,
            displayName: displayName,
            abbreviation: leagueKey,
            logos: [TeamLogo(href: logo, width: 80, height: 80)]
        )
    }

    static func fallbackLogoForLeague(_ leagueKey: String) -> String {
        let sport = (FavoriteTeams.mappings[leagueKey]?.sport ?? "hockey")
        let league = (FavoriteTeams.mappings[leagueKey]?.league ?? "NHL")

        if sport == "racing" && league == "f1" {
            return "https://a.espncdn.com/combiner/i?img=/i/teamlogos/leagues/500/f1.png&w=100&h=100&transparent=true"
        } else if sport == "racing" && league != "f1" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-nascar.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "golf" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-golf.png&h=80&w=80&scale=crop&cquality=40"
        } else if sport == "volleyball" {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-all-sports-college.png&w=64&h=64&scale=crop&cquality=40&location=origin"
        } else {
            return "https://a.espncdn.com/combiner/i?img=/redesign/assets/img/icons/ESPN-icon-\(sport).png&h=80&w=80&scale=crop&cquality=40"
        }
    }

    static var supportedLeagueKeys: [String] {
        let defaults = UserDefaults.standard

        return mappings.keys.filter { league in
            switch league {
            case "NHL": return defaults.bool(forKey: "enableNHL")
            case "HNCAAM": return defaults.bool(forKey: "enableHNCAAM")
            case "HNCAAF": return defaults.bool(forKey: "enableHNCAAF")
            case "NBA": return defaults.bool(forKey: "enableNBA")
            case "WNBA": return defaults.bool(forKey: "enableWNBA")
            case "NFL": return defaults.bool(forKey: "enableNFL")
            case "FNCAA": return defaults.bool(forKey: "enableFNCAA")
            case "MLB": return defaults.bool(forKey: "enableMLB")
            case "BNCAA": return defaults.bool(forKey: "enableBNCAA")
            case "SNCAA": return defaults.bool(forKey: "enableSNCAA")
            case "F1": return defaults.bool(forKey: "enableF1")
            case "NC": return defaults.bool(forKey: "enableNC")
            case "NCS": return defaults.bool(forKey: "enableNCS")
            case "NCT": return defaults.bool(forKey: "enableNCT")
            case "IRL": return defaults.bool(forKey: "enableIRL")
            case "PGA": return defaults.bool(forKey: "enablePGA")
            case "LPGA": return defaults.bool(forKey: "enableLPGA")
            case "MLS": return defaults.bool(forKey: "enableMLS")
            case "NWSL": return defaults.bool(forKey: "enableNWSL")
            case "UEFA": return defaults.bool(forKey: "enableUEFA")
            case "EUEFA": return defaults.bool(forKey: "enableEUEFA")
            case "WUEFA": return defaults.bool(forKey: "enableWUEFA")
            case "EPL": return defaults.bool(forKey: "enableEPL")
            case "WEPL": return defaults.bool(forKey: "enableWEPL")
            case "ESP": return defaults.bool(forKey: "enableESP")
            case "GER": return defaults.bool(forKey: "enableGER")
            case "ITA": return defaults.bool(forKey: "enableITA")
            case "FRA": return defaults.bool(forKey: "enableFRA")
            case "NED": return defaults.bool(forKey: "enableNED")
            case "POR": return defaults.bool(forKey: "enablePOR")
            case "MEX": return defaults.bool(forKey: "enableMEX")
            case "NLL": return defaults.bool(forKey: "enableNLL")
            case "PLL": return defaults.bool(forKey: "enablePLL")
            case "LNCAAM": return defaults.bool(forKey: "enableLNCAAM")
            case "LNCAAF": return defaults.bool(forKey: "enableLNCAAF")
            case "VNCAAM": return defaults.bool(forKey: "enableVNCAAM")
            case "VNCAAF": return defaults.bool(forKey: "enableVNCAAF")
            case "OMIHC": return defaults.bool(forKey: "enableOMIHC")
            case "OWIHC": return defaults.bool(forKey: "enableOWIHC")
            case "NCAA M": return defaults.bool(forKey: "enableNCAAM")
            case "NCAA F": return defaults.bool(forKey: "enableNCAAF")
            case "FFWC": return defaults.bool(forKey: "enableFFWC")
            case "FFWWC": return defaults.bool(forKey: "enableFFWWC")
            case "FFWCQUEFA": return defaults.bool(forKey: "enableFFWCQUEFA")
            case "CONMEBOL": return defaults.bool(forKey: "enableCONMEBOL")
            case "CONCACAF": return defaults.bool(forKey: "enableCONCACAF")
            case "CAF": return defaults.bool(forKey: "enableCAF")
            case "AFC": return defaults.bool(forKey: "enableAFC")
            case "OFC": return defaults.bool(forKey: "enableOFC")
            default: return false
            }
        }
        .sorted()
    }

    static func supportsTeams(_ leagueKey: String) -> Bool {
        mappings[leagueKey] != nil
    }
}
