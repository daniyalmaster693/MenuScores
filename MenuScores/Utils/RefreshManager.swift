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
