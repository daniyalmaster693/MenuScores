//
//  PeriodType.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-10.
//

import SwiftUI

func periodPrefix(for league: String) -> String {
    switch league {
    case "NHL":
        return "P"
    case "HNCAAM":
        return "P"
    case "HNCAAF":
        return "P"
    case "NBA":
        return "Q"
    case "WNBA":
        return "Q"
    case "NCAA M":
        return "Q"
    case "NCAA F":
        return "Q"
    case "NFL":
        return "Q"
    case "FNCAA":
        return "Q"
    case "MLB":
        return ""
    case "BNCAA":
        return ""
    case "SNCAA":
        return ""
    case "MLS":
        return ""
    case "NWSL":
        return ""
    case "UEFA":
        return ""
    case "EUEFA":
        return ""
    case "FUEFA":
        return ""
    case "EPL":
        return ""
    case "WEPL":
        return ""
    case "ESP":
        return ""
    case "GER":
        return ""
    case "ITA":
        return ""
    case "MEX":
        return ""
    case "FRA":
        return ""
    case "NED":
        return ""
    case "POR":
        return ""
    case "FFWC":
        return ""
    case "FFWWC":
        return ""
    case "FFWCQUEFA":
        return ""
    case "CONMEBOL":
        return ""
    case "CONCACAF":
        return ""
    case "CAF":
        return ""
    case "AFC":
        return ""
    case "OFC":
        return ""
    case "F1":
        return "L"
    case "NC":
        return "L"
    case "NCS":
        return "L"
    case "NCT":
        return "L"
    case "IRL":
        return "L"
    case "PGA":
        return "R"
    case "LPGA":
        return "R"
    case "NLL":
        return "Q"
    case "PLL":
        return "Q"
    case "LNCAAM":
        return "Q"
    case "LNCAAF":
        return "Q"
    case "VNCAAM":
        return "S"
    case "VNCAAF":
        return "S"
    default:
        return ""
    }
}
