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
    case "NBA", "WNBA":
        return "Q"
    case "NFL":
        return "Q"
    case "MLB":
        return ""
    case "F1":
        return "L"
    default:
        return ""
    }
}
