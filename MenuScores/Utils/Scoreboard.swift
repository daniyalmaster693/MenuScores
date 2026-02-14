//
//  scoreboard.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

// F1 Calendar Year

var currentYear: Int {
    Calendar.current.component(.year, from: Date())
}

let range = getDynamicRange()

enum Scoreboard {
    enum Urls {
        static var nhl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var hncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/mens-college-hockey/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var hncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/womens-college-hockey/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var nba = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var wnba = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var ncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-college-basketball/scoreboard"
        )!
        static var ncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/basketball/womens-college-basketball/scoreboard"
        )!

        static var nfl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var fncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var mlb = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var bncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/college-baseball/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var sncaa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/baseball/college-softball/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var f1 = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard?dates=\(currentYear)"
        )!
        static var nc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-premier/scoreboard"
        )!
        static var ncs = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-secondary/scoreboard"
        )!
        static var nct = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/nascar-truck/scoreboard"
        )!
        static var irl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/racing/irl/scoreboard"
        )!

        static var pga = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/golf/pga/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var lpga = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/golf/lpga/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var uefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.champions/scoreboard"
        )!
        static var euefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.europa/scoreboard"
        )!
        static var wuefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
        )!
        static var mls = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.1/scoreboard"
        )!
        static var nwsl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.NWSL/scoreboard"
        )!
        static var mex = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/MEX.1/scoreboard"
        )!
        static var fra = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/FRA.1/scoreboard"
        )!
        static var ned = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/NED.1/scoreboard"
        )!
        static var por = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/POR.1/scoreboard"
        )!
        static var epl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ENG.1/scoreboard"
        )!
        static var wepl = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
        )!
        static var esp = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ESP.1/scoreboard"
        )!
        static var ger = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/GER.1/scoreboard"
        )!
        static var ita = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/ITA.1/scoreboard"
        )!

        static var ffwc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard"
        )!
        static var ffwwc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.wwc/scoreboard"
        )!
        static var ffwcquefa = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.uefa/scoreboard"
        )!
        static var concacaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.concacaf/scoreboard"
        )!
        static var caf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.caf/scoreboard"
        )!
        static var conmebol = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.conmebol/scoreboard"
        )!
        static var afc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.afc/scoreboard"
        )!
        static var ofc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.ofc/scoreboard"
        )!

        static var atp = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/tennis/atp/scoreboard"
        )!
        static var wta = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/tennis/wta/scoreboard"
        )!

        static var ufc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/mma/ufc/scoreboard"
        )!

        static var nll = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/nll/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var pll = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/pll/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var lncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/mens-college-lacrosse/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var lncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/lacrosse/womens-college-lacrosse/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var vncaam = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/volleyball/mens-college-volleyball/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var vncaaf = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/volleyball/womens-college-volleyball/scoreboard?dates=\(range.start)-\(range.end)"
        )!

        static var omihc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/olympics-mens-ice-hockey/scoreboard?dates=\(range.start)-\(range.end)"
        )!
        static var owihc = URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/olympics-womens-ice-hockey/scoreboard?dates=\(range.start)-\(range.end)"
        )!
    }
}
