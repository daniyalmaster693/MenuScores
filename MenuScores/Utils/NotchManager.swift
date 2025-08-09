//
//  NotchManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import KeyboardShortcuts
import SwiftUI

var localCornerMonitor: Any?
var globalCornerMonitor: Any?

extension KeyboardShortcuts.Name {
    static let notchActivation = Self("notchActivation")
}

class NotchViewModel: ObservableObject {
    @Published var game: Event?

    @Published var currentGameID: String
    @Published var currentGameState: String
    @Published var previousGameState: String?

    init(currentGameID: String = "", currentGameState: String = "", previousGameState: String? = nil) {
        self.currentGameID = currentGameID
        self.currentGameState = currentGameState
        self.previousGameState = previousGameState
    }
}
