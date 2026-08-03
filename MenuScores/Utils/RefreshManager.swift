//
//  RefreshManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-08-03.
//

import SwiftUI

class RefreshManager: NSObject, ObservableObject {
    static let shared = RefreshManager()
    var timer: Timer?

    // Refresh Interval Settings

    let selectedOption = UserDefaults.standard.string(forKey: "refreshInterval") ?? "15 seconds"

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

    let enableNHL = UserDefaults.standard.bool(forKey: "enableNHL")
    let enableHNCAAM = UserDefaults.standard.bool(forKey: "enableHNCAAM")
    let enableHNCAAF = UserDefaults.standard.bool(forKey: "enableHNCAAF")

    let enableNBA = UserDefaults.standard.bool(forKey: "enableNBA")
    let enableWNBA = UserDefaults.standard.bool(forKey: "enableWNBA")
    let enableNCAAM = UserDefaults.standard.bool(forKey: "enableNCAAM")
    let enableNCAAF = UserDefaults.standard.bool(forKey: "enableNCAAF")

    let enableNFL = UserDefaults.standard.bool(forKey: "enableNFL")
    let enableFNCAA = UserDefaults.standard.bool(forKey: "enableFNCAA")

    let enableMLB = UserDefaults.standard.bool(forKey: "enableMLB")
    let enableBNCAA = UserDefaults.standard.bool(forKey: "enableBNCAA")
    let enableSNCAA = UserDefaults.standard.bool(forKey: "enableSNCAA")

    let enableF1 = UserDefaults.standard.bool(forKey: "enableF1")
    let enableNC = UserDefaults.standard.bool(forKey: "enableNC")
    let enableNCS = UserDefaults.standard.bool(forKey: "enableNCS")
    let enableNCT = UserDefaults.standard.bool(forKey: "enableNCT")
    let enableIRL = UserDefaults.standard.bool(forKey: "enableIRL")

    let enablePGA = UserDefaults.standard.bool(forKey: "enablePGA")
    let enableLPGA = UserDefaults.standard.bool(forKey: "enableLPGA")

    let enableMLS = UserDefaults.standard.bool(forKey: "enableMLS")
    let enableNWSL = UserDefaults.standard.bool(forKey: "enableNWSL")
    let enableUEFA = UserDefaults.standard.bool(forKey: "enableUEFA")
    let enableEUEFA = UserDefaults.standard.bool(forKey: "enableEUEFA")
    let enableWUEFA = UserDefaults.standard.bool(forKey: "enableWUEFA")
    let enableMEX = UserDefaults.standard.bool(forKey: "enableMEX")
    let enableFRA = UserDefaults.standard.bool(forKey: "enableFRA")
    let enableNED = UserDefaults.standard.bool(forKey: "enableNED")
    let enablePOR = UserDefaults.standard.bool(forKey: "enablePOR")
    let enableEPL = UserDefaults.standard.bool(forKey: "enableEPL")
    let enableWEPL = UserDefaults.standard.bool(forKey: "enableWEPL")
    let enableESP = UserDefaults.standard.bool(forKey: "enableESP")
    let enableGER = UserDefaults.standard.bool(forKey: "enableGER")
    let enableITA = UserDefaults.standard.bool(forKey: "enableITA")

    let enableFFWC = UserDefaults.standard.bool(forKey: "enableFFWC")
    let enableFFWWC = UserDefaults.standard.bool(forKey: "enableFFWWC")
    let enableFFWCQUEFA = UserDefaults.standard.bool(forKey: "enableFFWCQUEFA")
    let enableCONCACAF = UserDefaults.standard.bool(forKey: "enableCONCACAF")
    let enableCONMEBOL = UserDefaults.standard.bool(forKey: "enableCONMEBOL")
    let enableCAF = UserDefaults.standard.bool(forKey: "enableCAF")
    let enableAFC = UserDefaults.standard.bool(forKey: "enableAFC")
    let enableOFC = UserDefaults.standard.bool(forKey: "enableOFC")

    let enableATP = UserDefaults.standard.bool(forKey: "enableATP")
    let enableWTA = UserDefaults.standard.bool(forKey: "enableWTA")

    let enableUFC = UserDefaults.standard.bool(forKey: "enableUFC")

    let enableNLL = UserDefaults.standard.bool(forKey: "enableNLL")
    let enablePLL = UserDefaults.standard.bool(forKey: "enablePLL")
    let enableLNCAAM = UserDefaults.standard.bool(forKey: "enableLNCAAM")
    let enableLNCAAF = UserDefaults.standard.bool(forKey: "enableLNCAAF")

    let enableVNCAAM = UserDefaults.standard.bool(forKey: "enableVNCAAM")
    let enableVNCAAF = UserDefaults.standard.bool(forKey: "enableVNCAAF")

    let enableOMIHC = UserDefaults.standard.bool(forKey: "enableOMIHC")
    let enableOWIHC = UserDefaults.standard.bool(forKey: "enableOWIHC")
    let enableOMB = UserDefaults.standard.bool(forKey: "enableOMB")
    let enableOWB = UserDefaults.standard.bool(forKey: "enableOWB")

    // Refresh System

    @MainActor
    func performRefesh() async {}

    // Auto Refresh System

    func startTimer(action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: currentInterval, repeats: true) { _ in
            action()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
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
        stopTimer()
    }
}
