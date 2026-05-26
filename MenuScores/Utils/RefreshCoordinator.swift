//
//  RefreshCoordinator.swift
//  MenuScores
//

import Combine
import Foundation

enum RefreshInterval {
    static func timeInterval(for selectedOption: String) -> TimeInterval {
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
}

/// Single main-run-loop timer for background score updates (replaces per-menu timers).
@MainActor
final class RefreshCoordinator {
    static let shared = RefreshCoordinator()

    private var timerCancellable: AnyCancellable?
    private var interval: TimeInterval = 15
    private var onTick: (() async -> Void)?

    private(set) var isActive = false

    private init() {}

    func configure(interval: TimeInterval, onTick: @escaping () async -> Void) {
        self.interval = interval
        self.onTick = onTick
        reconcileTimer()
    }

    func setInterval(_ interval: TimeInterval) {
        self.interval = interval
        reconcileTimer()
    }

    func setShouldRun(_ shouldRun: Bool) {
        guard shouldRun != isActive else { return }
        isActive = shouldRun
        reconcileTimer()
    }

    private func reconcileTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        guard isActive, let onTick else { return }

        timerCancellable = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                Task { await onTick() }
            }
    }
}
