//
//  GameComplete.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-17.
//

import Foundation
import UserNotifications

func gameCompleteNotification(gameId: String, gameTitle: String, newState: String) {
    guard newState == "post" else { return }

    let content = UNMutableNotificationContent()
    content.title = "Game Finished!"
    content.body = "\(gameTitle)"
    content.interruptionLevel = .timeSensitive
    content.sound = .default

    let request = UNNotificationRequest(identifier: "gameComplete_\(gameId)", content: content, trigger: nil)
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
