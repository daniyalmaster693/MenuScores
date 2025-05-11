//
//  SettingsView.swift
//  MenuScores
//
//  Created by Daniyal Master on 2025-05-11.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {

        }
        .frame(maxWidth: 600, maxHeight: .infinity)
        .onDisappear {
                    NSApp.setActivationPolicy(.accessory)
                    NSApp.deactivate()
                }
    }
}
