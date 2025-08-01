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
    case "CFL":
        return "Q"
    case "FNCAA":
        return "Q"
    case "MLB":
        return ""
    case "BNCAA":
        return ""
    case "SNCAA":
        return ""
    case "F1":
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
    default:
        return ""
    }
}
