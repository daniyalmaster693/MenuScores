//
//  NotchManager.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-08-05.
//

import DynamicNotchKit
import SwiftUI

class DynamicNotchManager {
    static let shared = DynamicNotchManager()

    private init() {}

    private var _currentNotch: (any DynamicNotchControllable)? = nil

    var currentNotch: (any DynamicNotchControllable)? {
        get { _currentNotch }
        set {
            Task {
                await _currentNotch?.hide()
                _currentNotch = newValue
            }
        }
    }

    func clearNotch() {
        Task {
            await currentNotch?.hide()
            currentNotch = nil
        }
    }
}
