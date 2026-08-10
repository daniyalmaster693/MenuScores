//  DateFormat.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.

import Foundation

func formattedTime(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    if let gameDate = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.timeStyle = .short
        outputFormatter.dateStyle = .none
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: gameDate)
    }

    return "Invalid Date"
}

func formattedDateForAPI(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    guard let gameDate = inputFormatter.date(from: dateString) else {
        return ""
    }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyyMMdd"
    outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    return outputFormatter.string(from: gameDate)
}
