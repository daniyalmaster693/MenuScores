//
//  WeekRange.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-19.
//

import Foundation

func getWeekStart() -> String {
    let calendar = Calendar.current
    let today = Date()
    let weekday = calendar.component(.weekday, from: today)
    let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let startDateString = formatter.string(from: startOfWeek)

    return startDateString
}

func getWeekEnd() -> String {
    let calendar = Calendar.current
    let today = Date()
    let weekday = calendar.component(.weekday, from: today)

    let endOfWeek = calendar.date(byAdding: .day, value: 7 - weekday, to: today)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let endDateString = formatter.string(from: endOfWeek)
    return endDateString
}
