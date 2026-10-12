//
//  WeekRange.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-10-12.
//

import Foundation

func getNHLWeek() -> String {
    var calendar = Calendar.current
    calendar.firstWeekday = 2

    // Start of Week 1

    var startDateComponents = DateComponents()
    startDateComponents.year = 2026
    startDateComponents.month = 9
    startDateComponents.day = 28

    let today = Date()

    guard let startDate = calendar.date(from: startDateComponents) else {
        return "1"
    }

    let components = calendar.dateComponents([.weekOfYear], from: startDate, to: today)

    guard let weeksElapsed = components.weekOfYear, weeksElapsed >= 0 else {
        return "1"
    }

    let weekNumber = weeksElapsed + 1
    return String(weekNumber)
}
