//
//  GameStart.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-17.
//

import Foundation
import UserNotifications


func gameStartNotification(gameId: String, gameTitle: String, newState: String) {
    guard newState == "in" else { return }
    
    let content = UNMutableNotificationContent()
    content.title = "Game Started!"
    content.body = "\(gameTitle)"
    content.interruptionLevel = .timeSensitive
    content.sound = .default
    
    let request = UNNotificationRequest(identifier: "gameStart_\(gameId)", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request)
}
