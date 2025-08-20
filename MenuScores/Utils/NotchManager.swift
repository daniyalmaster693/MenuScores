//
//  NotchManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-09.
//

import DynamicNotchKit
import KeyboardShortcuts
import SwiftUI

class NotchViewModel: ObservableObject {
    @AppStorage("notchScreenIndex") private var notchScreenIndex = 0

    static let shared = NotchViewModel()
    private static var didRegisterShortcuts = false

    var notch: DynamicNotch<Info, CompactLeading, CompactTrailing>? = nil

    @Published var game: Event?
    var sport: String = ""
    var league: String = ""

    @Published var currentGameID: String
    @Published var currentGameState: String
    @Published var previousGameState: String?

    init(currentGameID: String = "", currentGameState: String = "", previousGameState: String? = nil) {
        self.currentGameID = currentGameID
        self.currentGameState = currentGameState
        self.previousGameState = previousGameState

        // Keyboard Shortcut

        if !Self.didRegisterShortcuts {
            Self.didRegisterShortcuts = true

            KeyboardShortcuts.onKeyDown(for: .notchActivation) {
                Task { @MainActor in
                    let screens = NSScreen.screens
                    if screens.indices.contains(self.notchScreenIndex) {
                        await NotchViewModel.shared.notch?.expand(on: screens[self.notchScreenIndex])
                    }
                }
            }

            KeyboardShortcuts.onKeyUp(for: .notchActivation) {
                Task { @MainActor in
                    let screens = NSScreen.screens
                    if screens.indices.contains(self.notchScreenIndex) {
                        await NotchViewModel.shared.notch?.compact(on: screens[self.notchScreenIndex])
                    }
                }
            }
        }
    }
}
