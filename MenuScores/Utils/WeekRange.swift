//
//  WeekRange.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-19.
//

import Foundation

func getDynamicRange() -> (start: String, end: String) {
    let calendar = Calendar.current
    let today = Date()

    let startDate = calendar.date(byAdding: .day, value: -3, to: today)!
    let endDate = calendar.date(byAdding: .day, value: 5, to: today)!

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let startString = formatter.string(from: startDate)
    let endString = formatter.string(from: endDate)

    return (start: startString, end: endString)
}
