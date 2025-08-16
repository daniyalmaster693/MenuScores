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
    static let shared = NotchViewModel()
    private static var didRegisterShortcuts = false

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

        // Keyboard Shortcut

        if !Self.didRegisterShortcuts {
            Self.didRegisterShortcuts = true

            KeyboardShortcuts.onKeyDown(for: .notchActivation) {
                Task { @MainActor in
                    await NotchViewModel.shared.notch?.expand()
                }
            }

            KeyboardShortcuts.onKeyUp(for: .notchActivation) {
                Task { @MainActor in
                    await NotchViewModel.shared.notch?.compact()
                }
            }
        }
    }
}
