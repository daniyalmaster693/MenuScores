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
    content.sound = .default
    
    let request = UNNotificationRequest(identifier: "gameComplete_\(gameId)", content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request)
}
