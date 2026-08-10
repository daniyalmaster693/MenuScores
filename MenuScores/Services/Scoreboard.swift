//
//  Scoreboard.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

enum Scoreboard {
    enum Urls {
        static let nhl: () -> URL = {
            URL(
                string: "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let hncaam: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/hockey/mens-college-hockey/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let hncaaf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/hockey/womens-college-hockey/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let nba: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let wnba: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let ncaam: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-college-basketball/scoreboard"
            )!
        }

        static let ncaaf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/womens-college-basketball/scoreboard"
            )!
        }

        static let nfl: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let fncaa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let mlb: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let bncaa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/baseball/college-baseball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let sncaa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/baseball/college-softball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let f1: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/racing/f1/scoreboard?dates=\(getCurrentYear())"
            )!
        }

        static let nc: () -> URL = {
            URL(
                string:
                "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=nascar-premier"
            )!
        }

        static let ncs: () -> URL = {
            URL(
                string:
                "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=nascar-secondary"
            )!
        }

        static let nct: () -> URL = {
            URL(
                string:
                "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=nascar-truck"
            )!
        }

        static let irl: () -> URL = {
            URL(
                string:
                "https://site.web.api.espn.com/apis/personalized/v2/scoreboard/header?sport=racing&league=irl"
            )!
        }

        static let pga: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/golf/pga/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let lpga: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/golf/lpga/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let uefa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.champions/scoreboard"
            )!
        }

        static let euefa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.europa/scoreboard"
            )!
        }

        static let wuefa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
            )!
        }

        static let mls: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.1/scoreboard"
            )!
        }

        static let nwsl: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/USA.NWSL/scoreboard"
            )!
        }

        static let mex: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/MEX.1/scoreboard"
            )!
        }

        static let fra: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/FRA.1/scoreboard"
            )!
        }

        static let ned: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/NED.1/scoreboard"
            )!
        }

        static let por: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/POR.1/scoreboard"
            )!
        }

        static let epl: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/ENG.1/scoreboard"
            )!
        }

        static let wepl: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/uefa.wchampions/scoreboard"
            )!
        }

        static let esp: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/ESP.1/scoreboard"
            )!
        }

        static let ger: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/GER.1/scoreboard"
            )!
        }

        static let ita: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/ITA.1/scoreboard"
            )!
        }

        static let atp: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/tennis/atp/scoreboard"
            )!
        }

        static let wta: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/tennis/wta/scoreboard"
            )!
        }

//        static let ufc = URL(
//            string:
//            "https://site.api.espn.com/apis/site/v2/sports/mma/ufc/scoreboard"
//        )!

        static let nll: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/lacrosse/nll/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let pll: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/lacrosse/pll/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let lncaam: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/lacrosse/mens-college-lacrosse/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let lncaaf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/lacrosse/womens-college-lacrosse/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let vncaam: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/volleyball/mens-college-volleyball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let vncaaf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/volleyball/womens-college-volleyball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let omihc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/hockey/olympics-mens-ice-hockey/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let owihc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/hockey/olympics-womens-ice-hockey/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let omb: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-olympics-basketball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let owb: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/basketball/mens-olympics-basketball/scoreboard?dates=\(getRangeStart())-\(getRangeEnd())"
            )!
        }

        static let ffwc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.world/scoreboard"
            )!
        }

        static let ffwwc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.wwc/scoreboard"
            )!
        }

        static let ffwcquefa: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.uefa/scoreboard"
            )!
        }

        static let concacaf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.concacaf/scoreboard"
            )!
        }

        static let caf: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.caf/scoreboard"
            )!
        }

        static let conmebol: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.conmebol/scoreboard"
            )!
        }

        static let afc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.afc/scoreboard"
            )!
        }

        static let ofc: () -> URL = {
            URL(
                string:
                "https://site.api.espn.com/apis/site/v2/sports/soccer/fifa.worldq.ofc/scoreboard"
            )!
        }
    }
}
