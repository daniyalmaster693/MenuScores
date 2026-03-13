//  DateFormat.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.

import Foundation

private let espnDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    return formatter
}()

func formattedDate(from dateString: String) -> String {
    if let gameDate = espnDateFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy"
        return outputFormatter.string(from: gameDate)
    }
    return "Invalid Date"
}

func sortableDate(from dateString: String) -> Date {
    espnDateFormatter.date(from: dateString) ?? .distantPast
}
