//
//  FavoriteGameNotification.swift
//  MenuScores
//
//  Created by Claude on 2025-02-24.
//

import Foundation
import UserNotifications

func favoriteGameStartNotification(teamName: String, gameTitle: String, gameId: String) {
    let content = UNMutableNotificationContent()
    content.title = "\(teamName) Game Started!"
    content.body = gameTitle
    content.interruptionLevel = .timeSensitive
    content.sound = .default

    let request = UNNotificationRequest(
        identifier: "favoriteGameStart_\(gameId)",
        content: content,
        trigger: nil
    )
    UNUserNotificationCenter.current().add(request)
}

func favoriteGameCompleteNotification(teamName: String, gameTitle: String, gameId: String, finalScore: String) {
    let content = UNMutableNotificationContent()
    content.title = "\(teamName) Game Finished!"
    content.body = finalScore.isEmpty ? gameTitle : "\(gameTitle)\n\(finalScore)"
    content.interruptionLevel = .timeSensitive
    content.sound = .default

    let request = UNNotificationRequest(
        identifier: "favoriteGameComplete_\(gameId)",
        content: content,
        trigger: nil
    )
    UNUserNotificationCenter.current().add(request)
}
