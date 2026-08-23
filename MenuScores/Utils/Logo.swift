//
//  Logo.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-23.
//

import Foundation

func darkLogoURL(from logoURL: String?, teamID: String?, league: String?) -> String? {
    guard let logoURL else {
        return nil
    }

    if teamID == "20", league == "nhl" {
        return logoURL.replacingOccurrences(
            of: "/500/scoreboard/",
            with: "/500-dark/scoreboard/"
        )
    }

    if teamID == "21", league == "nhl" {
        return logoURL.replacingOccurrences(
            of: "/500/scoreboard/",
            with: "/500-dark/scoreboard/"
        )
    }

    if teamID == "23", league == "nhl" {
        return logoURL.replacingOccurrences(
            of: "/500/scoreboard/",
            with: "/500-dark/scoreboard/"
        )
    }

    if teamID == "9", league == "mlb" {
        return logoURL.replacingOccurrences(
            of: "/500/scoreboard/",
            with: "/500-dark/scoreboard/"
        )
    }

    if teamID == "10", league == "mlb" {
        return logoURL.replacingOccurrences(
            of: "/500/scoreboard/",
            with: "/500-dark/scoreboard/"
        )
    }

    return logoURL
}
