//
//  RefreshManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-03.
//

import SwiftUI

@MainActor
class RefreshManager: NSObject, ObservableObject {
    static let shared = RefreshManager()
    var timer: Timer?

    // Refresh Interval Settings

    private var selectedOption: String {
        UserDefaults.standard.string(forKey: "refreshInterval") ?? "15 seconds"
    }

    private var currentInterval: TimeInterval {
        switch selectedOption {
        case "10 seconds": return 10
        case "15 seconds": return 15
        case "20 seconds": return 20
        case "30 seconds": return 30
        case "40 seconds": return 40
        case "50 seconds": return 50
        case "1 minute": return 60
        case "2 minutes": return 120
        case "5 minutes": return 300
        default: return 15
        }
    }

    // Toggled League Settings

    var enableNHL: Bool { UserDefaults.standard.bool(forKey: "enableNHL") }
    var enableHNCAAM: Bool { UserDefaults.standard.bool(forKey: "enableHNCAAM") }
    var enableHNCAAF: Bool { UserDefaults.standard.bool(forKey: "enableHNCAAF") }

    var enableNBA: Bool { UserDefaults.standard.bool(forKey: "enableNBA") }
    var enableWNBA: Bool { UserDefaults.standard.bool(forKey: "enableWNBA") }
    var enableNCAAM: Bool { UserDefaults.standard.bool(forKey: "enableNCAAM") }
    var enableNCAAF: Bool { UserDefaults.standard.bool(forKey: "enableNCAAF") }

    var enableNFL: Bool { UserDefaults.standard.bool(forKey: "enableNFL") }
    var enableFNCAA: Bool { UserDefaults.standard.bool(forKey: "enableFNCAA") }

    var enableMLB: Bool { UserDefaults.standard.bool(forKey: "enableMLB") }
    var enableBNCAA: Bool { UserDefaults.standard.bool(forKey: "enableBNCAA") }
    var enableSNCAA: Bool { UserDefaults.standard.bool(forKey: "enableSNCAA") }

    var enableF1: Bool { UserDefaults.standard.bool(forKey: "enableF1") }
    var enableNC: Bool { UserDefaults.standard.bool(forKey: "enableNC") }
    var enableNCS: Bool { UserDefaults.standard.bool(forKey: "enableNCS") }
    var enableNCT: Bool { UserDefaults.standard.bool(forKey: "enableNCT") }
    var enableIRL: Bool { UserDefaults.standard.bool(forKey: "enableIRL") }

    var enablePGA: Bool { UserDefaults.standard.bool(forKey: "enablePGA") }
    var enableLPGA: Bool { UserDefaults.standard.bool(forKey: "enableLPGA") }

    var enableMLS: Bool { UserDefaults.standard.bool(forKey: "enableMLS") }
    var enableNWSL: Bool { UserDefaults.standard.bool(forKey: "enableNWSL") }
    var enableUEFA: Bool { UserDefaults.standard.bool(forKey: "enableUEFA") }
    var enableEUEFA: Bool { UserDefaults.standard.bool(forKey: "enableEUEFA") }
    var enableWUEFA: Bool { UserDefaults.standard.bool(forKey: "enableWUEFA") }
    var enableMEX: Bool { UserDefaults.standard.bool(forKey: "enableMEX") }
    var enableFRA: Bool { UserDefaults.standard.bool(forKey: "enableFRA") }
    var enableNED: Bool { UserDefaults.standard.bool(forKey: "enableNED") }
    var enablePOR: Bool { UserDefaults.standard.bool(forKey: "enablePOR") }
    var enableEPL: Bool { UserDefaults.standard.bool(forKey: "enableEPL") }
    var enableWEPL: Bool { UserDefaults.standard.bool(forKey: "enableWEPL") }
    var enableESP: Bool { UserDefaults.standard.bool(forKey: "enableESP") }
    var enableGER: Bool { UserDefaults.standard.bool(forKey: "enableGER") }
    var enableITA: Bool { UserDefaults.standard.bool(forKey: "enableITA") }

