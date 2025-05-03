<<<<<<< HEAD
//
=======
>>>>>>> f82593691137da31ddf1ee8c06c578c113b13da6
//  DateFormat.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-03.
<<<<<<< HEAD
//

import Foundation

func formattedDate(from dateString: String) -> String {
=======

import Foundation

func formattedTime(from dateString: String) -> String {
>>>>>>> f82593691137da31ddf1ee8c06c578c113b13da6
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

    if let gameDate = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
<<<<<<< HEAD
        outputFormatter.timeStyle = .none
        outputFormatter.dateStyle = .short
=======
        outputFormatter.timeStyle = .short
        outputFormatter.dateStyle = .none
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current
>>>>>>> f82593691137da31ddf1ee8c06c578c113b13da6

        return outputFormatter.string(from: gameDate)
    }

    return "Invalid Date"
}
