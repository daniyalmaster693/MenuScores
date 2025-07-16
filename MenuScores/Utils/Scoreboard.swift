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
        static let hncaam = URL(string: "https://site.api.espn.com/apis/site/v2/sports/hockey/mens-college-hockey/scoreboard")!
        static let hncaaf = URL(string: "https://site.api.espn.com/apis/site/v2/sports/hockey/womens-college-hockey/scoreboard")!
        static let nba = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard")!
        static let wnba = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard")!
        static let ncaam = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-college-basketball/scoreboard")!
        static let ncaaf = URL(string: "https://site.api.espn.com/apis/site/v2/sports/basketball/womens-college-basketball/scoreboard")!
        static let nfl = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard")!
        static let ncaa = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard")!
        static let mlb = URL(string: "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard")!
        static let f1 = URL(string: "https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard")!
        static let pga = URL(string: "https://site.api.espn.com/apis/site/v2/sports/golf/pga/scoreboard")!
        static let lpga = URL(string: "https://site.api.espn.com/apis/site/v2/sports/golf/lpga/scoreboard")!
        static let uefa = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.champions/scoreboard")!
        static let epl = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/ENG.1/scoreboard")!
        static let esp = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/ESP.1/scoreboard")!
        static let ger = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/GER.1/scoreboard")!
        static let ita = URL(string: "https://site.api.espn.com/apis/site/v2/sports/soccer/ITA.1/scoreboard")!
        static let nll = URL(string: "https://site.api.espn.com/apis/site/v2/sports/lacrosse/nll/scoreboard")!
    }
}
