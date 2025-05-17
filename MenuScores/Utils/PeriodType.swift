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
    case "MLB":
        return ""
    case "F1":
        return "L"
    case "PGA":
        return "R"
    case "LPGA":
        return "R"
    case "NLL":
        return "Q"
    default:
        return ""
    }
}
