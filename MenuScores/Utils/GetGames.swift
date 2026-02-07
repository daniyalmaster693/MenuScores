//
//  getGAmes.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

class getGames {
    func getGamesArray(url: URL) async throws -> [Event] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(
            ScoreboardResponse.self, from: data
        )
        return decoded.events
    }

    func getTennisArray(url: URL) async throws -> [TennisEvent] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(
            TennisResponse.self, from: data
        )
        return decoded.events
    }
}
