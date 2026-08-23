//
//  DateRange.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-19.
//

import Foundation

func getRangeStart() -> String {
    let calendar = Calendar.current
    let today = Date()
    let startDate = calendar.date(byAdding: .day, value: -2, to: today)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: startDate)
}

func getRangeEnd() -> String {
    let calendar = Calendar.current
    let today = Date()
    let endDate = calendar.date(byAdding: .day, value: 2, to: today)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: endDate)
}

func getCurrentDate() -> String {
    let today = Date()

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: today)
    return dateString
}

func getCurrentYearMonth() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMM"
    return formatter.string(from: Date())
}
