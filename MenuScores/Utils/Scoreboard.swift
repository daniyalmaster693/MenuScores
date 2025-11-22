//
//  scoreboard.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

// F1 Calendar Year

let currentYear = Calendar.current.component(.year, from: Date())

enum Scoreboard {
    enum Urls {
        static let nhl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let hncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/mens-college-hockey/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let hncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/womens-college-hockey/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let nba = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let wnba = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let ncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-college-basketball/scoreboard"
        )!
        static let ncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/womens-college-basketball/scoreboard"
        )!

        static let nfl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let fncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let mlb = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let bncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/college-baseball/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let sncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/college-softball/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let f1 = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard?dates=\(currentYear)"
        )!
        static let nc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-premier/scoreboard"
        )!
        static let ncs = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-secondary/scoreboard"
        )!
        static let nct = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-truck/scoreboard"
        )!
        static let irl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/irl/scoreboard"
        )!

        static let pga = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/golf/pga/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let lpga = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/golf/lpga/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let uefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.champions/scoreboard"
        )!
        static let euefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.europa/scoreboard"
        )!
        static let wuefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
        )!
        static let mls = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.1/scoreboard"
        )!
        static let nwsl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.NWSL/scoreboard"
        )!
        static let mex = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/MEX.1/scoreboard"
        )!
        static let fra = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/FRA.1/scoreboard"
        )!
        static let ned = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/NED.1/scoreboard"
        )!
        static let por = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/POR.1/scoreboard"
        )!
        static let epl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ENG.1/scoreboard"
        )!
        static let wepl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
        )!
        static let esp = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ESP.1/scoreboard"
        )!
        static let ger = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/GER.1/scoreboard"
        )!
        static let ita = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ITA.1/scoreboard"
        )!

        static let ffwc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard"
        )!
        static let ffwwc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.wwc/scoreboard"
        )!
        static let ffwcquefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.uefa/scoreboard"
        )!
        static let concacaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.concacaf/scoreboard"
        )!
        static let caf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.caf/scoreboard"
        )!
        static let conmebol = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.conmebol/scoreboard"
        )!
        static let afc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.afc/scoreboard"
        )!
        static let ofc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.ofc/scoreboard"
        )!

        static let atp = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/atp/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let wta = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/wta/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let nll = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/nll/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let pll = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/pll/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let lncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/mens-college-lacrosse/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let lncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/womens-college-lacrosse/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!

        static let vncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/volleyball/mens-college-volleyball/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
        static let vncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/volleyball/womens-college-volleyball/scoreboard?dates=\(getWeekStart())-\(getWeekEnd())"
        )!
    }
}
