//
//  scoreboard.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

struct Scoreboard {
    struct Urls {
        static let nhl = URL(string: "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/scoreboard")!
        static let nba = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard")!
        static let wnba = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard")!
        static let ncaam = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-college-basketball/scoreboard")!
        static let ncaaf = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/womens-college-basketball/scoreboard")!
        static let nfl = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard")!
        static let mlb = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard")!
        static let uefa = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.champions/scoreboard")!
        static let epl = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/ENG.1/scoreboard")!
        static let nll = URL(string: "https://site.api.espn.com/apis/site/v2/sports/lacrosse/nll/scoreboard")!
    }
}