    var enableFFWC: Bool { UserDefaults.standard.bool(forKey: "enableFFWC") }
    var enableFFWWC: Bool { UserDefaults.standard.bool(forKey: "enableFFWWC") }
    var enableFFWCQUEFA: Bool { UserDefaults.standard.bool(forKey: "enableFFWCQUEFA") }
    var enableCONCACAF: Bool { UserDefaults.standard.bool(forKey: "enableCONCACAF") }
    var enableCONMEBOL: Bool { UserDefaults.standard.bool(forKey: "enableCONMEBOL") }
    var enableCAF: Bool { UserDefaults.standard.bool(forKey: "enableCAF") }
    var enableAFC: Bool { UserDefaults.standard.bool(forKey: "enableAFC") }
    var enableOFC: Bool { UserDefaults.standard.bool(forKey: "enableOFC") }

    var enableATP: Bool { UserDefaults.standard.bool(forKey: "enableATP") }
    var enableWTA: Bool { UserDefaults.standard.bool(forKey: "enableWTA") }

    var enableUFC: Bool { UserDefaults.standard.bool(forKey: "enableUFC") }

    var enableNLL: Bool { UserDefaults.standard.bool(forKey: "enableNLL") }
    var enablePLL: Bool { UserDefaults.standard.bool(forKey: "enablePLL") }
    var enableLNCAAM: Bool { UserDefaults.standard.bool(forKey: "enableLNCAAM") }
    var enableLNCAAF: Bool { UserDefaults.standard.bool(forKey: "enableLNCAAF") }

    var enableVNCAAM: Bool { UserDefaults.standard.bool(forKey: "enableVNCAAM") }
    var enableVNCAAF: Bool { UserDefaults.standard.bool(forKey: "enableVNCAAF") }

    var enableOMIHC: Bool { UserDefaults.standard.bool(forKey: "enableOMIHC") }
    var enableOWIHC: Bool { UserDefaults.standard.bool(forKey: "enableOWIHC") }
    var enableOMB: Bool { UserDefaults.standard.bool(forKey: "enableOMB") }
    var enableOWB: Bool { UserDefaults.standard.bool(forKey: "enableOWB") }

    // Data Models

    private let nhlVM = GamesListView()
    private let hncaamVM = GamesListView()
    private let hncaafVM = GamesListView()

    private let nbaVM = GamesListView()
    private let wnbaVM = GamesListView()
    private let ncaamVM = GamesListView()
    private let ncaafVM = GamesListView()

    private let nflVM = GamesListView()
    private let fncaaVM = GamesListView()

    private let mlbVM = GamesListView()
    private let bncaaVM = GamesListView()
    private let sncaaVM = GamesListView()

    private let f1VM = GamesListView()
    private let ncVM = GamesListView()
    private let ncsVM = GamesListView()
    private let nctVM = GamesListView()
    private let irlVM = GamesListView()

    private let pgaVM = GamesListView()
    private let lpgaVM = GamesListView()

    private let uefaVM = GamesListView()
    private let euefaVM = GamesListView()
    private let wuefaVM = GamesListView()
    private let mlsVM = GamesListView()
    private let nwslVM = GamesListView()
    private let mexVM = GamesListView()
    private let fraVM = GamesListView()
    private let nedVM = GamesListView()
    private let porVM = GamesListView()
    private let eplVM = GamesListView()
    private let weplVM = GamesListView()
    private let espVM = GamesListView()
    private let gerVM = GamesListView()
    private let itaVM = GamesListView()

    private let atpVM = TennisListView()
    private let wtaVM = TennisListView()

//    private let ufcVM = GamesListView()

    private let nllVM = GamesListView()
    private let pllVM = GamesListView()
    private let lncaamVM = GamesListView()
    private let lncaafVM = GamesListView()

    private let vncaamVM = GamesListView()
    private let vncaafVM = GamesListView()

    private let omihcVM = GamesListView()
    private let owihcVM = GamesListView()
    private let ombVM = GamesListView()
    private let owbVM = GamesListView()

    private let ffwcVM = GamesListView()
    private let ffwwcVM = GamesListView()
    private let ffwcquefaVM = GamesListView()
    private let conmebolVM = GamesListView()
    private let concacafVM = GamesListView()
    private let cafVM = GamesListView()
    private let afcVM = GamesListView()
    private let ofcVM = GamesListView()

    // Refresh System

    @MainActor
    func performRefesh() async {}

    // Auto Refresh System

    func startTimer(action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: currentInterval, repeats: true) { _ in
            action()
        }
    }

    override init() {
        super.init()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            Task { @MainActor in
                await self?.performRefesh()
            }
        }

        startTimer { [weak self] in
            Task { @MainActor in
                await self?.performRefesh()
            }
        }
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
