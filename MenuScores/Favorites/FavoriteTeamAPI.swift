//
//  TeamURL.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-06-29.
//

import Foundation

enum FavoriteTeams {
    static var teamsURL: URL {
        URL(
            string:
            "https://site.api.espn.com/apis/site/v2/sports/hockey/nhl/teams"
        )!
    }
}
