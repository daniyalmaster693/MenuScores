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
    
    @AppStorage("notchAlerts") private var enableNotchAlerts = true
    @AppStorage("alertsTimer") private var alertsTimer: Double = 7.0
    
    static let shared = NotchViewModel()
    private static var didRegisterShortcuts = false
    
    var notch: DynamicNotch<Info, CompactLeading, CompactTrailing>? = nil
    
    @Published var game: Event?
    @Published var racingCompetition: RaceEvent?
    @Published var tennisCompetition: TennisCompetition?
    @Published var fightCompetition: FightCompetitions?
    
    var sport: String = ""
    var league: String = ""
    
    @Published var currentGameID: String
    @Published var currentGameState: String
    @Published var previousGameState: String?
    
    private var alertTask: Task<Void, Never>?
    
    // Notch Methods
    
    @MainActor
    func pinGame(
        game: Event? = nil,
        racingCompetition: RaceEvent? = nil,
        fightCompetition: FightCompetitions? = nil,
        tennisCompetition: TennisCompetition? = nil,
        sport: String,
        league: String,
        gameID: String = "",
        gameState: String = ""
    ) async {
        self.game = game
        self.racingCompetition = racingCompetition
        self.fightCompetition = fightCompetition
        self.tennisCompetition = tennisCompetition
        
        self.sport = sport
        self.league = league
        
        self.currentGameID = gameID
        self.currentGameState = gameState
        self.previousGameState = nil
        
        if let existingNotch = self.notch {
            await existingNotch.hide()
            self.notch = nil
        }
        
        let newNotch = DynamicNotch(
            hoverBehavior: .all,
            style: .notch
        ) {
            Info(notchViewModel: self, sport: "\(self.sport)", league: "\(self.league)")
        } compactLeading: {
            CompactLeading(notchViewModel: self, sport: "\(self.sport)", league: "\(self.league)")
        } compactTrailing: {
            CompactTrailing(notchViewModel: self, sport: "\(self.sport)", league: "\(self.league)")
        }

        self.notch = newNotch
        await newNotch.compact(on: NSScreen.screens[self.notchScreenIndex])
    }
    
    @MainActor
    func triggerAlert() {
        guard self.enableNotchAlerts else { return }
        
        self.alertTask?.cancel()
        
        self.alertTask = Task { @MainActor in
            let screens = NSScreen.screens
            if screens.indices.contains(self.notchScreenIndex) {
                await NotchViewModel.shared.notch?.expand(on: screens[self.notchScreenIndex])
                try? await Task.sleep(for: .seconds(self.alertsTimer))
                await NotchViewModel.shared.notch?.compact(on: screens[self.notchScreenIndex])
            }
        }
    }
    
    // Keyboard Shortcut
    
    init(currentGameID: String = "", currentGameState: String = "", previousGameState: String? = nil) {
        self.currentGameID = currentGameID
        self.currentGameState = currentGameState
        self.previousGameState = previousGameState
        
        // Keyboard Shortcut
        
        if KeyboardShortcuts.Name.notchActivation.shortcut == nil {
            KeyboardShortcuts.setShortcut(.init(.h, modifiers: [.command, .option]), for: .notchActivation)
        }
        
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
