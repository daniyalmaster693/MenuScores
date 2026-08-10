//  DateFormat.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.

import Foundation

func formattedDate(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"

    if let gameDate = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.timeStyle = .none
        outputFormatter.dateStyle = .short

        return outputFormatter.string(from: gameDate)
    }

    return "Invalid Date"
}
