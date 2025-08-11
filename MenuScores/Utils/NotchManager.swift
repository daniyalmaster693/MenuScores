//
//  NotchManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import DynamicNotchKit
import KeyboardShortcuts
import SwiftUI

var localCornerMonitor: Any?
var globalCornerMonitor: Any?

extension KeyboardShortcuts.Name {
    static let notchActivation = Self("notchActivation")
}

class NotchViewModel: ObservableObject {
    static let shared = NotchViewModel()

    var notch: DynamicNotch<Info, CompactLeading, CompactTrailing>? = nil

    @Published var game: Event?
    var sport: String = ""

    @Published var currentGameID: String
    @Published var currentGameState: String
    @Published var previousGameState: String?

    init(currentGameID: String = "", currentGameState: String = "", previousGameState: String? = nil) {
        self.currentGameID = currentGameID
        self.currentGameState = currentGameState
        self.previousGameState = previousGameState
    }
}
